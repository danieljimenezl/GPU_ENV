class mult_sequence extends uvm_sequence #(mult_tlm);

    mult_tlm tlm;

    `uvm_object_utils_begin(mult_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "mult_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        repeat (50) begin
            tlm = mult_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
            start_item(tlm);
            assert(tlm.randomize());
            finish_item(tlm);
        end
    endtask : body

endclass : mult_sequence
