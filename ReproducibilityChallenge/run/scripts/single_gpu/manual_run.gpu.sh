#!/bin/bash

export CUDA_VISIBLE_DEVICES=0
# set environment before executing this script!


GPU=$1 #(v100, p100, k80)
NTHREAD=$2
DATA=$3

# TILE SIZE
SPATSIZE=$4
SPECSIZE=$4
#
# BLOCK SIZE
PROJBLOCK=$5
BACKBLOCK=$5
#
# BUFFER SIZE
PROJBUFF=$6
BACKBUFF=$6

# Usage: ./manual_run.gpu.sh v100 ${NTHREAD} ${DATASET} ${TILE_SIZE} ${BLOCK_SIZE} ${BUFFER_SIZE}


HOTNAME=$(hostname)
TARGET_DIR="../../output/single_gpu/$HOSTNAME"
mkdir -p $TARGET_DIR
FILE="$TARGET_DIR/$GPU.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.out"
BIN="$TARGET_DIR/$GPU.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.bin"

source ../para.sh $NTHREAD $DATA $SPATSIZE $SPECSIZE $PROJBLOCK $BACKBLOCK $PROJBUFF $BACKBUFF $BIN

numactl --cpunodebind=0 -m 0 ../../../compile/gpu-build/$1/memxct.gpu > ${FILE}

tot_bw=$(grep -E 'av: \w+.\w+' -o < $FILE | awk '{print $2}')
av_gflops=$(grep -E 'avGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
prep_time=$(grep -E 'PREPROCESSING TIME: \w+.\w+[+-]\w+' -o $FILE | awk '{print $3}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

#echo $tot_gflops,$tot_bw,$prep_time,$tot_time
echo Use $DATA dataset by $GPU and $NTHREAD threads
echo gpu, thread, tile_size, block_size, buffer_size, tot_gflops, tot_bw, tot_time
echo $GPU,$NTHREAD,$4,$5,$6,$tot_gflops,$tot_bw,$tot_time
echo -e tot_gflops  "\t" $tot_gflops
echo -e av_gflops   "\t" $av_gflops
echo -e tot_bw      "\t" $tot_bw GB/s
echo -e prep_time   "\t" $prep_time sec
echo -e tot_time    "\t" $tot_time sec
