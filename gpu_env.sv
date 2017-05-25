class gpu_env extends uvm_env;

    gpu_config CONFIG;

    //--------------------------------------------
    // G R A P I C H  P I P E L I N E
    adder_agent         adder;
    mult_agent          mult;
    divider_agent       divider;
    pipeline_agent      pipeline;

    adder_sequencer     adder_seq;
    mult_sequencer      mult_seq;
    divider_sequencer   divider_seq;
    pipeline_sequencer  pipeline_seq;

    //--------------------------------------------
    // M E M O R Y  M A N A G E R
    //uart_agent      uart;
    //sram_agent      sram;
    //memory_agent    memory_controler;

    `uvm_component_utils_begin(gpu_env)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new (string name = "gpu_env", uvm_component parent);
        super.new(name, parent);
        CONFIG = gpu_config::type_id::create("gpu_config",this);
    endfunction : new


    //--------------------------------------------
    // build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        if(CONFIG.get_value("GPU_PIPELINE_ADDER")) begin
            adder = adder_agent::type_id::create("adder",this);
            adder_seq = adder_sequencer::type_id::create("adder_seq",this);
        end
        else if(CONFIG.get_value("GPU_PIPELINE_MULT")) begin
            mult = mult_agent::type_id::create("mult",this);
            mult_seq = mult_sequencer::type_id::create("mult_seq",this);
        end
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER")) begin
            divider = divider_agent::type_id::create("divider",this);
            divider_seq = divider_sequencer::type_id::create("divider_seq",this);
        end
        else if(CONFIG.get_value("GPU_PIPELINE")) begin
            pipeline = pipeline_agent::type_id::create("pipeline",this);
            pipeline_seq = pipeline_sequencer::type_id::create("pipeline_seq",this);
        end
    endfunction : build_phase


    //--------------------------------------------
    // connect phase
    function void connect_phase(uvm_phase phase);
        if(CONFIG.get_value("GPU_PIPELINE_ADDER"))
            adder.driver.seq_item_port.connect(adder_seq.seq_item_export);
        else if(CONFIG.get_value("GPU_PIPELINE_MULT"))
            mult.driver.seq_item_port.connect(mult_seq.seq_item_export);
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER"))
            divider.driver.seq_item_port.connect(divider_seq.seq_item_export);
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER"))
            pipeline.driver.seq_item_port.connect(pipeline_seq.seq_item_export);
    endfunction : connect_phase

endclass : gpu_env
