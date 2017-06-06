class adder_sequence extends uvm_sequence #(adder_tlm);

    adder_tlm tlm;

    `uvm_object_utils_begin(adder_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "adder_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        repeat (50) begin
            tlm = adder_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
            start_item(tlm);
            assert(tlm.randomize());
            finish_item(tlm);
            #10;
        end
    endtask : body

endclass : adder_sequence
