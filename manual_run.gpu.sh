#!/bin/bash

#DATA=$1

# TILE SIZE
#SPATSIZE=$2
#SPECSIZE=$2
#
# BLOCK SIZE
#PROJBLOCK=$3
#BACKBLOCK=$3
#
# BUFFER SIZE
#PROJBUFF=$4
#BACKBUFF=$4


source script/para.sh $1 $2 $2 $3 $3 $4 $4

FILE="./result/gorgon/$5/gpu.$1.$2.$2.$3.$3.$4.$4.out"

./memxct.gpu > ${FILE}

tot_bw=$(grep -E 'tot: \w+.\w+' -o < $FILE | awk '{print $2}')
tot_gflops=$(grep -E 'totGFLOPS: \w+.\w+' -o < $FILE | awk '{print $2}')
prep_time=$(grep -E 'PREPROCESSING TIME: \w+.\w+[+-]\w+' -o $FILE | awk '{print $3}')
tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

#echo $tot_gflops,$tot_bw,$prep_time,$tot_time
echo Use $1 dataset
echo tile_size, block_size, buffer_size, gflops, bw, tot_time
echo $2,$3,$4,$tot_gflops,$tot_bw,$tot_time
echo tot_gflops $tot_gflops
#echo tot_bw $tot_bw GB/s
#echo prep_time $prep_time sec
#echo tot_time $tot_time sec