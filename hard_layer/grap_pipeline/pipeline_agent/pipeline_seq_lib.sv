class pipeline_sequence extends uvm_sequence #(pipeline_tlm);

    pipeline_tlm tlm;

    `uvm_object_utils_begin(pipeline_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "pipeline_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        repeat (2) begin
            tlm = pipeline_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
            start_item(tlm);
            assert(tlm.randomize());
            finish_item(tlm);
        end
    endtask : body

endclass : pipeline_sequence
