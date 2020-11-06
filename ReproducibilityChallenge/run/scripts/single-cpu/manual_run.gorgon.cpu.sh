#!/bin/bash
# gorgon
module load icc impi

NTASK=$1
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





HOSTNAME=$(hostname)
mkdir -p ../../output/original/$HOSTNAME/cpu
FILE="../../output/original/$HOSTNAME/cpu/$NTASK.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.out"
BIN="../../output/original/$HOSTNAME/cpu/$NTASK.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.bin"

source ../para.sh $NTHREAD $DATA $SPATSIZE $SPECSIZE $PROJBLOCK $BACKBLOCK $PROJBUFF $BACKBUFF $BIN

#mpirun -np $1 ../../../compile/cpu-build/memxct.cpu > ${FILE}
srun -n $NTASK ../../../compile/cpu-build/memxct.cpu > ${FILE}

tot_bw=$(grep -E 'av: \w+.\w+' -o < $FILE | awk '{print $2}')
av_gflops=$(grep -E 'avGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
prep_time=$(grep -E 'PREPROCESSING TIME: \w+.\w+[+-]\w+' -o $FILE | awk '{print $3}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

#echo $tot_gflops,$tot_bw,$prep_time,$tot_time
echo Use $DATA dataset by $NTASK tasks, $NTHREAD threads
echo task, thread, tile_size, block_size, buffer_size, tot_gflops, tot_bw, tot_time
echo $NTASK,$NTHREAD,$4,$5,$6,$tot_gflops,$tot_bw,$tot_time
echo tot_gflops $tot_gflops
echo av_gflops $av_gflops
echo tot_bw $tot_bw GB/s
echo prep_time $prep_time sec
echo tot_time $tot_time sec

