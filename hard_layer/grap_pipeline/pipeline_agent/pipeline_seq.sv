class pipeline_tlm extends base_tlm;

    `uvm_object_utils_begin(pipeline_tlm)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "pipeline_tlm");
        super.new(name);
    endfunction : new

endclass : pipeline_tlm
