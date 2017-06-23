class uart_monitor extends base_monitor#(
    .IFC(virtual uart_ifc),
    .TLM(uart_tlm)
);

    `uvm_component_utils_begin(uart_monitor)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    //--------------------------------------------
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase


    //--------------------------------------------
    // run_phase
    task run_phase(uvm_phase phase);
        fork
            input_values();
            output_value();
        join
    endtask : run_phase


    //--------------------------------------------
    // input values
    task input_values();
        int data;

        forever begin
            @(ifc.base.clk);
                if (ifc.rx_ready == 'b1) begin
                    tlm = new();
                    tlm.tlm_type = UART_GPU_INPUT;
                    data = ifc.rx_byte;
                    data = data << 8;
                    @(ifc.rx_ready);
                    @(ifc.rx_ready);
                    data = data | ifc.rx_byte;

                    if(find(data) == 1) begin
                        tlm.tlm_cmd = data;
                    end
                    else begin
                        tlm.tlm_cmd = DATA;
                        tlm.data = data;
                    end

                    @(ifc.rx_ready);
                    ch_out.write(tlm);
                end
        end
    endtask : input_values


    //--------------------------------------------
    // output value
    task output_value();
        int data;

        forever begin
            @(ifc.base.clk);
                if (ifc.tx_ready == 'b1) begin
                    tlm = new();
                    tlm.tlm_type = UART_GPU_OUTPUT;
                    data = ifc.tx_byte;
                    data = data << 8;
                    @(ifc.tx_ready);
                    @(ifc.tx_ready);
                    data = data | ifc.tx_byte;

                    if(find(data) == 1) begin
                        tlm.tlm_cmd = data;
                        gpu_log(file,"uart_driver",$psprintf("Executing: %s --------- Done\n", tlm.tlm_cmd.name));
                    end
                    else if (find(data) == 2) begin
                        tlm.tlm_cmd = COMPL;
                        tlm.data = data;
                        gpu_log(file,"uart_monitor",$psprintf(" --------------- Request accepted"));
                    end
                    else begin
                        tlm.tlm_cmd = DATA;
                        tlm.data = data;
                    end

                    @(ifc.tx_ready);

                    ch_out.write(tlm);
                end

        end
    endtask : output_value


    //--------------------------------------------
    // find function
     function int find(int data);
        uart_tlm_cmd cmd = cmd.first();
        int found = 0;
        int data_compl = (~data)&'h0000FFFF;

            while (cmd!=cmd.last && found==0) begin
                if(data == cmd)
                    found = 1;
                else if (data_compl == cmd) begin
                    found = 2;
                end
                else begin
                    cmd = cmd.next;
                    if(cmd == cmd.last)
                        if(data == cmd)
                            found = 1;
                        if(data_compl == cmd)
                            found = 2;
                end
            end
        return found;
    endfunction : find

endclass 
