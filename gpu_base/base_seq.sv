virtual class base_tlm;

    `uvm_component_utils_begin(base_tlm)
    `uvm_component_utils_end

    // **********************************************************
    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
     endfunction : new

endclass : base_tlm
