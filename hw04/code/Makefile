LIST = main.F waf.F
LIST_o = $(LIST:.F=.o)
TARGET = a.out

FC = mpifort
DEBUG =  -CB -g -traceback #-check all -debug all -g -traceback
FLAGS = -O3 -free -mcmodel=large -heap-arrays 10 -shared-intel $(DEBUG)
LDFLAGS =  -I/home/der0318/.local/include 
LDLIBS =  -L/home/der0318/.local/lib -lnetcdff -lnetcdf

all: $(TARGET)

python:
	cp waf.F waf.f90
	python -m numpy.f2py -c waf.f90  -m waf

$(LIST_o) : %.o: %.F
	$(FC) $(FLAGS) $(LDFLAGS) -c $<

$(TARGET) : $(LIST_o) 
	$(FC) $(FLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)

a.out: main.o waf.o
main.o: waf.o

clean:
	rm -rf $(LIST_o) $(TARGET) *.so *.f90

