WAVEFORM_VIEWER = gtkwave

# Unix
REMOVE_CMD = rm
PYTHON_INT = /usr/bin/python
# Windows
#REMOVE_CMD = del 

all : compile view

# especificando porque o jc2 foi dividido em 2 arquivos
compile :
	$(PYTHON_INT) t_jc2.py

view :
	$(WAVEFORM_VIEWER) *.vcd &

clean :
	$(REMOVE_CMD) *.vcd* *.vhd *.v *.pyc
