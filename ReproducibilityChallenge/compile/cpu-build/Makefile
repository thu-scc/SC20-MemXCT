# ----- Make Macros -----

ICC_FOUND := $(shell command -v mpiicpc 2>/dev/null)

ifdef ICC_FOUND
	CXX = mpiicpc
	CXXFLAGS = -std=c++11 -qopenmp -qopt-report=1 -qopt-report-phase=vec
	OPTFLAGS = -O3
	CPU_LD_FLAGS = -qopenmp
else
	CXX = mpicxx
	CXXFLAGS = -std=c++11 -fopenmp
	OPTFLAGS = -O3
	CPU_LD_FLAGS = -fopenmp
endif

CPU_TARGETS = memxct.cpu
CPU_OBJECTS = main.o raytrace.o kernels.o

# ----- Make Rules -----


all:	cpu

cpu:	$(CPU_TARGETS)

%.o: ../cpu-code/src/%.cpp
	${CXX} ${CXXFLAGS} ${OPTFLAGS} $^ -c -o $@
memxct.cpu: $(CPU_OBJECTS)
	$(CXX) -o $@ $(CPU_OBJECTS) $(CPU_LD_FLAGS)

clean:
	rm -f $(CPU_TARGETS) $(CPU_OBJECTS) *.txt *.bin core *.html *.xml
