#!/bin/bash
# i1
. /opt/spack/share/spack/setup-env.sh
spack load intel-parallel-studio@cluster.2020.4
export RUNNER=mpirun

./manual_run.cpu.sh $*
