class adder_driver extends base_driver#(
    .IFC(virtual adder_ifc),
    .TLM(adder_tlm)
);

    `uvm_component_utils_begin(adder_driver)
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
        ifc.in0_adder <= 16'd0;
        ifc.in1_adder <= 16'd0;

        forever begin
            adder_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            ifc.in0_adder <= tlm.in_0;
            ifc.in1_adder <= tlm.in_1;

            seq_item_port.item_done();
        end
    endtask : input_values

endclass : adder_driver
