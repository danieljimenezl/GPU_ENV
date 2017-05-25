class mult_sequencer extends uvm_sequencer #(mult_tlm);

    `uvm_sequencer_utils(mult_sequencer)

    //--------------------------------------------
    // new
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : mult_sequencer
