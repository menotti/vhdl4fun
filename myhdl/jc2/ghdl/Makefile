#On Windows systems comment the line below and use: make TESTBENCH=t_<EntityName>
TESTBENCH = `ls -1 t_*.vhd | sed 's/\(.*\)\..*/\1/'`

GHDL_CMD = ghdl
GHDL_FLAGS  = -fexplicit --std=02 --ieee=synopsys --warn-no-vital-generic

#GHDL_SIM_OPT = --assert-level=error
#GHDL_SIM_OPT = --stop-time=500ns
#GHDL_SIM_OPT = --disp-tree --stats --stop-time=21us
GHDL_SIM_OPT = --stop-time=510ns --ieee-asserts=disable

WAVEFORM_VIEWER = gtkwave

# Unix
REMOVE_CMD = rm 
# Windows
#REMOVE_CMD = del 

all : compile run view

compile :
	$(GHDL_CMD) -a $(GHDL_FLAGS) *.vhd
	$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCH)

run :
	$(GHDL_CMD) -r $(GHDL_FLAGS) $(TESTBENCH) $(GHDL_SIM_OPT) --vcd=$(TESTBENCH).vcd 

view :
	$(WAVEFORM_VIEWER) $(TESTBENCH).vcd &

clean :
	$(GHDL_CMD) --clean
	$(REMOVE_CMD) *.vcd work-obj93.cf
