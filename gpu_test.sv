class gpu_test extends uvm_test;

    gpu_config CONFIG;
    gpu_env env;

    //--------------------------------------------
    // G R A P I C H  P I P E L I N E
    adder_sequence adder_seq;
    mult_sequence mult_seq;
    divider_sequence divider_seq;
    pipeline_sequence pipeline_seq;

    //--------------------------------------------
    // M E M O R Y  M A N A G E R
    uart_init_sequence uart_init_seq;
    uart_cam_config_sequence uart_cam_config_seq;
    uart_create_obj_sequence uart_create_obj_seq;
    uart_vert_config_sequence uart_vert_config_seq;
    uart_close_obj_sequence uart_close_obj_seq;
    uart_modify_obj_sequence uart_modify_obj_seq;


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
        else if(CONFIG.get_value("GPU_PIPELINE"))
            pipeline_test();
        else if(CONFIG.get_value("GPU_MEMORY_UART"))
            uart_test();
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

    //--------------------------------------------
    // Pipeline test
    task pipeline_test();
        pipeline_seq = pipeline_sequence::type_id::create(.name("pipeline_seq"), .contxt(get_full_name()));
        assert(pipeline_seq.randomize());
        fork
            pipeline_seq.start(env.pipeline_seq);
        join
    endtask : pipeline_test

    //--------------------------------------------
    // UART test
    task uart_test();
        uart_init_seq = uart_init_sequence::type_id::create(.name("uart_init_seq"), .contxt(get_full_name()));
        uart_cam_config_seq = uart_cam_config_sequence::type_id::create(.name("uart_cam_config_seq"), .contxt(get_full_name()));
        uart_create_obj_seq = uart_create_obj_sequence::type_id::create(.name("uart_create_obj_seq"), .contxt(get_full_name()));
        uart_vert_config_seq = uart_vert_config_sequence::type_id::create(.name("uart_vert_config_seq"), .contxt(get_full_name()));
        uart_close_obj_seq = uart_close_obj_sequence::type_id::create(.name("uart_close_obj_seq"), .contxt(get_full_name()));
        uart_modify_obj_seq = uart_modify_obj_sequence::type_id::create(.name("uart_modify_obj_seq"), .contxt(get_full_name()));

        assert(uart_init_seq.randomize());
        assert(uart_cam_config_seq.randomize());
        assert(uart_create_obj_seq.randomize());
        assert(uart_vert_config_seq.randomize());
        assert(uart_close_obj_seq.randomize());
        assert(uart_modify_obj_seq.randomize());

        uart_init_seq.start(env.uart_seq);
        uart_cam_config_seq.start(env.uart_seq);
        uart_create_obj_seq.start(env.uart_seq);
        uart_vert_config_seq.start(env.uart_seq);
        uart_close_obj_seq.start(env.uart_seq);
        uart_modify_obj_seq.start(env.uart_seq);

    endtask : uart_test

endclass : gpu_test
