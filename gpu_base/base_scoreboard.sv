virtual class base_scoreboard extends uvm_component;

    `uvm_component_utils_begin(base_scoreboard)
    `uvm_component_utils_end

    //--------------------------------------------
    // new
    function new (string name, uvm_component parent);
        super.new(name, parent);
        $display({name," created"});
    endfunction : new

endclass : base_scoreboard
