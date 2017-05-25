class mult_driver extends base_driver#(
    .IFC(virtual mult_ifc),
    .TLM(mult_tlm)
);

    `uvm_component_utils_begin(mult_driver)
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
        join
    endtask : run_phase


    //--------------------------------------------
    // input values
    task input_values();
        ifc.in0_mult <= 16'd0;
        ifc.in1_mult <= 16'd0;

        forever begin
            mult_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            ifc.in0_mult <= tlm.in_0;
            ifc.in1_mult <= tlm.in_1;

            seq_item_port.item_done();
        end
    endtask : input_values

endclass : mult_driver
