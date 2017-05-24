class base_tlm extends uvm_sequence_item;

    `uvm_object_utils_begin(base_tlm)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "base_tlm");
        super.new(name);
    endfunction : new

endclass : base_tlm
