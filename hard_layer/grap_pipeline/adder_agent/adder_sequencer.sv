class adder_sequencer extends uvm_sequencer #(adder_tlm);

    `uvm_sequencer_utils(adder_sequencer)

    //--------------------------------------------
    // new
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : adder_sequencer
