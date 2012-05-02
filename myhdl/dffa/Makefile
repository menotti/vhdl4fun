WAVEFORM_VIEWER = gtkwave

# Unix
REMOVE_CMD = rm
PYTHON_INT = /usr/bin/python
# Windows
#REMOVE_CMD = del 

all : compile view

compile :
	$(PYTHON_INT) *.py

view :
	$(WAVEFORM_VIEWER) *.vcd &

clean :
	$(REMOVE_CMD) *.vcd *.vhd *.v *.pyc
