class adder_agent extends base_agent#(
    adder_ifc,
    adder_driver,
    adder_monitor
);

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
    endfunction : final_phase

endclass : adder_agent
