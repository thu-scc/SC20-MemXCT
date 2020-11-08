#!/bin/bash
# amd yes
. /mnt/exports/data/spack/share/spack/setup-env.sh
spack load /i2mlb2h
cd ../../../compile
./clean.sh
./build.sh
cd -
./manual_run.cpu.sh $*
