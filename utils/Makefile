
ADDER ?= 1
MULT ?= 0
DIVIDER ?= 0
PIPELINE ?= 0
UART ?= 0
DRAM ?= 0
SYSTEM ?= 0

#//////////////////////////////////////////////////////////
#		E N V I R O N M E N T    F I L E S
#//////////////////////////////////////////////////////////


GPU_SV = +incdir+../	\

BASE_FILES = +incdir+../gpu_base/	\

GRAP_PIPELINE = +incdir+../hard_layer/grap_pipeline/adder_agent/	\
				+incdir+../hard_layer/grap_pipeline/mult_agent/ 	\
				+incdir+../hard_layer/grap_pipeline/divider_agent/	\
				+incdir+../hard_layer/grap_pipeline/pipeline_agent/	\

MEMORY_MANAGER = +incdir+../hard_layer/memory_manager/uart_agent/ \

SOFT_LAYER = +incdir+../soft_layer/	\

GPU_INTERFACES =../gpu_base/base_ifc.sv										\
				../hard_layer/grap_pipeline/adder_agent/adder_ifc.sv 		\
				../hard_layer/grap_pipeline/mult_agent/mult_ifc.sv			\
				../hard_layer/grap_pipeline/divider_agent/divider_ifc.sv	\
#				../hard_layer/grap_pipeline/pipeline_agent/pipeline_ifc.sv	\
				../hard_layer/memory_manager/uart_agent/uart_ifc.sv			\

#//////////////////////////////////////////////////////////
#				V E R I L O G    F I L E S
#//////////////////////////////////////////////////////////


RTL =	+incdir+../../rtl/graphic_pipeline/adder/			\
		+incdir+../../rtl/graphic_pipeline/multiplier/		\
		+incdir+../../rtl/graphic_pipeline/divider/			\
		+incdir+../../rtl/graphic_pipeline/graphic_pipeline/\
		+incdir+../../rtl/memory_manager/					\

#//////////////////////////////////////////////////////////
#					T E S T S
#//////////////////////////////////////////////////////////


ifeq ($(ADDER),1)
	TEST = 'GPU_PIPELINE_ADDER'
endif

ifeq ($(MULT),1)
	TEST = 'GPU_PIPELINE_MULT'
endif

ifeq ($(DIVIDER),1)
	TEST = 'GPU_PIPELINE_DIVIDER'
endif

ifeq ($(PIPELINE),1)
	TEST = 'GPU_PIPELINE'
endif

ifeq ($(UART),1)
	TEST = 'GPU_MEMORY_UART'
endif


#//////////////////////////////////////////////////////////


IRUN_ARGS = -sv '+tcl+dump.tcl' -access +rwc

UVM_ARGS = -uvm -define $(TEST)


ALL:
	irun $(IRUN_ARGS) $(UVM_ARGS) $(RTL) $(BASE_FILES) $(GRAP_PIPELINE) $(MEMORY_MANAGER) $(SOFT_LAYER) $(GPU_INTERFACES) ../gpu_pkg.sv ../gpu_tb.v

clean:
	rm -rf INCA_libs/ waves/ irun.* *.log
