#//////////////////////////////////////////////////////////
#	E N V I R O N M E N T    F I L E S
#//////////////////////////////////////////////////////////


BASE_FILES = +incdir+../gpu_base/ \

GRAP_PIPELINE = +incdir+../hard_layer/grap_pipeline/adder_agent/	\
				+incdir+../hard_layer/grap_pipeline/mult_agent/ 	\
				+incdir+../hard_layer/grap_pipeline/divider_agent/	\
				+incdir+../hard_layer/grap_pipeline/pipeline_agent/ \

GPU_INTERFACES =../gpu_base/base_ifc.sv										\
				../hard_layer/grap_pipeline/adder_agent/adder_ifc.sv		\
				../hard_layer/grap_pipeline/mult_agent/mult_ifc.sv 			\
				../hard_layer/grap_pipeline/divider_agent/divider_ifc.sv	\
				../hard_layer/grap_pipeline/pipeline_agent/pipeline_ifc.sv	\


#//////////////////////////////////////////////////////////
#	V E R I L O G    F I L E S
#//////////////////////////////////////////////////////////


RTL = 	../../rtl/graphic_pipeline/adder/*.v			\
		../../rtl/graphic_pipeline/multiplier/*.v		\
		../../rtl/graphic_pipeline/divider/*.v			\
		../../rtl/graphic_pipeline/graphic_pipeline/*.v\


#//////////////////////////////////////////////////////////

IRUN_ARGS = -sv '+tcl+dump.tcl' -access +rwc

UVM_ARGS = -uvm


ALL:$
	irun $(IRUN_ARGS) $(UVM_ARGS) $(RTL) $(BASE_FILES) $(GRAP_PIPELINE) $(GPU_INTERFACES) ../gpu_pkg.sv ../gpu_tb.v

clean:
	rm -rf INCA_libs/ waves/ irun.*
