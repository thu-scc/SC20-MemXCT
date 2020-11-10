#!/bin/bash
# set environment and alloc nodes before executing this script!

# scaling for 1, 2, 4 nodes

# Usage: ./manual_run.openmpi.cpu.sh ${CPU_PER_NODE} ${NTHREAD} ${HOSTFILE} ${DATA} ${TILE_SIZE} ${BLOCK_SIZE} ${BUFFER_SIZE}

ITER=$1
CPU_PER_NODE=$2
NTHREAD=$3   # (=CORE_PER_CPU)
HOSTFILE=$4
DATA=$5

# TILE SIZE
SPATSIZE=$6
SPECSIZE=$6
#
# BLOCK SIZE
PROJBLOCK=$7
BACKBLOCK=$7
#
# BUFFER SIZE
PROJBUFF=$8
BACKBUFF=$8




HOSTNAME=$(hostname)
TARGET_DIR="../../output/visualization"
mkdir -p $TARGET_DIR

NNODE=4
NTASK=`expr $CPU_PER_NODE \* $NNODE`
# Use NNODE as the name prefix so that figure scripts can know the node number
FILE="$TARGET_DIR/$ITER.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.out"
BIN="$TARGET_DIR/$ITER.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.bin"
source ../para.sh $NTHREAD $DATA $SPATSIZE $SPECSIZE $PROJBLOCK $BACKBLOCK $PROJBUFF $BACKBUFF $BIN

$(which mpirun) -np $NTASK --hostfile $HOSTFILE -bind-to none --npernode $CPU_PER_NODE ./inner.sh $ITER $NTHREAD $DATA $SPATSIZE $PROJBLOCK $PROJBUFF $BIN | tee ${FILE}
