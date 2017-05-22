class divider_agent extends base_agent#(
    .IFC(virtual divider_ifc),
    .DRV(divider_driver),
    .MON(divider_monitor)
);

    `uvm_component_utils_begin(divider_agent)
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
    // final_phase
    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
    endfunction : final_phase

endclass : divider_agent
