#!/bin/bash
# amd yes
. /opt/spack/share/spack/setup-env.sh
spack load openmpi@3.1.5
export RUNNER=mpirun

./manual_run.cpu.sh $*
