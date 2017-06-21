//.........................................................
//..............Initialization sequence....................
//.........................................................

class uart_init_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;

    `uvm_object_utils_begin(uart_init_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_init_sequence");
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

endclass : uart_init_sequence

//.........................................................
//..............Cam configuration sequence.................
//.........................................................

class uart_cam_config_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;

    `uvm_object_utils_begin(uart_cam_config_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_cam_config_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==CAM_CONFIG;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0002;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==CAM_CONFIG;} );
        finish_item(tlm);
        #100ns;

        repeat (4) begin
            start_item(tlm);
            assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA;} );
            finish_item(tlm);
            #100ns;
        end

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==END;} );
        finish_item(tlm);
        #100ns;

    endtask : body

endclass : uart_cam_config_sequence

//.........................................................
//.................Create object sequence..................
//.........................................................

class uart_create_obj_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;

    `uvm_object_utils_begin(uart_create_obj_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_create_obj_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==CREATE_OBJ;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0007;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0000;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==CREATE_OBJ;} );
        finish_item(tlm);
        #100ns;

        repeat (12) begin
            start_item(tlm);
            assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA;} );
            finish_item(tlm);
            #100ns;
        end

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==END;} );
        finish_item(tlm);
        #100ns;

    endtask : body

endclass : uart_create_obj_sequence

//.........................................................
//.................Vertex config sequence..................
//.........................................................

class uart_vert_config_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;
    int vert_num = $urandom_range(1,5);


    `uvm_object_utils_begin(uart_vert_config_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_vert_config_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==ADD_VERT;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data==vert_num;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0016;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==ADD_VERT;} );
        finish_item(tlm);
        #100ns;

        repeat (vert_num * 3) begin
            start_item(tlm);
            assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA;} );
            finish_item(tlm);
            #100ns;
        end

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==END;} );
        finish_item(tlm);
        #100ns;

    endtask : body

endclass : uart_vert_config_sequence


//.........................................................
//.................Close object sequence..................
//.........................................................

class uart_close_obj_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;

    `uvm_object_utils_begin(uart_close_obj_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_close_obj_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==CLOSE_OBJ;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0008;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0026;} );
        finish_item(tlm);
        #100ns;

        //start_item(tlm);
        //assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==ADD_VERT;} );
        //finish_item(tlm);
        //#100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==END;} );
        finish_item(tlm);
        #100ns;

    endtask : body

endclass : uart_close_obj_sequence


//.........................................................
//.................Modify object sequence..................
//.........................................................

class uart_modify_obj_sequence extends uvm_sequence #(uart_tlm);

    uart_tlm tlm;

    `uvm_object_utils_begin(uart_modify_obj_sequence)
    `uvm_object_utils_end


    //--------------------------------------------
    // new
    function new (string name = "uart_modify_obj_sequence");
        super.new(name);
    endfunction : new


    //--------------------------------------------
    // body
    task body();
        tlm = uart_tlm::type_id::create(.name("tlm"), .contxt(get_full_name()));
        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==MODIFY_OBJ;} );
        finish_item(tlm);
        #100ns;

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA; data=='h0009;} );
        finish_item(tlm);
        #100ns;

        repeat (12) begin
            start_item(tlm);
            assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==DATA;} );
            finish_item(tlm);
            #100ns;
        end

        start_item(tlm);
        assert(tlm.randomize() with { tlm_type==UART_GPU_INPUT; tlm_cmd==END;} );
        finish_item(tlm);
        #100ns;

    endtask : body

endclass : uart_modify_obj_sequence
