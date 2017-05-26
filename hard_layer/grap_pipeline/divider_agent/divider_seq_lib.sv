class divider_sequence extends uvm_sequence #(divider_tlm);

    divider_tlm tlm;

    `uvm_object_utils_begin(divider_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "divider_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        repeat (50) begin
            tlm = divider_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
            start_item(tlm);
            assert(tlm.randomize());
            finish_item(tlm);
        end
    endtask : body

endclass : divider_sequence
