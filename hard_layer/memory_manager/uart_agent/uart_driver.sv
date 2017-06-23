class uart_driver extends base_driver#(
    .IFC(virtual uart_ifc),
    .TLM(uart_tlm)
);

    `uvm_component_utils_begin(uart_driver)
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
            drive();
            recieve();
        join
    endtask : run_phase


     //--------------------------------------------
    // nombre task
    task drive();
        int data_high;
        int data_low;
        bit flag = 0;

        forever begin
            uart_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            data_low = tlm.tlm_cmd & 32'hFF;
            data_high = (tlm.tlm_cmd>>8) & 32'hFF;

            if (tlm.tlm_cmd == DATA) begin
                data_low = tlm.data & 32'hFF;
                data_high = (tlm.data>>8) & 32'hFF;
            end

            ifc.rx_byte<=data_high;
            @(posedge ifc.base.clk);
                ifc.rx_ready<=1;
            @(posedge ifc.base.clk);
                ifc.rx_ready<=0;
            ifc.rx_byte<=data_low;
            @(posedge ifc.base.clk);
                ifc.rx_ready<=1;
            @(posedge ifc.base.clk);
                ifc.rx_ready<=0;

            if (tlm.tlm_cmd == DATA || tlm.tlm_cmd == END || tlm.tlm_cmd == ENABLE || flag == 1) begin
                if (tlm.tlm_cmd == END)
                    flag = 0;

                if (tlm.tlm_cmd == DATA)
                    gpu_log(file,"uart_driver",$psprintf("Sending data: 0x%h (%s)", tlm.data, tlm.tlm_cmd.name));
                else
                    gpu_log(file,"uart_driver",$psprintf("Sending data: 0x%0h (%s)", tlm.tlm_cmd, tlm.tlm_cmd.name));
            end

            else if (flag == 0) begin
                flag = 1;
                gpu_log(file,"uart_driver",$psprintf("Executing: %s", tlm.tlm_cmd.name));
            end

                seq_item_port.item_done();
        end
    endtask : drive

    task recieve();
        ifc.tx_sent<=0;

        forever begin
            @(posedge ifc.base.clk);
                if(ifc.tx_ready==1) begin
                    ifc.tx_sent<=1;
                    @(posedge ifc.base.clk);
                        ifc.tx_sent<=0;
                end
        end
    endtask : recieve

endclass : uart_driver
