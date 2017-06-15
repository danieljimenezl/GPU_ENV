class sram_driver extends base_driver#(
    .IFC(virtual sram_ifc),
    .TLM(sram_tlm)
);

    `uvm_component_utils_begin(sram_driver)
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
            sram_read();
        join
    endtask : run_phase


     //--------------------------------------------
    // sram read
    task sram_read();
        ifc.completeRequest <= 0;

        forever begin
            tlm = new();

            @(posedge ifc.validRequest);
                if(ifc.write == 0) begin
                    ifc.data <= tlm.data;
                    ifc.completeRequest <= 1;
                end
        end
    endtask : sram_read

endclass : sram_driver
