#!/bin/bash

# set environment before executing this script!

export OMP_PLACES=cores
export OMP_PROC_BIND=close

GPU=$1 #(v100, p100, k80)
GPU_PER_NODE=$2
NTHREAD=$3 # =CORE_PER_GPU=TOTAL_CORE/GPU_NUM
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

# Usage: ./manual_run.openmpi.gpu.sh v100 ${GPU_PER_NODE} ${NTHREAD} ${HOSTFILE} ${DATASET} ${TILE_SIZE} ${BLOCK_SIZE} ${BUFFER_SIZE}


HOTNAME=$(hostname)
mkdir -p ../../output/original/$HOSTNAME/gpu

for NNODE in 1 2 4; do
  NTASK=`expr $GPU_PER_NODE \* $NNODE`
  FILE="../../output/original/$HOSTNAME/gpu/$GPU.$NTASK.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.out"
  BIN="../../output/original/$HOSTNAME/gpu/$GPU.$NTASK.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.bin"
  source ../para.sh $NTHREAD $DATA $SPATSIZE $SPECSIZE $PROJBLOCK $BACKBLOCK $PROJBUFF $BACKBUFF $BIN

  mpirun -np $NTASK -hostfile $HOSTFILE -npernode $GPU_PER_NODE -bind-to core ../../../compile/gpu-build/$1/memxct.gpu > ${FILE}

  tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

  proj_info=$(grep -E ' proj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}')
  proj_kernel_time=$(echo $proj_info | awk '{print $1}')
  proj_communication_time=$(echo $proj_info | awk '{print $2}')
  proj_reduction_time=$(echo $proj_info | awk '{print $3}')

  backproj_info=$(grep -E ' backproj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}')
  backproj_kernel_time=$(echo $backproj_info | awk '{print $3}')
  backproj_communication_time=$(echo $backproj_info | awk '{print $2}')
  backproj_reduction_time=$(echo $backproj_info | awk '{print $1}')

  echo Use $DATA dataset by $NNODE nodes, $NTASK tasks, $NTHREAD threads per device
  echo task, thread, tile_size, block_size, buffer_size
  echo $NTASK,$NTHREAD,$4,$5,$6
  echo -e "proj_kernel_time         " $proj_kernel_time sec
  echo -e "proj_comm_time           " $proj_communication_time sec
  echo -e "proj_reduction_time      " $proj_reduction_time sec
  echo -e "backproj_kernel_time     " $backproj_kernel_time sec
  echo -e "backproj_comm_time       " $backproj_communication_time sec
  echo -e "backproj_reduction_time  " $backproj_reduction_time sec
  echo -e "tot_time                 " $tot_time sec
  echo -e "\n"

done