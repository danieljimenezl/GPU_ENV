class pipeline_monitor extends base_monitor#(
    .IFC(virtual pipeline_ifc),
    .TLM(pipeline_tlm)
);

    `uvm_component_utils_begin(pipeline_monitor)
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
            output_values();
        join
    endtask : run_phase


    //--------------------------------------------
    // input values
    task input_values();
        forever begin
            @(posedge ifc.base.clk);
                tlm = new();
                tlm.tlm_type = PIPELINE_INPUTS;

                tlm.camVer["x"]["sign"] = ifc.camVerX[15];
                tlm.camVer["x"]["exponent"] = ifc.camVerX[14:10];
                tlm.camVer["x"]["mantissa"] = ifc.camVerX[9:0];

                tlm.camVer["y"]["sign"] = ifc.camVerY[15];
                tlm.camVer["y"]["exponent"] = ifc.camVerY[14:10];
                tlm.camVer["y"]["mantissa"] = ifc.camVerY[9:0];

                tlm.camVer["z"]["sign"] = ifc.camVerZ[15];
                tlm.camVer["z"]["exponent"] = ifc.camVerZ[14:10];
                tlm.camVer["z"]["mantissa"] = ifc.camVerZ[9:0];

                //camDc
                tlm.cam["Dc"]["sign"] = ifc.camDc[15];
                tlm.cam["Dc"]["exponent"] = ifc.camDc[14:10];
                tlm.cam["Dc"]["mantissa"] = ifc.camDc[9:0];

                //Cos Values
                tlm.cosValues["roll"]["sign"] = ifc.cosRoll[15];
                tlm.cosValues["roll"]["exponent"] = ifc.cosRoll[14:10];
                tlm.cosValues["roll"]["mantissa"] = ifc.cosRoll[9:0];

                tlm.cosValues["pitch"]["sign"] = ifc.cosPitch[15];
                tlm.cosValues["pitch"]["exponent"] = ifc.cosPitch[14:10];
                tlm.cosValues["pitch"]["mantissa"] = ifc.cosPitch[9:0];

                tlm.cosValues["yaw"]["sign"] = ifc.cosYaw[15];
                tlm.cosValues["yaw"]["exponent"] = ifc.cosYaw[14:10];
                tlm.cosValues["yaw"]["mantissa"] = ifc.cosYaw[9:0];

                //Sen Values
                tlm.senValues["roll"]["sign"] = ifc.senRoll[15];
                tlm.senValues["roll"]["exponent"] = ifc.senRoll[14:10];
                tlm.senValues["roll"]["mantissa"] = ifc.senRoll[9:0];

                tlm.senValues["pitch"]["sign"] = ifc.senPitch[15];
                tlm.senValues["pitch"]["exponent"] = ifc.senPitch[14:10];
                tlm.senValues["pitch"]["mantissa"] = ifc.senPitch[9:0];

                tlm.senValues["yaw"]["sign"] = ifc.senYaw[15];
                tlm.senValues["yaw"]["exponent"] = ifc.senYaw[14:10];
                tlm.senValues["yaw"]["mantissa"] = ifc.senYaw[9:0];

                //scale Values
                tlm.scale["x"]["sign"] = ifc.scaleX[15];
                tlm.scale["x"]["exponent"] = ifc.scaleX[14:10];
                tlm.scale["x"]["mantissa"] = ifc.scaleX[9:0];

                tlm.scale["y"]["sign"] = ifc.scaleY[15];
                tlm.scale["y"]["exponent"] = ifc.scaleY[14:10];
                tlm.scale["y"]["mantissa"] = ifc.scaleY[9:0];

                tlm.scale["z"]["sign"] = ifc.scaleZ[15];
                tlm.scale["z"]["exponent"] = ifc.scaleZ[14:10];
                tlm.scale["z"]["mantissa"] = ifc.scaleZ[9:0];

                //trans Values
                tlm.trans["x"]["sign"] = ifc.transX[15];
                tlm.trans["x"]["exponent"] = ifc.transX[14:10];
                tlm.trans["x"]["mantissa"] = ifc.transX[9:0];

                tlm.trans["y"]["sign"] = ifc.transY[15];
                tlm.trans["y"]["exponent"] = ifc.transY[14:10];
                tlm.trans["y"]["mantissa"] = ifc.transY[9:0];

                tlm.trans["z"]["sign"] = ifc.transZ[15];
                tlm.trans["z"]["exponent"] = ifc.transZ[14:10];
                tlm.trans["z"]["mantissa"] = ifc.transZ[9:0];

                //vertex Values
                tlm.vertex["x"]["sign"] = ifc.vertexX[15];
                tlm.vertex["x"]["exponent"] = ifc.vertexX[14:10];
                tlm.vertex["x"]["mantissa"] = ifc.vertexX[9:0];

                tlm.vertex["y"]["sign"] = ifc.vertexY[15];
                tlm.vertex["y"]["exponent"] = ifc.vertexY[14:10];
                tlm.vertex["y"]["mantissa"] = ifc.vertexY[9:0];

                tlm.vertex["z"]["sign"] = ifc.vertexZ[15];
                tlm.vertex["z"]["exponent"] = ifc.vertexZ[14:10];
                tlm.vertex["z"]["mantissa"] = ifc.vertexZ[9:0];
           
                ch_out.write(tlm);
        end
    endtask : input_values


    //--------------------------------------------
    // output value
    task output_values();
        forever begin
            @(posedge ifc.base.clk);
                tlm = new();
                tlm.tlm_type = PIPELINE_RESULT;

                tlm.outX_sign = ifc.outX[15];
                tlm.outX_exponent = ifc.outX[14:10];
                tlm.outX_mantissa = ifc.outX[9:0];

                tlm.outY_sign = ifc.outY[15];
                tlm.outY_exponent = ifc.outY[14:10];
                tlm.outY_mantissa = ifc.outY[9:0];

                tlm.outException = ifc.outException;

                ch_out.write(tlm);
        end
    endtask : output_values

endclass : pipeline_monitor
