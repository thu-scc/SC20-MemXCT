# ----- Make Macros -----

CXX = mpicxx
CXXFLAGS = -std=c++11 -fopenmp 
OPTFLAGS = -O3 

NVCC = nvcc
NVCCFLAGS = -lineinfo -O3 -std=c++11 -gencode arch=compute_70,code=sm_70 -ccbin=mpicxx -Xcompiler -fopenmp # -qsmp=omp -Xptxas="-v"

LD_FLAGS = -ccbin=mpicxx -Xcompiler -fopenmp

TARGETS = memxct.gpu
OBJECTS = gpu/src/main.o gpu/src/raytrace.o gpu/src/kernels.o

# ----- Make Rules -----

all:	$(TARGETS)

%.o: %.cpp
	${CXX} ${CXXFLAGS} ${OPTFLAGS} $^ -c -o $@

%.o : %.cu
	${NVCC} ${NVCCFLAGS} $^ -c -o $@

memxct.gpu: $(OBJECTS)
	$(NVCC) -o $@ $(OBJECTS) $(LD_FLAGS)

clean:
	rm -f $(TARGETS) src/*.o src/*.o.* *.txt *.bin core *.html *.xml
