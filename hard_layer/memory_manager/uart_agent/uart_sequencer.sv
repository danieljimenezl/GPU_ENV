class uart_sequencer extends uvm_sequencer #(uart_tlm);

    `uvm_sequencer_utils(uart_sequencer)

    //--------------------------------------------
    // new
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : uart_sequencer
