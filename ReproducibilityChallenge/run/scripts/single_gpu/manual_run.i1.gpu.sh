#!/bin/bash
# i1
. /opt/spack/share/spack/setup-env.sh
spack load cuda@10.0.130 gcc@6.5.0

./manual_run.gpu.sh $*
