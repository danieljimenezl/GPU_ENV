class divider_monitor extends base_monitor#(
    .IFC(virtual divider_ifc),
    .TLM(divider_tlm)
);

    `uvm_component_utils_begin(divider_monitor)
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
            input_values();
            output_value();
        join
    endtask : run_phase


    //--------------------------------------------
    // input values
    task input_values();
        forever begin
            @(ifc.in0_divider, ifc.in1_divider);
                tlm = new();
                tlm.tlm_type = DIV_INPUTS;
                tlm.in_0 = ifc.in0_divider;
                tlm.in_1 = ifc.in1_divider;
                ch_out.write(tlm);
        end
    endtask : input_values


    //--------------------------------------------
    // output value
    task output_value();
        forever begin
            @(ifc.out_divider);
                tlm = new();
                tlm.tlm_type = DIV_RESULT;
                tlm.out = ifc.out_divider;
                ch_out.write(tlm);
        end
    endtask : output_value

endclass : divider_monitor
