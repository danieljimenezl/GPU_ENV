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
    state_enum state;
    uart_tlm tlm;
    sram_tlm tlm_s;

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
            main();
            get_sram();
        join
    endtask : run_phase


    //--------------------------------------------
    // main
    task main();
        tlm = new();
        uart_fifo.get(tlm);

        if (tlm.tlm_type == UART_GPU_INPUT) begin
            if (tlm.tlm_cmd == INITIALIZE) begin
                state = INIT;

                forever begin
                    case (state)
                        INIT: begin
                            `uvm_info("UART_MODULE",$psprintf("INIT COMAND REQUEST"),UVM_LOW);
                            initialize();
                        end
                        CAM: begin 
                            `uvm_info("UART_MODULE",$psprintf("CAM_CONFIG COMAND REQUEST"),UVM_LOW);
                            camera();
                        end
                        CRE: begin
                            `uvm_info("UART_MODULE",$psprintf("CREATE_OBJ COMAND REQUEST"),UVM_LOW);
                            obj_create();
                        end
                        VEC: begin
                            `uvm_info("UART_MODULE",$psprintf("ADD_VERTEX COMAND REQUEST"),UVM_LOW);
                            vertex();
                        end
                        CLO: begin
                            `uvm_info("UART_MODULE",$psprintf("CLOSE_OBJ COMAND REQUEST"),UVM_LOW);
                            close();
                        end
                        MOD: begin
                            `uvm_info("UART_MODULE",$psprintf("MODIFY_OBJ COMAND REQUEST"),UVM_LOW);
                            modify();
                        end
                        /*REF: begin
                            `uvm_info("UART_MODULE",$psprintf("REFRESH COMAND REQUEST"),UVM_LOW);
                            refresh();
                        end*/
                    endcase
                end
            end
        end
    endtask : main


    //--------------------------------------------
    // INIT
    task initialize();
        int complement;

        tlm = new();
        uart_fifo.get(tlm);
        complement = (~INITIALIZE) & 'h0000FFFF;

        if ((tlm.tlm_type == UART_GPU_OUTPUT) && (tlm.tlm_cmd == COMPL)) begin
            if (tlm.data != complement) begin
                `uvm_error("UART_MODULE",$psprintf("INIT RESPONSE NOT RECEIVED"));
            end
            else begin
                `uvm_info("UART_MODULE",$psprintf("INIT STARTED"),UVM_LOW);
            end
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == ENABLE) begin
            `uvm_info("UART_MODULE",$psprintf("GPU ENABLE"),UVM_LOW);
        end
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
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END) begin
            `uvm_info("UART_MODULE",$psprintf("DRIVER INIT TRANSMITION COMPLETE"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == INITIALIZE) begin
            `uvm_info("UART_MODULE",$psprintf("ACK INIT TRANSMITION COMPLETE"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == CAM_CONFIG)
            state = CAM;
        else
            `uvm_error("UART_MODULE",$psprintf("EXPECTING CAM_CONFIG COMMAND"));
    endtask :initialize


    //--------------------------------------------
    // CAM
    task camera();
        int complement;

        tlm = new();
        uart_fifo.get(tlm);
        complement = (~CAM_CONFIG) & 'h0000FFFF;

        if ((tlm.tlm_type == UART_GPU_OUTPUT) && (tlm.tlm_cmd == COMPL)) begin
            if (tlm.data != complement) begin
                `uvm_error("UART_MODULE",$psprintf("CAM_CONFIG RESPONSE NOT RECEIVED"));
            end
            else begin
                `uvm_info("UART_MODULE",$psprintf("CAM_CONFIG STARTED"),UVM_LOW);
            end
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END) begin
            `uvm_info("UART_MODULE",$psprintf("DRIVER CAM_CONFIG TRANSMITION COMPLETE"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == CAM_CONFIG) begin
            `uvm_info("UART_MODULE",$psprintf("ACK CAM_CONFIG TRANSMITION COMPLETE"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT) begin
            if(tlm.tlm_cmd == CREATE_OBJ)
                state = CRE;
            else if(tlm.tlm_cmd == MODIFY_OBJ)
                state = MOD;
            else if(tlm.tlm_cmd == REFRESH)
                state = REF;
            else
                `uvm_error("UART_MODULE",$psprintf("NOT A VALID COMAND"));
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT A VALID COMAND"));
    endtask : camera


    //--------------------------------------------
    // CREATE OBJECT 
    task obj_create();
        int complement;

        tlm = new();
        uart_fifo.get(tlm);
        complement = (~CREATE_OBJ) & 'h0000FFFF;

        if ((tlm.tlm_type == UART_GPU_OUTPUT) && (tlm.tlm_cmd == COMPL)) begin
            if (tlm.data != complement) begin
                `uvm_error("UART_MODULE",$psprintf("CREATE_OBJECT RESPONSE NOT RECEIVED"));
            end
            else begin
                `uvm_info("UART_MODULE",$psprintf("CREATE_OBJECT STARTED"),UVM_LOW);
            end
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);
        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == CREATE_OBJ) begin
            `uvm_info("UART_MODULE",$psprintf("OBJECT ENABLE"),UVM_LOW);
        end
        else begin
            `uvm_info("UART_MODULE",$psprintf("OBJECT DISABLE"),UVM_LOW);
            uart_fifo.get(tlm);
            //FIXME que pasa cuando el objeto esta deshabilitado.
        end

        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END) begin
            `uvm_info("UART_MODULE",$psprintf("DRIVER CREATE_OBJECT TRANSMITION COMPLETE"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == CREATE_OBJ) begin
            `uvm_info("UART_MODULE",$psprintf("ACK CREATE_OBJECT TRANSMITION COMPLETE"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == ADD_VERT)
            state = VEC;
        else
            `uvm_error("UART_MODULE",$psprintf("EXPECTING ADD_VERT  COMMAND"));
    endtask : obj_create


    //--------------------------------------------
    // ADD VERTEX
    task vertex();
        int complement, vertices;

        tlm = new();
        uart_fifo.get(tlm);
        complement = (~ADD_VERT) & 'h0000FFFF;

        if ((tlm.tlm_type == UART_GPU_OUTPUT) && (tlm.tlm_cmd == COMPL)) begin
            if (tlm.data != complement) begin
                `uvm_error("UART_MODULE",$psprintf("ADD_VERTEX RESPONSE NOT RECEIVED"));
            end
            else begin
                `uvm_info("UART_MODULE",$psprintf("ADD_VERTEX STARTED"),UVM_LOW);
            end
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == DATA) begin
            vertices = tlm.data;
            `uvm_info("UART_MODULE",$psprintf("NUM OF VERTICES: %0d", vertices),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("NUM OF VERTEX NOT RECEIVED"));
        end

        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == ADD_VERT) begin
            `uvm_info("UART_MODULE",$psprintf("RECEIVING VERTICES"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECEIVED"));
        end

        for(int i=0;i<(vertices*3);i++) begin
            uart_fifo.get(tlm);
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END) begin
            `uvm_info("UART_MODULE",$psprintf("DRIVER ADD_VERTEX TRANSMITION COMPLETE"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == ADD_VERT) begin
            `uvm_info("UART_MODULE",$psprintf("ACK ADD_VERTEX TRANSMITION COMPLETE"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == CLOSE_OBJ)
            state = CLO;
        else
            `uvm_error("UART_MODULE",$psprintf("EXPECTING CLOSE_OBJ COMMAND"));
    endtask : vertex


    //--------------------------------------------
    // CLOSE OBJECT
    task close();
        int complement;

        tlm = new();
        uart_fifo.get(tlm);
        complement = (~CLOSE_OBJ) & 'h0000FFFF;

        if ((tlm.tlm_type == UART_GPU_OUTPUT) && (tlm.tlm_cmd == COMPL)) begin
            if (tlm.data != complement) begin
                `uvm_error("UART_MODULE",$psprintf("CLOSE_OBJ RESPONSE NOT RECEIVED"));
            end
            else begin
                `uvm_info("UART_MODULE",$psprintf("CLOSE_OBJ STARTED"),UVM_LOW);
            end
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);
        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END) begin
            `uvm_info("UART_MODULE",$psprintf("DRIVER CLOSE_OBJECT TRANSMITION COMPLETE"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == CLOSE_OBJ) begin
            `uvm_info("UART_MODULE",$psprintf("ACK CLOSE_OBJ TRANSMITION COMPLETE"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT) begin
            if(tlm.tlm_cmd == CREATE_OBJ)
                state = CRE;
            else if(tlm.tlm_cmd == MODIFY_OBJ)
                state = MOD;
            else if(tlm.tlm_cmd == REFRESH)
                state = REF;
            else
                `uvm_error("UART_MODULE",$psprintf("NOT A VALID COMAND"));
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT A VALID COMAND"));
    endtask : close


    //--------------------------------------------
    // MODIFY OBJECT
    task modify();
        int complement;

        tlm = new();
        uart_fifo.get(tlm);
        complement = (~MODIFY_OBJ) & 'h0000FFFF;

        if ((tlm.tlm_type == UART_GPU_OUTPUT) && (tlm.tlm_cmd == COMPL)) begin
            if (tlm.data != complement) begin
                `uvm_error("UART_MODULE",$psprintf("MODIFY_OBJ RESPONSE NOT RECEIVED"));
            end
            else begin
                `uvm_info("UART_MODULE",$psprintf("MODIFY_OBJ STARTED"),UVM_LOW);
            end
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT RESPONSE RECEIVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == DATA) begin
            `uvm_info("UART_MODULE",$psprintf("MODIFING OBJECT: 0x:%h", tlm.data),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);
        uart_fifo.get(tlm);

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT && tlm.tlm_cmd == END) begin
            `uvm_info("UART_MODULE",$psprintf("DRIVER MODIFY_OBJ TRANSMITION COMPLETE"),UVM_LOW);
        end
        else
            `uvm_error("UART_MODULE",$psprintf("BAD COMAND RECIEVED"));

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_OUTPUT && tlm.tlm_cmd == MODIFY_OBJ) begin
            `uvm_info("UART_MODULE",$psprintf("ACK MODIFY_OBJ TRANSMITION COMPLETE"),UVM_LOW);
        end
        else begin
            `uvm_error("UART_MODULE",$psprintf("TRANSACTION UNFINISHED"));
        end

        uart_fifo.get(tlm);
        if (tlm.tlm_type == UART_GPU_INPUT) begin
            if(tlm.tlm_cmd == CREATE_OBJ)
                state = CRE;
            else if(tlm.tlm_cmd == MODIFY_OBJ)
                state = MOD;
            else if(tlm.tlm_cmd == REFRESH)
                state = REF;
            else
                `uvm_error("UART_MODULE",$psprintf("NOT A VALID COMAND"));
        end
        else
            `uvm_error("UART_MODULE",$psprintf("NOT A VALID COMAND"));
    endtask : close


    //--------------------------------------------
    // values from sram
    task get_sram();
        forever begin
            tlm_s = new();
            sram_fifo.get(tlm_s);

            if(tlm_s.tlm_type == SRAM_WRITE) begin
                `uvm_info("SRAM_MODULE",$psprintf("WRITE REQUEST ------- ADDRESS: 0x%0h. DATA: 0x%0h", tlm_s.address, tlm_s.data),UVM_LOW);
            end
            else begin
                `uvm_info("SRAM_MODULE",$psprintf("READ REQUEST ------- ADDRESS: 0x%0h.", tlm_s.address),UVM_LOW);
            end
 
        end
    endtask : get_sram
endclass : memctrl_scoreboard
