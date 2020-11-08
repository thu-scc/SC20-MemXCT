#!/bin/sh
# ref: https://github.com/SC-Tech-Program/Author-Kit/blob/master/collect_environment.sh
# sudo apt install -y jq inxi lsscsi ipmitool
set -x

# azure
curl -H 'Metadata: true' http://169.254.169.254/metadata/instance?api-version=2020-06-01 2>/dev/null >metadata.json
echo 'VM size:' $(jq -r .compute.vmSize metadata.json)
echo 'VM name:' $(jq -r .compute.name metadata.json)
echo 'VM location:' $(jq -r .compute.location metadata.json)
echo 'Resource group:' $(jq -r .compute.resourceGroupName metadata.json)
echo 'Private ip address:' $(jq -r .network.interface[0].ipv4.ipAddress[0].privateIpAddress metadata.json)
echo 'Public ip address:' $(jq -r .network.interface[0].ipv4.ipAddress[0].publicIpAddress metadata.json)
echo 'CPU model': $(lscpu | sed -nr '/Model name/ s/.*:\s*(.*)/\1/p')

# compilers
which gcc
gcc --version
which icc
icc --version
#which nvcc
#nvcc --version

# cpu
lscpu || cat /proc/cpuinfo
gcc -march=native -Q --help=target | grep march

# env
unset SSH_CLIENT
unset SSH_CONNECTION
env | sed "s/$USER/USER/g"

# distribution
lsb_release -a
uname -a

cat /proc/meminfo

# devices
inxi -F -c0
lsblk -a
lsscsi -s
#nvidia-smi
(lshw -short -quiet -sanitize || lspci) | cat

# hpc package manager
spack find
module list

# loaded package
spack find --loaded -l
