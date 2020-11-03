# ----- Make Macros -----

CXX = mpiicpc
CXXFLAGS = -std=c++11 -qopenmp -qopt-report=1 -qopt-report-phase=vec
OPTFLAGS = -O3 

CPU_LD_FLAGS = -qopenmp

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
