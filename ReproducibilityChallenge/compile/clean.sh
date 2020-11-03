#!/bin/sh
make -C cpu-build clean
make -C gpu-build/k80 clean
make -C gpu-build/p100 clean
make -C gpu-build/v100 clean
