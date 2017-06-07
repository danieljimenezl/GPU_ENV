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
        join
    endtask : run_phase


     //--------------------------------------------
    // nombre task
    task drive();
        int data_high;
        int data_low;

        forever begin
            uart_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            data_low = tlm.tlm_cmd & 32'hFF;
            data_high = (tlm.tlm_cmd>>8) & 32'hFF;

            if (tlm.tlm_cmd == DATA || tlm.tlm_cmd == ADDRESS) begin
                data_low = tlm.data & 32'hFF;
                data_high = (tlm.data>>8) & 32'hFF;
            end

            ifc.rx_byte<=data_high;
            @(posedge ifc.base.clk);
                ifc.rx_ready<=1;
            @(posedge ifc.base.clk)
                ifc.rx_ready<=0;
            ifc.rx_byte<=data_low;
            @(posedge ifc.base.clk);
                ifc.rx_ready<=1;
            @(posedge ifc.base.clk)
                ifc.rx_ready<=0;

            seq_item_port.item_done();
        end
    endtask : drive

endclass : uart_driver
