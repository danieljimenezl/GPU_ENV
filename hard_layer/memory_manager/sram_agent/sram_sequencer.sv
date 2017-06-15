class sram_sequencer extends uvm_sequencer #(sram_tlm);

    `uvm_sequencer_utils(sram_sequencer)

    //--------------------------------------------
    // new
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : sram_sequencer
