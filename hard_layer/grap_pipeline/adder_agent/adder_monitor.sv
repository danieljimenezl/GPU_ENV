class adder_monitor extends base_monitor#(
    .IFC(virtual adder_ifc),
    .TLM(adder_tlm)
);

    `uvm_component_utils_begin(adder_monitor)
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
            @(ifc.in0_adder, ifc.in1_adder);
                tlm = new();
                tlm.tlm_type = ADD_INPUTS;

                tlm.in0_sign = ifc.in0_adder[0];
                tlm.in0_exponent = ifc.in0_adder[5:1];
                tlm.in0_mantissa = ifc.in0_adder[15:6];

                tlm.in1_sign = ifc.in0_adder[0];
                tlm.in1_exponent = ifc.in0_adder[5:1];
                tlm.in1_mantissa = ifc.in0_adder[15:6];

                ch_out.write(tlm);
        end
    endtask : input_values


    //--------------------------------------------
    // output value
    task output_value();
        forever begin
            @(ifc.out_adder);
                tlm = new();
                tlm.tlm_type = ADD_RESULT;

                tlm.out_sign = ifc.out_adder[0];
                tlm.out_exponent = ifc.out_adder[5:1];
                tlm.out_mantissa = ifc.out_adder[15:6];

                ch_out.write(tlm);
        end
    endtask : output_value

endclass : adder_monitor
