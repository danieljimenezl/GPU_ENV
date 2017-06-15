class pipeline_driver extends base_driver#(
    .IFC(virtual pipeline_ifc),
    .TLM(pipeline_tlm)
);

    `uvm_component_utils_begin(pipeline_driver)
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
        forever begin
            pipeline_tlm tlm = new();
            seq_item_port.get_next_item(tlm);

            @(posedge ifc.base.clk)
                //camVer Values
/*                ifc.camVerX[15] <= tlm.camVer["x"]["sign"];
                ifc.camVerX[14:10] <= tlm.camVer["x"]["exponent"];
                ifc.camVerX[9:0] <= tlm.camVer["x"]["mantissa"];

                ifc.camVerY[15] <= tlm.camVer["y"]["sign"];
                ifc.camVerY[14:10] <= tlm.camVer["y"]["exponent"];
                ifc.camVerY[9:0] <= tlm.camVer["y"]["mantissa"];

                ifc.camVerZ[15] <= tlm.camVer["z"]["sign"];
                ifc.camVerZ[14:10] <= tlm.camVer["z"]["exponent"];
                ifc.camVerZ[9:0] <= tlm.camVer["z"]["mantissa"];

                //camDc
                ifc.camDc[15] <= tlm.cam["Dc"]["sign"];
                ifc.camDc[14:10] <= tlm.cam["Dc"]["exponent"];
                ifc.camDc[9:0] <= tlm.cam["Dc"]["mantissa"];

                //Cos Values
                ifc.cosRoll[15] <= tlm.cosValues["Roll"]["sign"];
                ifc.cosRoll[14:10] <= tlm.cosValues["Roll"]["exponent"];
                ifc.cosRoll[9:0] <= tlm.cosValues["Roll"]["mantissa"];

                ifc.cosPitch[15] <= tlm.cosValues["Pitch"]["sign"];
                ifc.cosPitch[14:10] <= tlm.cosValues["Pitch"]["exponent"];
                ifc.cosPitch[9:0] <= tlm.cosValues["Pitch"]["mantissa"];

                ifc.cosYaw[15] <= tlm.cosValues["Yaw"]["sign"];
                ifc.cosYaw[14:10] <= tlm.cosValues["Yaw"]["exponent"];
                ifc.cosYaw[9:0] <= tlm.cosValues["Yaw"]["mantissa"];

                //Sen Values
                ifc.senRoll[15] <= tlm.senValues["Roll"]["sign"];
                ifc.senRoll[14:10] <= tlm.senValues["Roll"]["exponent"];
                ifc.senRoll[9:0] <= tlm.senValues["Roll"]["mantissa"];

                ifc.senPitch[15] <= tlm.senValues["Pitch"]["sign"];
                ifc.senPitch[14:10] <= tlm.senValues["Pitch"]["exponent"];
                ifc.senPitch[9:0] <= tlm.senValues["Pitch"]["mantissa"];

                ifc.senYaw[15] <= tlm.senValues["Yaw"]["sign"];
                ifc.senYaw[14:10] <= tlm.senValues["Yaw"]["exponent"];
                ifc.senYaw[9:0] <= tlm.senValues["Yaw"]["mantissa"];

                //scale Values
                ifc.scaleX[15] <= tlm.scale["x"]["sign"];
                ifc.scaleX[14:10] <= tlm.scale["x"]["exponent"];
                ifc.scaleX[9:0] <= tlm.scale["x"]["mantissa"];

                ifc.scaleY[15] <= tlm.scale["y"]["sign"];
                ifc.scaleY[14:10] <= tlm.scale["y"]["exponent"];
                ifc.scaleY[9:0] <= tlm.scale["y"]["mantissa"];

                ifc.scaleZ[15] <= tlm.scale["z"]["sign"];
                ifc.scaleZ[14:10] <= tlm.scale["z"]["exponent"];
                ifc.scaleZ[9:0] <= tlm.scale["z"]["mantissa"];

                //trans Values
                ifc.transX[15] <= tlm.trans["x"]["sign"];
                ifc.transX[14:10] <= tlm.trans["x"]["exponent"];
                ifc.transX[9:0] <= tlm.trans["x"]["mantissa"];

                ifc.transY[15] <= tlm.trans["y"]["sign"];
                ifc.transY[14:10] <= tlm.trans["y"]["exponent"];
                ifc.transY[9:0] <= tlm.trans["y"]["mantissa"];

                ifc.transZ[15] <= tlm.trans["z"]["sign"];
                ifc.transZ[14:10] <= tlm.trans["z"]["exponent"];
                ifc.transZ[9:0] <= tlm.trans["z"]["mantissa"];

                //vertex Values
                ifc.vertexX[15] <= tlm.vertex["x"]["sign"];
                ifc.vertexX[14:10] <= tlm.vertex["x"]["exponent"];
                ifc.vertexX[9:0] <= tlm.vertex["x"]["mantissa"];

                ifc.vertexY[15] <= tlm.vertex["y"]["sign"];
                ifc.vertexY[14:10] <= tlm.vertex["y"]["exponent"];
                ifc.vertexY[9:0] <= tlm.vertex["y"]["mantissa"];

                ifc.vertexZ[15] <= tlm.vertex["z"]["sign"];
                ifc.vertexZ[14:10] <= tlm.vertex["z"]["exponent"];
                ifc.vertexZ[9:0] <= tlm.vertex["z"]["mantissa"];
*/
                ifc.camVerX[15] <= 1'b0;
                ifc.camVerX[14:10] <= 5'b10010;
                ifc.camVerX[9:0] <= 10'b1010000000;

                ifc.camVerY[15] <= 1'b0;
                ifc.camVerY[14:10] <= 5'b10001;
                ifc.camVerY[9:0] <= 10'b0000000000;

                ifc.camVerZ[15] <= 1'b1;
                ifc.camVerZ[14:10] <= 5'b10010;
                ifc.camVerZ[9:0] <= 10'b0000000000;

                //camDc
                ifc.camDc[15] <= 1'b0;
                ifc.camDc[14:10] <= 5'b10001;
                ifc.camDc[9:0] <= 10'b1100000000;

                //Cos Values
                ifc.cosRoll[15] <= 1'b0;
                ifc.cosRoll[14:10] <= 5'b011111;
                ifc.cosRoll[9:0] <= 10'b0000000000;

                ifc.cosPitch[15] <= 1'b0;
                ifc.cosPitch[14:10] <= 5'b01110;
                ifc.cosPitch[9:0] <= 10'b0000000000;

                ifc.cosYaw[15] <= 1'b0;
                ifc.cosYaw[14:10] <= 5'b01110;
                ifc.cosYaw[9:0] <= 10'b0000000000;

                //Sen Values
                ifc.senRoll[15] <= 1'b0;
                ifc.senRoll[14:10] <= 5'b00000;
                ifc.senRoll[9:0] <= 10'b0000000000;

                ifc.senPitch[15] <= 1'b0;
                ifc.senPitch[14:10] <= 5'b01110;
                ifc.senPitch[9:0] <= 10'b1011101101;

                ifc.senYaw[15] <= 1'b0;
                ifc.senYaw[14:10] <= 5'b01110;
                ifc.senYaw[9:0] <= 10'b1011101101;

                //scale Values
                ifc.scaleX[15] <= 1'b1;
                ifc.scaleX[14:10] <= 5'b10000;
                ifc.scaleX[9:0] <= 10'b1110000000;

                ifc.scaleY[15] <= 1'b0;
                ifc.scaleY[14:10] <= 5'b10010;
                ifc.scaleY[9:0] <= 10'b1100000000;

                ifc.scaleZ[15] <= 1'b1;
                ifc.scaleZ[14:10] <= 5'b10000;
                ifc.scaleZ[9:0] <= 10'b1100000000;

                //trans Values
                ifc.transX[15] <= 1'b1;
                ifc.transX[14:10] <= 5'b1001;
                ifc.transX[9:0] <= 10'b1110011001;

                ifc.transY[15] <= 1'b1;
                ifc.transY[14:10] <= 5'b10000;
                ifc.transY[9:0] <= 10'b1100000000;

                ifc.transZ[15] <= 1'b0;
                ifc.transZ[14:10] <= 5'b10011;
                ifc.transZ[9:0] <= 10'b1001000000;

                //vertex Values
                ifc.vertexX[15] <= 1'b1;
                ifc.vertexX[14:10] <= 5'b10011;
                ifc.vertexX[9:0] <= 10'b0101000000;

                ifc.vertexY[15] <= 1'b0;
                ifc.vertexY[14:10] <= 5'b10001;
                ifc.vertexY[9:0] <= 10'b1110000000;

                ifc.vertexZ[15] <= 1'b1;
                ifc.vertexZ[14:10] <= 5'b10001;
                ifc.vertexZ[9:0] <= 10'b0100000000;

            seq_item_port.item_done();
        end
    endtask : input_values

endclass : pipeline_driver
