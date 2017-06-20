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
        tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==INITIALIZE;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0000;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==ENABLE;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0000;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==END;} );
        finish_item(tlm);
        #100ns;

    endtask : body

endclass : uart_sequence
