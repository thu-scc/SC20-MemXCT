#!/bin/bash

#DATA=$1

# TILE SIZE
#SPATSIZE=$2
#SPECSIZE=$3
#
# BLOCK SIZE
#PROJBLOCK=$4
#BACKBLOCK=$5
#
# BUFFER SIZE
#PROJBUFF=$6
#BACKBUFF=$7


source script/para.sh $1 $2 $3 $4 $5 $6 $7

FILE="./result/gpu.$1.$2.$3.$4.$5.$6.$7.out"

./memxct.gpu > ${FILE}
./script/parse.sh ${FILE}