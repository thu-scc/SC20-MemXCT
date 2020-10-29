#!/bin/bash

#NPROC=$1
#DATA=$2

# TILE SIZE
#SPATSIZE=$3
#SPECSIZE=$3
#
# BLOCK SIZE
#PROJBLOCK=$4
#BACKBLOCK=$4
#
# BUFFER SIZE
#PROJBUFF=$5
#BACKBUFF=$5


source script/para.sh $2 $3 $3 $4 $4 $5 $5

FILE="./result/gorgon/cpu/$1.$2.$3.$3.$4.$4.$5.$5.out"

srun -n $1 ./memxct.cpu > ${FILE}

tot_bw=$(grep -E 'av: \w+.\w+' -o < $FILE | awk '{print $2}')
av_gflops=$(grep -E 'avGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
prep_time=$(grep -E 'PREPROCESSING TIME: \w+.\w+[+-]\w+' -o $FILE | awk '{print $3}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

#echo $tot_gflops,$tot_bw,$prep_time,$tot_time
echo Use $2 dataset by $1 proc
echo proc, tile_size, block_size, buffer_size, tot_gflops, tot_bw, tot_time
echo $1,$3,$4,$5,$tot_gflops,$tot_bw,$tot_time
echo tot_gflops $tot_gflops
echo av_gflops $av_gflops
#echo tot_bw $tot_bw GB/s
#echo prep_time $prep_time sec
#echo tot_time $tot_time sec