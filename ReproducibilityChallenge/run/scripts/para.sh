#!/bin/bash

# Usage: source para.sh ${NTHREAD} ${DATA} ${SPATSIZE} ${SPECSIZE} ${PROJBLOCK} ${BACKBLOCK} ${PROJBUFF} ${BACKBUFF} ${OUTPUT_FILE}

NTHREAD=$1
DATA=$2

# TILE SIZE
SPATSIZE=$3
SPECSIZE=$4

# BLOCK SIZE
PROJBLOCK=$5
BACKBLOCK=$6

# BUFFER SIZE
PROJBUFF=$7
BACKBUFF=$8

# OUPUT FILE
export OUTFILE=$9


DATASET=../../../../datasets

if [[ $DATA = ADS1 ]]; then
  export NUMTHE=360
  export NUMRHO=256
  export THEFILE=$DATASET/ADS1_theta.bin
  export SINFILE=$DATASET/ADS1_sinogram.bin
elif [[ $DATA = ADS2 ]]; then
  export NUMTHE=750
  export NUMRHO=512
  export THEFILE=$DATASET/ADS2_theta.bin
  export SINFILE=$DATASET/ADS2_sinogram.bin
elif [[ $DATA = ADS3 ]]; then 
  export NUMTHE=1500
  export NUMRHO=1024
  export THEFILE=$DATASET/ADS3_theta.bin
  export SINFILE=$DATASET/ADS3_sinogram.bin
elif [[ $DATA = ADS4 ]]; then
  export NUMTHE=2400
  export NUMRHO=2048
  export THEFILE=$DATASET/ADS4_theta.bin
  export SINFILE=$DATASET/ADS4_sinogram.bin
elif [[ $DATA = CDS1 ]]; then
  export NUMTHE=750
  export NUMRHO=512
  export THEFILE=$DATASET/CDS1_theta.bin
  export SINFILE=$DATASET/CDS1_sinogram.bin
elif [[ $DATA = CDS2 ]]; then
  export NUMTHE=375
  export NUMRHO=1024
  export THEFILE=$DATASET/CDS2_theta.bin
  export SINFILE=$DATASET/CDS2_sinogram.bin
elif [[ $DATA = CDS3 ]]; then
  export NUMTHE=1501
  export NUMRHO=2048
  export THEFILE=$DATASET/CDS3_theta.bin
  export SINFILE=$DATASET/CDS3_sinogram.bin
else
  echo "Unknown Datasets $DATA"
  exit 1
fi


#echo Use $DATA

export PIXSIZE=1
export NUMITER=24

export SPATSIZE=$SPATSIZE
export SPECSIZE=$SPECSIZE
export PROJBLOCK=$PROJBLOCK
export BACKBLOCK=$BACKBLOCK
export PROJBUFF=$PROJBUFF
export BACKBUFF=$BACKBUFF


export OMP_NUM_THREADS=$NTHREAD
