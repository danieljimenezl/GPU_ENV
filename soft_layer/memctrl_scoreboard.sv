class memctrl_scoreboard extends base_scoreboard;

    gpu_config CONFIG;

    uvm_analysis_export#(uart_tlm)  uart_export;
    uvm_analysis_export#(sram_tlm)  sram_export;

    uvm_tlm_analysis_fifo#(uart_tlm)    uart_fifo;
    uvm_tlm_analysis_fifo#(sram_tlm)    sram_fifo;

    `uvm_component_utils_begin(memctrl_scoreboard)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new(string name, uvm_component parent);
        super.new(name, parent);
        CONFIG = gpu_config::type_id::create("gpu_config",this);
    endfunction : new


    //--------------------------------------------
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uart_fifo = new("uart_fifo",this);
        uart_export = new("uart_export",this);
        if(CONFIG.get_value("GPU_MEMORY_UART")) begin
            sram_fifo = new("sram_fifo",this);
            sram_export = new("sram_export");
        end
    endfunction : build_phase


    //--------------------------------------------
    // connect_phase
    function void connect_phase(uvm_phase phase);
        uart_export.connect(uart_fifo.analysis_export);
        if(CONFIG.get_value("GPU_MEMORY_UART"))
            sram_export.connect(sram_fifo.analysis_export);
    endfunction : connect_phase


    //--------------------------------------------
    // run_phase
    task run_phase(uvm_phase phase);
        fork
        join
    endtask : run_phase


    //--------------------------------------------
    // uart checker
    task uart_checker();
        uart_tlm tlm;
        tlm = new();

        forever begin
            uart_fifo.get(tlm);
        end
    endtask : uart_checker

endclass : memctrl_scoreboard
