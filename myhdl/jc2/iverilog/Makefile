# super gambi
TESTBENCH = `ls -1 t_*.v | sed 's/\(.*\)\..*/\1/'`
V_FILE = `ls *.v|grep -v "t_*"`

WAVEFORM_VIEWER = gtkwave

# Unix
REMOVE_CMD = rm
# Windows
#REMOVE_CMD = del 


all : compile run view

compile :
	iverilog -o $(TESTBENCH).out $(TESTBENCH).v $(V_FILE)

run :
	vvp $(TESTBENCH).out

view :
	$(WAVEFORM_VIEWER) $(TESTBENCH).vcd &

clean :
	$(REMOVE_CMD) *.vcd *.out
