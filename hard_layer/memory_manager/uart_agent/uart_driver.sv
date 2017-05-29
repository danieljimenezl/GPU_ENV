class uart_driver extends base_driver#(
    .IFC(virtual uart_ifc),
    .TLM(uart_tlm)
);

    `uvm_component_utils_begin(uart_driver)
    `uvm_component_utils_end


    //--------------------------------------------
    // new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    //--------------------------------------------
    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase


    //--------------------------------------------
    // run_phase
    task run_phase(uvm_phase phase);
        fork
            nombre_task();
        join
    endtask : run_phase


     //--------------------------------------------
    // nombre task
    task nombre_task();
        forever begin
            uart_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            //acciones

            seq_item_port.item_done();
        end
    endtask : nombre_task

endclass : uart_driver
