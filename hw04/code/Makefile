LIST = main.F waf.F
LIST_o = $(LIST:.F=.o)
TARGET = a.out

FC = mpifort
FLAGS = -O3 -free -check all -debug all -g -traceback
LDFLAGS =  -I/home/der0318/.local/include 
LDLIBS =  -L/home/der0318/.local/lib -lnetcdff -lnetcdf

all: $(TARGET)

$(LIST_o) : %.o: %.F
	$(FC) $(FLAGS) $(LDFLAGS) -c $<

$(TARGET) : $(LIST_o) 
	$(FC) $(FLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)

a.out: main.o waf.o
main.o: waf.o

clean:
	rm -rf $(LIST_o) $(TARGET)

