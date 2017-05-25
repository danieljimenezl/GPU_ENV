class pipeline_sequencer extends uvm_sequencer #(pipeline_tlm);

    `uvm_sequencer_utils(pipeline_sequencer)

    //--------------------------------------------
    // new
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : pipeline_sequencer
