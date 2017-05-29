class uart_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;

    `uvm_object_utils_begin(uart_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        repeat (50) begin
            tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
            start_item(tlm);
            assert(tlm.randomize());
            finish_item(tlm);
        end
    endtask : body

endclass : uart_sequence
