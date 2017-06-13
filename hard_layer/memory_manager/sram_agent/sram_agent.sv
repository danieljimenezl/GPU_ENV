class sram_agent extends base_agent#(
    .IFC(virtual sram_ifc),
    .DRV(sram_driver),
    .MON(sram_monitor)
);

    `uvm_component_utils_begin(sram_agent)
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

endclass : sram_agent
