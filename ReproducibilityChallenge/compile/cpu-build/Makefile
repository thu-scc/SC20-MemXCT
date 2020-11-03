# ----- Make Macros -----

CXX = mpicxx
CXXFLAGS = -std=c++11 -fopenmp 
OPTFLAGS = -O3 

CPU_LD_FLAGS = -fopenmp

CPU_TARGETS = memxct.cpu
CPU_OBJECTS = ../cpu-code/src/main.o ../cpu-code/src/raytrace.o ../cpu-code/src/kernels.o

# ----- Make Rules -----


all:	cpu

cpu:	$(CPU_TARGETS)

%.o: %.cpp
	${CXX} ${CXXFLAGS} ${OPTFLAGS} $^ -c -o $@
memxct.cpu: $(CPU_OBJECTS)
	$(CXX) -o $@ $(CPU_OBJECTS) $(CPU_LD_FLAGS)

clean:
	rm -f $(CPU_TARGETS) $(CPU_OBJECTS) *.txt *.bin core *.html *.xml
