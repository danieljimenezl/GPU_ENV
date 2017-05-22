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

    endtask : run_phase

endclass : adder_driver
