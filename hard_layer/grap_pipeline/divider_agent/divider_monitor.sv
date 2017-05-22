class divider_monitor extends base_monitor#(
    .IFC(virtual divider_ifc),
    .TLM(divider_tlm)
);

    `uvm_component_utils_begin(divider_monitor)
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

endclass : divider_monitor
