class divider_driver extends base_driver#(
    .IFC(virtual divider_ifc),
    .TLM(divider_tlm)
);

    `uvm_component_utils_begin(divider_driver)
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
        join
    endtask : run_phase


     //--------------------------------------------
    // input values
    task input_values();
        ifc.in0_divider <= 16'd0;
        ifc.in1_divider <= 16'd0;

        forever begin
            divider_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            @(posedge ifc.base.clk)
                ifc.in0_divider[15] <= tlm.in0_sign;
                ifc.in0_divider[14:10] <= tlm.in0_exponent;
                ifc.in0_divider[9:0] <= tlm.in0_mantissa;

                ifc.in1_divider[15] <= tlm.in1_sign;
                ifc.in1_divider[14:10] <= tlm.in1_exponent;
                ifc.in1_divider[9:0] <= tlm.in1_mantissa;

            seq_item_port.item_done();
        end
    endtask : input_values

endclass : divider_driver
