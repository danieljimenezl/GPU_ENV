`ifdef GPU_PIPELINE_ADDER
    `include "adder_half_precision.v"
`endif

`ifdef GPU_PIPELINE_MULT
    `include "mult_half_precision.v"
`endif

`ifdef GPU_PIPELINE_DIVIDER
    `include "div_half_precision.v"
`endif

`ifdef GPU_PIPELINE
    `include "adder_half_precision.v"
    `include "mult_half_precision.v"
    `include "div_half_precision.v"
    `include "graphics_pipeline.v"
`endif

module gpu_tb();

    import gpu_pkg::*;
    import uvm_pkg::*;

    //Modules in Graphic Pipeline
    wire [15:0] in0_adder, in1_adder, out_adder;
    wire [15:0] in0_mult, in1_mult, out_mult;
    wire [15:0] in0_divider, in1_divider, out_divider;
    wire excep_divider;

    //Graphic Pipeline
    wire [15:0] camVerX, camVerY, camVerZ;
    wire [15:0] camDc;
    wire [15:0] cosRoll, cosPitch, cosYaw;
    wire [15:0] senRoll, senPitch, senYaw;
    wire [15:0] scaleX, scaleY, scaleZ;
    wire [15:0] transX, transY, transZ;
    wire [15:0] vertexX, vertexY, vertexZ;
    wire [15:0] outX, outY;
    wire outException;

    logic clk;

    `ifdef GPU_PIPELINE_ADDER
        adder_ifc adder_ifc();

        assign in0_adder = adder_ifc.in0_adder;
        assign in1_adder = adder_ifc.in1_adder;
        assign adder_ifc.out_adder = out_adder;
        assign adder_ifc.base.clk = clk;

        initial begin
            uvm_resource_db#(virtual adder_ifc)::set(.scope("*"), .name("adder_ifc"), .val(adder_ifc));
        end

        adderhalfprecision adder(
            .o_Sum(out_adder),
            .i_Addend1(in0_adder),
            .i_Addend2(in1_adder)
        );
    `endif

    `ifdef GPU_PIPELINE_DIVIDER
        divider_ifc divider_ifc();

        assign in0_divider = divider_ifc.in0_divider;
        assign in1_divider = divider_ifc.in1_divider;
        assign divider_ifc.out_divider = out_divider;
        assign divider_ifc.base.clk = clk;

        initial begin
            uvm_resource_db#(virtual divider_ifc)::set(.scope("*"), .name("divider_ifc"), .val(divider_ifc));
        end

        divhalfprecision divider(
            .o_Quotient(out_divider),
            .o_Exception(Excep_divider),
            .i_Dividend(in0_divider),
            .i_Divisor(in1_divider)
        );
    `endif

    `ifdef GPU_PIPELINE_MULT
        mult_ifc mult_ifc();

        assign in0_mult = mult_ifc.in0_mult;
        assign in1_mult = mult_ifc.in1_mult;
        assign mult_ifc.out_mult = out_mult;
        assign mult_ifc.base.clk = clk;

        initial begin
            uvm_resource_db#(virtual mult_ifc)::set(.scope("*"), .name("mult_ifc"), .val(mult_ifc));
        end

        multhalfprecision multiplier(
            .o_Product(out_mult),
            .i_Factor1(in0_mult),
            .i_Factor2(in1_mult)
        );
    `endif

    `ifdef GPU_PIPELINE
        pipeline_ifc pipeline_ifc();

        assign camVerX = pipeline_ifc.camVerX;
        assign camVerY = pipeline_ifc.camVerY;
        assign camVerZ = pipeline_ifc.camVerZ;

        assign camDc = pipeline_ifc.camDc;

        assign cosRoll = pipeline_ifc.cosRoll;
        assign cosPitch = pipeline_ifc.cosPitch;
        assign cosYaw = pipeline_ifc.cosYaw;

        assign senRoll = pipeline_ifc.senRoll;
        assign senPitch = pipeline_ifc.senPitch;
        assign senYaw = pipeline_ifc.senYaw;

        assign scaleX = pipeline_ifc.scaleX;
        assign scaleY = pipeline_ifc.scaleY;
        assign scaleZ = pipeline_ifc.scaleZ;

        assign transX = pipeline_ifc.transX;
        assign transY = pipeline_ifc.transY;
        assign transZ = pipeline_ifc.transZ;

        assign vertexX = pipeline_ifc.vertexX;
        assign vertexY = pipeline_ifc.vertexY;
        assign vertexZ = pipeline_ifc.vertexZ;

        assign pipeline_ifc.outX = outX;
        assign pipeline_ifc.outY = outY;
        assign pipeline_ifc.outException = outException;
        assign pipeline_ifc.base.clk = clk;

        initial begin
            uvm_resource_db#(virtual pipeline_ifc)::set(.scope("*"), .name("pipeline_ifc"), .val(pipeline_ifc));
        end

        graphicspipeline    pipeline(
            .o_X(outX),
            .o_Y(outY),
            .o_Exception(outException),
            .i_CamVerX(camVerX), .i_CamVerY(camVerY), .i_CamVerZ(camVerZ),
            .i_CamDc(camDc),
            .i_CosRoll(cosRoll), .i_CosPitch(cosPitch), .i_CosYaw(cosYaw),
            .i_SenRoll(senRoll), .i_SenPitch(senPitch), .i_SenYaw(senYaw),
            .i_ScaleX(scaleX), .i_ScaleY(scaleY), .i_ScaleZ(scaleZ),
            .i_TranslX(transX), .i_TranslY(transY), .i_TranslZ(transZ),
            .i_VertexX(vertexX), .i_VertexY(vertexY), .i_VertexZ(vertexZ)
        );
    `endif



    always #5 clk <= !clk;

    initial begin
        clk = 0;
        run_test("gpu_test");
    end

endmodule
