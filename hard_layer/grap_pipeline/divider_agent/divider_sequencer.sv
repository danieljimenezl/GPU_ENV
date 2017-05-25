class divider_sequencer extends uvm_sequencer #(divider_tlm);

    `uvm_sequencer_utils(divider_sequencer)

    //--------------------------------------------
    // new
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : divider_sequencer
