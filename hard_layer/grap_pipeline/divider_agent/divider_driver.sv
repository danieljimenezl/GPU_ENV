class divider_driver extends base_driver#(
    .IFC(virtual divider_ifc),
    .TLM(divider_tlm)
);

    `uvm_component_utils_begin(divider_driver)
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
        input_values();
    endtask : run_phase


     //--------------------------------------------
    // input values
    task input_values();
        ifc.in0_divider <= 16'd0;
        ifc.in1_divider <= 16'd0;

        forever begin
            divider_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            ifc.in0_divider <= tlm.in_0;
            ifc.in1_divider <= tlm.in_1;

            seq_item_port.item_done();
        end
    endtask : input_values

endclass : divider_driver
