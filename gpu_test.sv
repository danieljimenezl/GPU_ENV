class gpu_test extends uvm_test;

    gpu_config CONFIG;
    gpu_env env;

    //--------------------------------------------
    // G R A P I C H  P I P E L I N E
    adder_sequence adder_seq;
    mult_sequence mult_seq;
    divider_sequence divider_seq;

    `uvm_component_utils_begin(gpu_test)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new (string name = "gpu_test", uvm_component parent);
        super.new(name, parent);
        CONFIG = gpu_config::type_id::create("gpu_config",this);

        env = new("env",this);
    endfunction : new


    //--------------------------------------------
    // run_phase
    task run_phase(uvm_phase phase);
        phase.raise_objection(.obj(this));

        if(CONFIG.get_value("GPU_PIPELINE_ADDER"))
            adder_test();
        else if(CONFIG.get_value("GPU_PIPELINE_MULT"))
            mult_test();
        else if(CONFIG.get_value("GPU_PIPELINE_DIVIDER"))
            divider_test();

        phase.drop_objection(.obj(this));
    endtask : run_phase


    //--------------------------------------------
    // adder_test
    task adder_test();
        adder_seq = adder_sequence::type_id::create(.name("adder_seq"), .contxt(get_full_name()));
        assert(adder_seq.randomize());
        fork
            adder_seq.start(env.adder_seq);
        join
    endtask : adder_test


    //--------------------------------------------
    // Mult test
    task mult_test();
        mult_seq = mult_sequence::type_id::create(.name("mult_seq"), .contxt(get_full_name()));
        assert(mult_seq.randomize());
        fork
            mult_seq.start(env.mult_seq);
        join
    endtask : mult_test


    //--------------------------------------------
    // Divider test
    task divider_test();
        divider_seq = divider_sequence::type_id::create(.name("divider_seq"), .contxt(get_full_name()));
        assert(divider_seq.randomize());
        fork
            divider_seq.start(env.divider_seq);
        join
    endtask : divider_test

endclass : gpu_test
