#On Windows systems comment the line below and use: make TESTBENCH=t_<EntityName>
TESTBENCH = `ls -1 ../t_*.v |sed 's!.*/\(.*\).v!\1!'`

IVERILOG_CMD = iverilog

WAVEFORM_VIEWER = gtkwave

# Unix
REMOVE_CMD = rm 
# Windows
#REMOVE_CMD = del 

all : compile run view

compile :
	iverilog -o $(TESTBENCH).out ../*.v

run :
	vvp $(TESTBENCH).out

view :
	$(WAVEFORM_VIEWER) $(TESTBENCH).vcd $(TESTBENCH).sav &

clean :
	$(REMOVE_CMD) *.vcd *.out
