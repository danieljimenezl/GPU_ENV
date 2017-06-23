typedef enum {
    INIT,
    CAM,
    CRE,
    VEC,
    CLO,
    MOD,
    REF

} state_enum;

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
        state_enum state;

        fork
            uart_tlm tlm = new();
            uart_fifo.get(tlm);

            if (tlm.tlm_type == UART_GPU_INPUT) begin
                if (tlm.tlm_cmd == INITIALIZE) begin
                    state = INIT;

                    forever begin
                        case (state)
                            INIT    :   initialize();
                            //CAM     :   camera();
                            //CRE     :   create();
                            //VEC     :   vector();
                            //CLO     :   close();
                            //MOD     :   modify();
                            //REF     :   refresh();

                        endcase
                    end
                end
            end
        join
    endtask : run_phase


    //--------------------------------------------
    // INIT
    task initialize();
        int complement;
        uart_fifo.get(tlm);
        complement = (~INIT) & 'h0000FFFF;
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == COMPL) begin
            if (tlm.data != complement)
                `uvm_error("UART_MODULE",$psprintf("INIT RESPONSE NOT RECEIVED"));
            else
                `uvm_info("UART_MODULE",$psprintf("INIT STARTED"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == ENABLE)
            `uvm_info("UART_MODULE",$psprintf("GPU ENABLE"),UVM_LOW);
        else begin
            `uvm_info("UART_MODULE",$psprintf("GPU DISABLE"),UVM_LOW);
            uart_fifo.get(tlm);

            if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == INITIALIZE)
                initialize();
            else
                `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));
        end

        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END)
            `uvm_info("UART_MODULE",$psprintf("DRIVER INIT TRANSMITION COMPLETE"),UVM_LOW);
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == INITIALIZE)
            `uvm_info("UART_MODULE",$psprintf("ACK INIT TRANSMITION COMPLETE"),UVM_LOW);
        else
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == CAM_CONFIG)
            state = CAM;
        else
            `uvm_error("UART_MODULE",$psprintf("EXPECTING CAM CONFIG COMMAND"));
    endtask :initialize

endclass : memctrl_scoreboard
