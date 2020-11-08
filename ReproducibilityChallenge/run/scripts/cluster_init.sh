#!/bin/bash
# Usage: srun -n ${NODE_NUM} -N ${NODE_NUM} ./cluster_init.sh

sudo apt install nfs-common -y
sudo apt install gcc -y
sudo apt install g++ -y
sudo apt install make -y
sudo mkdir /mnt/exports/data
sudo chmod 777 /mnt/exports
sudo mount 10.0.0.7:/mnt/exports/data /mnt/exports/data
sudo cp /mnt/exports/data/machine-operation/limits.conf /etc/security/limits.conf

. /mnt/exports/data/spack/share/spack/setup-env.sh
spack load gcc@8.3.0
spack compiler find
spack compiler add
