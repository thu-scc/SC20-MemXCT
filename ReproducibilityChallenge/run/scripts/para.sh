#!/bin/bash

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


if [[ $DATA = ADS1 ]]; then
  export NUMTHE=360
  export NUMRHO=256
  export THEFILE=../../../datasets/ADS1_theta.bin
  export SINFILE=../../../datasets/ADS1_sinogram.bin
  export OUTFILE=./recon.ADS1.bin
elif [[ $DATA = ADS2 ]]; then
  export NUMTHE=750
  export NUMRHO=512
  export THEFILE=../../../datasets/ADS2_theta.bin
  export SINFILE=../../../datasets/ADS2_sinogram.bin
  export OUTFILE=./recon.ADS2.bin
elif [[ $DATA = ADS3 ]]; then 
  export NUMTHE=1500
  export NUMRHO=1024
  export THEFILE=../../../datasets/ADS3_theta.bin
  export SINFILE=../../../datasets/ADS3_sinogram.bin
  export OUTFILE=./recon.ADS3.bin
elif [[ $DATA = ADS4 ]]; then
  export NUMTHE=2400
  export NUMRHO=2048
  export THEFILE=../../../datasets/ADS4_theta.bin
  export SINFILE=../../../datasets/ADS4_sinogram.bin
  export OUTFILE=./recon.ADS4.bin
else
  echo "Unkown Datasets $DATA"
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
