class gpu_config extends uvm_component;

    int config_db[string];
    uvm_cmdline_processor cmd_args;

    `uvm_component_utils_begin(gpu_config)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new (string name, uvm_component parent);
        super.new(name, parent);

        // Graphic Pipeline
        config_db["GPU_PIPELINE_ADDER"] = 0;
        config_db["GPU_PIPELINE_MULT"] = 0;
        config_db["GPU_PIPELINE_DIVIDER"] = 0;
        config_db["GPU_PIPELINE"] = 0;
        
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
        config_args[$];
        cmd_args.get_args(config_args);

        foreach ( config_args[s] ) begin
            if( config_args[s] == "-define" ) begin
                foreach ( config_db[r] ) begin
                    if(config_args[s+1] == config_db[r])
                        config_db[r] = 1;
                end
            end
        end
    endfunction : set_config


    //--------------------------------------------
    // Get configuration value
    function int get_config(string key);
        return config_db[key];
    endfunction : get_config


    //--------------------------------------------
    // Print configuration values
    function void report_phase(uvm_phase phase);
        file = $fopen("gpu_config.log","w");
        foreach( config_db[i] )
            $fwrite(file,"gpu_config:   %s  ---->   %0d",i,config_db[i]);
        $fclose(file);
    endfunction : report_phase

endclass : gpu_config
