BASE_FILES = +incdir+../gpu_base/ \

IRUN_ARGS = -sv '+tcl+dump.tcl' -access +rwc

UVM_ARGS = -uvm

ALL:$
	irun $(IRUN_ARGS) $(UVM_ARGS) $(BASE_FILES) ../gpu_pkg.sv ../gpu_tb.v
