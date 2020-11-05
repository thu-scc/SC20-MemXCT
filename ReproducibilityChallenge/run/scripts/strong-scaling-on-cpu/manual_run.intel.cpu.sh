#!/bin/bash
# set environment and alloc nodes before executing this script!

export OMP_PLACES=cores
export OMP_PROC_BIND=close

# scaling for 1, 2, 4 nodes

# Usage: ./manual_run.openmpi.cpu.sh ${CPU_PER_NODE} ${NTHREAD} ${HOSTFILE} ${DATA} ${TILE_SIZE} ${BLOCK_SIZE} ${BUFFER_SIZE}

CPU_PER_NODE=$1
NTHREAD=$2   # (=CORE_PER_CPU)
HOSTFILE=$3
DATA=$4

# TILE SIZE
SPATSIZE=$5
SPECSIZE=$5
#
# BLOCK SIZE
PROJBLOCK=$6
BACKBLOCK=$6
#
# BUFFER SIZE
PROJBUFF=$7
BACKBUFF=$7


source ../para.sh $NTHREAD $DATA $SPATSIZE $SPECSIZE $PROJBLOCK $BACKBLOCK $PROJBUFF $BACKBUFF


HOSTNAME=$(hostname)
mkdir -p ../../output/original/$HOSTNAME/cpu

for NNODE in 1 2 4; do
  NTASK=`expr $CPU_PER_NODE \* $NNODE`
  FILE="../../output/original/$HOSTNAME/cpu/$NTASK.$NTHREAD.$DATA.$SPATSIZE.$SPECSIZE.$PROJBLOCK.$BACKBLOCK.$PROJBUFF.$BACKBUFF.out"

  echo [CMD] "mpirun -np $NTASK -hostfile $HOSTFILE -ppn $CPU_PER_NODE -genv I_MPI_PIN_DOMAIN socket ../../../compile/cpu-build/memxct.cpu > ${FILE}"
  mpirun -np $NTASK -hostfile $HOSTFILE -ppn $CPU_PER_NODE -genv I_MPI_PIN_DOMAIN socket ../../../compile/cpu-build/memxct.cpu > ${FILE}

  tot_time=$(grep -E 'Total Time: \w+.\w+[+-]\w+' -o < $FILE | awk '{print $3}')

  proj_info=$(grep -E ' proj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}')
  proj_kernel_time=$(echo $proj_info | awk '{print $1}')
  proj_communication_time=$(echo $proj_info | awk '{print $2}')
  proj_reduction_time=$(echo $proj_info | awk '{print $3}')

  backproj_info=$(grep -E ' backproj: \w+.\w+[+-]\w+ \(\w+.\w+[+-]\w+ \w+.\w+[+-]\w+ \w+.\w+[+-]\w+\)' -o < $FILE | awk -F '[()]' '{print $2}')
  backproj_kernel_time=$(echo $backproj_info | awk '{print $3}')
  backproj_communication_time=$(echo $backproj_info | awk '{print $2}')
  backproj_reduction_time=$(echo $backproj_info | awk '{print $1}')

  echo Use $DATA dataset by $NNODE nodes, $NTASK tasks, $NTHREAD threads
  echo task, thread, tile_size, block_size, buffer_size, tot_gflops, tot_bw, tot_time
  echo $NTASK,$NTHREAD,$4,$5,$6,$tot_gflops,$tot_bw,$tot_time
  echo proj_kernel_time $proj_kernel_time sec
  echo proj_communication_time $proj_communication_time sec
  echo proj_reduction_time $proj_reduction_time sec
  echo backproj_kernel_time $backproj_kernel_time sec
  echo backproj_communication_time $backproj_communication_time sec
  echo backproj_reduction_time $backproj_reduction_time sec
  echo tot_time $tot_time sec
done


