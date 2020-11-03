#!/bin/sh
make -C cpu-build
make -C gpu-build/k80
make -C gpu-build/p100
make -C gpu-build/v100
