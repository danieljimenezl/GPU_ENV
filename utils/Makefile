BASE_FILES = +incdir+../gpu_base/ \

GRAP_PIPELINE = +incdir+../hard_layer/grap_pipeline/adder_agent/ \

IRUN_ARGS = -sv '+tcl+dump.tcl' -access +rwc

UVM_ARGS = -uvm

ALL:$
	irun $(IRUN_ARGS) $(UVM_ARGS) $(BASE_FILES) $(GRAP_PIPELINE) ../gpu_pkg.sv ../gpu_tb.v
