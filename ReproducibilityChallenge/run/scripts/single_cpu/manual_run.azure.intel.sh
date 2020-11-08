#!/bin/bash
. /mnt/exports/data/spack/share/spack/setup-env.sh
spack load /uqfcm7a
cd ../../../compile
./clean.sh
./build_cpu.sh
cd -
./manual_run.cpu.sh $*
