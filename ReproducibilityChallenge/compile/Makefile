# ----- Make Macros -----

CXX = mpicxx
CXXFLAGS = -std=c++11 -fopenmp 
OPTFLAGS = -O3 

NVCC = nvcc
NVCCFLAGS = -lineinfo -O3 -std=c++11 -gencode arch=compute_70,code=sm_70 -ccbin=mpicxx -Xcompiler -fopenmp # -qsmp=omp -Xptxas="-v"

GPU_LD_FLAGS = -ccbin=mpicxx -Xcompiler -fopenmp
CPU_LD_FLAGS = -fopenmp

CPU_TARGETS = memxct.cpu
GPU_TARGETS = memxct.gpu
GPU_OBJECTS = gpu/src/main.o gpu/src/raytrace.o gpu/src/kernels.o
CPU_OBJECTS = cpu/src/main.o cpu/src/raytrace.o cpu/src/kernels.o

# ----- Make Rules -----


all:	cpu	gpu

gpu:	$(GPU_TARGETS)

cpu:	$(CPU_TARGETS)

%.o: %.cpp
	${CXX} ${CXXFLAGS} ${OPTFLAGS} $^ -c -o $@

%.o : %.cu
	${NVCC} ${NVCCFLAGS} $^ -c -o $@

memxct.gpu: $(GPU_OBJECTS)
	$(NVCC) -o $@ $(GPU_OBJECTS) $(GPU_LD_FLAGS)

memxct.cpu: $(CPU_OBJECTS)
	$(CXX) -o $@ $(CPU_OBJECTS) $(CPU_LD_FLAGS)


clean:
	rm -f $(GPU_TARGETS) gpu/src/*.o gpu/src/*.o.* *.txt *.bin core *.html *.xml
	rm -f $(CPU_TARGETS) cpu/src/*.o cpu/src/*.o.* *.txt *.bin core *.html *.xml
