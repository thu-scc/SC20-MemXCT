ICC_FOUND := $(shell command -v mpiicpc 2>/dev/null)

ifdef ICC_FOUND
	CXX = icc
	CXXFLAGS = -xCORE-AVX512 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20
	OPTFLAGS = -O3
	CPU_LD_FLAGS = -qopenmp
else
	CXX = gcc
	CXXFLAGS = -fopenmp
	OPTFLAGS = -O3
	CPU_LD_FLAGS = -fopenmp
endif


all: stream

stream: stream.c
	$(CXX) $(CXXFLAGS) ${OPTFLAGS} stream.c -o stream

clean:
	rm -f stream *.o
