class gpu_config extends uvm_component;

    int config_db[string];
    real config_db_real[string];
    integer file;

    uvm_cmdline_processor cmd_args;

    `uvm_component_utils_begin(gpu_config)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new (string name, uvm_component parent);
        super.new(name, parent);
        cmd_args =  uvm_cmdline_processor::get_inst();

        // Graphic Pipeline
        config_db["GPU_PIPELINE_ADDER"] = 0;
        config_db["GPU_PIPELINE_MULT"] = 0;
        config_db["GPU_PIPELINE_DIVIDER"] = 0;
        config_db["GPU_PIPELINE"] = 0;
        config_db_real["GPU_PIPELINE_PRECISON"] = 0.01;

        // Memory Manager
        config_db["GPU_MEMORY_UART"] = 0;
        config_db["GPU_MEMORY_SRAM"] = 0;
        config_db["GPU_MEMORY_REFRESH"] = 0;

        // GPU
        config_db["GPU_SYSTEM_REFRESH"] = 0;

        set_config();
    endfunction : new


    //--------------------------------------------
    // Set configuration value
    function void set_config();
        string config_args[$];
        cmd_args.get_args(config_args);

        foreach ( config_args[s] ) begin
            if( config_args[s] == "-define" ) begin
                foreach ( config_db[r] ) begin
                    if(config_args[s+1] == r)
                        config_db[r] = 1;
                end
            end
        end
    endfunction : set_config


    //--------------------------------------------
    // Get configuration value
    function int get_value(string key);
        return config_db[key];
    endfunction : get_value


    //--------------------------------------------
    // Get configuration value - reals
    function real get_real_value(string key);
        return config_db_real[key];
    endfunction : get_real_value


    //--------------------------------------------
    // Print configuration values
    function void report_phase(uvm_phase phase);
        file = $fopen("gpu_config.log","w");
        foreach( config_db[i] )
            $fwrite(file,"gpu_config:   %s  ---->   %0d\n",i,config_db[i]);
        foreach( config_db_real[i] )
            $fwrite(file,"gpu_config:   %s  ---->   %0d\n",i,config_db_real[i]);
        $fclose(file);
    endfunction : report_phase

endclass : gpu_config
