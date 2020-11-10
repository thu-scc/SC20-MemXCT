# Compilation

## Compilers and software

What's used:

- GCC 7.5.0 provided by Ubuntu 18
- OpenMPI 3.0.1 in Spack w/ ucx and CUDA support
- UCX 1.9.0 in Spack
- CUDA 10.0.130 in Spack
- Intel Parallel Studio Cluster 2020.2 in Spack

No modifications have been made to source code because they compile without problems. We wrote our own Makefiles to detect compilers and setup correct optimization flags based on CPU or GPU architectures.

Specifically, you can install these dependencies by:

```shell
# GCC
sudo apt install -y g++
# Spack
. /opt/spack/share/spack/setup-env.sh
# OpenMPI, UCX and CUDA
spack install openmpi@3.0.1 fabrics=ucx +cuda "^cuda@10.0.130"
# Intel w/ licenses put into /opt/intel/licenses
spack install intel-parallel-studio@cluster.2020.2
```

## Compilation scripts

The directory structure of `compile` directory is as follows:

```tree
compile/
├── F16s_v2.txt
├── HB60rs.txt
├── NC24r_Promo.txt
├── NC24rs_v2.txt
├── NC24rs_v3.txt
├── README.md
├── STREAM
│   ├── HISTORY.txt
│   ├── LICENSE.txt
│   ├── Makefile
│   ├── README
│   ├── mysecond.c
│   ├── stream.c
│   └── stream.f
├── build.sh
├── build_cpu.sh
├── build_gpu.sh
├── build_stream.sh
├── clean.sh
├── cpu-build
│   ├── Makefile
│   ├── kernels.optrpt
│   ├── main.optrpt
│   └── raytrace.optrpt
├── cpu-code
│   ├── Makefile.frontera
│   ├── Makefile.summit
│   ├── Makefile.theta
│   ├── readme.md
│   ├── run.sh
│   ├── run.sh.frontera
│   ├── run.sh.summit
│   ├── run.sh.theta
│   ├── src
│   │   ├── kernels.cpp
│   │   ├── main.cpp
│   │   ├── raytrace.cpp
│   │   └── vars.h
│   ├── submit.sh.frontera
│   ├── submit.sh.summit
│   └── submit.sh.theta
├── gpu-build
│   ├── Makefrag
│   ├── k80
│   │   └── Makefile
│   ├── p100
│   │   └── Makefile
│   └── v100
│       └── Makefile
└── gpu-code
    ├── Makefile.bluewaters
    ├── Makefile.frontera
    ├── Makefile.summit
    ├── README.md
    ├── run.sh.bluewaters
    ├── run.sh.frontera
    ├── run.sh.summit
    ├── src
    │   ├── kernels.cu
    │   ├── main.cpp
    │   ├── raytrace.cpp
    │   ├── vars.h
    │   └── vars_gpu.h
    ├── submit.sh.bluewaters
    ├── submit.sh.frontera
    └── submit.sh.summit

10 directories, 56 files

```

The five directories contain:

- cpu-build: The build directory for CPU code, containing Makefile and ICC optimization reports
- cpu-code: The unmodified source code of MemXCT-CPU
- gpu-build: The build directory for GPU code. It has three subdirectories for K80, P100 and V100 respectively. They differ in nvcc arch flags.
- gpu-code: The unmodified source code of MemXCT-GPU
- STREAM: The unmodified source code of STREAM, the de facto industry standard benchmarkfor measuring sustained memory bandwidth. It is taken from [GitHub](https://github.com/jeffhammond/STREAM) and we updated its Makefile for our needs.

And there are four scripts for building CPU, GPU and STREAM source code. Before running compilation scripts, a compiler environment is expected. A example usage would be:

```shell
# load spack
. /opt/spack/share/spack/setup-env.sh
# build cpu code and STREAM
spack load openmpi@3.0.1
# or, use intel-parallel-studio
# spack load intel-parallel-studio@cluster.2020.2
./build_cpu.sh
./build_stream.sh
# build gpu code
spack load cuda@10.0.130
./build_cpu.sh
```

After compilation, executables should be produced at: `cpu-build/memxct.cpu`, `gpu-build/k80/memxct.gpu`, `gpu-build/p100/memxct.gpu`, `gpu-build/v100/memxct.gpu` and `STREAM/stream`. Vectorization report is located at `cpu-build/{kernels,main,raytrace}.opt.rpt` if Intel compiler is used.

## Cloud environment

We have use the following SKUs in the Azure Cloud:

- HB60rs
- F16s v2
- NF24r Promo
- NC24rs v2
- NC24rs v3

We have included the environment info in plaintexts in this directory, for example, you can find the info of `HB60rs` in `HB60rs.txt`. It is the output of a script adapted from [Author-Kit](https://github.com/SC-Tech-Program/Author-Kit) which queries Azure machine metadata as well. It contains machine SKU, cpu and memory info, hardware info and software used in compilation and runtime.

We also have an aggregated environment info file named `doc/scc20_team05_ExperimentalEnvironment.txt`.
