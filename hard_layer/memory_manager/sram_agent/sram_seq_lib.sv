class sram_sequence extends uvm_sequence #(sram_tlm);

    sram_tlm tlm;

    `uvm_object_utils_begin(sram_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "sram_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        repeat (50) begin
            tlm = sram_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
            start_item(tlm);
            assert(tlm.randomize());
            finish_item(tlm);
        end
    endtask : body

endclass : sram_sequence
