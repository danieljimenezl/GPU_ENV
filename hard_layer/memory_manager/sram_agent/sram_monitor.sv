class sram_monitor extends base_monitor#(
    .IFC(virtual sram_ifc),
    .TLM(sram_tlm)
);

    `uvm_component_utils_begin(sram_monitor)
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
            controller_values();
        join
    endtask : run_phase


    //--------------------------------------------
    // controller values
    task controller_values();
        forever begin
            @(posedge ifc.validRequest);
                tlm = new();
                tlm.address = ifc.address;
                if(ifc.write) begin
                    tlm.tlm_type = SRAM_WRITE;
                    tlm.data = ifc.data;
                end
                else
                    tlm.tlm_type = SRAM_READ;

                ch_out.write(tlm);
        end
    endtask : controller_values

endclass : sram_monitor
