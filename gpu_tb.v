module gpu_tb();

    import gpu_pkg::*;

    wire [15:0] in0_sum, in1_sum, out_sum;
    wire [15:0] in0_mult, in1_mult, out_mult;
    wire [15:0] in0_divider, in1_divider, out_divider;
    wire excep_divider;

    `ifdef GPU_PIPELINE_ADDER
        adderhalfprecision adder(
            .o_Sum(out_sum),
            .i_Addend1(in0_sum),
            .i_Addend2(in1_sum)
        );
    `endif

    `ifdef GPU_PIPELINE_DIVIDER
        divhalfprecision divider(
            .o_Quotient(out_divider),
            .o_Exception(Excep_divider),
            .i_Dividend(in0_divider),
            .i_Divisor(in1_divider)
        );
    `endif

    `ifdef GPU_PIPELINE_MULT
         multhalfprecision multiplier(
            .o_Product(in0_mult),
            .i_Factor1(in1_mult),
            .i_Factor2(out_mult)
        );
    `endif

endmodule
