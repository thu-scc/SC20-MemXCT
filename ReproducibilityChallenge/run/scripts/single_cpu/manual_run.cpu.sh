#!/bin/bash
# set environment before executing this script

# Usage: ./manual_run.cpu.sh ${NTHREAD} ${DATA} ${TILE_SIZE} ${BLOCK_SIZE} ${BUFFER_SIZE} 
# Run this script on target machine

NTHREAD=$1 # = CORE_PER_SOCKET
DATA=$2

# TILE SIZE
SPATSIZE=$3
SPECSIZE=$3
#
# BLOCK SIZE
PROJBLOCK=$4
BACKBLOCK=$4
#
# BUFFER SIZE
PROJBUFF=$5
BACKBUFF=$5


HOSTFILE=$6


HOSTNAME=$(hostname)
TARGET_DIR="../../output/single_cpu/$HOSTNAME"
mkdir -p $TARGET_DIR
FILE="$TARGET_DIR/$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.out"
BIN="$TARGET_DIR/$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.bin"


source ../para.sh $NTHREAD $DATA $SPATSIZE $SPECSIZE $PROJBLOCK $BACKBLOCK $PROJBUFF $BACKBUFF $BIN

mpirun -np 1 --bind-to none ../../../compile/cpu-build/memxct.cpu > ${FILE}

tot_bw=$(grep -E 'av: \w+.\w+' -o < $FILE | awk '{print $2}')
av_gflops=$(grep -E 'avGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
prep_time=$(grep -E 'PREPROCESSING TIME: \w+.\w+[+-]\w+' -o $FILE | awk '{print $3}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

#echo $tot_gflops,$tot_bw,$prep_time,$tot_time
echo Use $DATA dataset by 1 tasks, $NTHREAD threads
echo -e tile_size   "\t" $SPATSIZE
echo -e block_size  "\t" $PROJBLOCK
echo -e buffer_size "\t" $PROJBUFF kb
echo -e tot_gflops  "\t" $tot_gflops
echo -e av_gflops   "\t" $av_gflops
echo -e tot_bw_util "\t" $tot_bw GB/s
echo -e prep_time   "\t" $prep_time sec
echo -e tot_time    "\t" $tot_time sec

