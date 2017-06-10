`ifdef GPU_PIPELINE_ADDER
    `include "adder_half_precision.v"
`endif

`ifdef GPU_PIPELINE_MULT
    `include "mult_half_precision.v"
`endif

`ifdef GPU_PIPELINE_DIVIDER
    `include "div_half_precision.v"
`endif

`ifdef GPU_MEMORY_UART
    `include "mem_ctrl.v"
`endif

module gpu_tb();

    import gpu_pkg::*;
    import uvm_pkg::*;

    wire [15:0] in0_adder, in1_adder, out_adder;
    wire [15:0] in0_mult, in1_mult, out_mult;
    wire [15:0] in0_divider, in1_divider, out_divider;
    wire excep_divider;
    wire [7:0] rx_byte, tx_byte;
    wire rx_ready, tx_ready, tx_sent, rx_error;
    logic clk;

    adder_ifc adder_ifc();
    mult_ifc mult_ifc();
    divider_ifc divider_ifc();
    uart_ifc uart_ifc();

    `ifdef GPU_PIPELINE_ADDER
         adderhalfprecision adder(
            .o_Sum(out_adder),
            .i_Addend1(in0_adder),
            .i_Addend2(in1_adder)
        );
    `endif

    `ifdef GPU_PIPELINE_MULT
        multhalfprecision multiplier(
            .o_Product(out_mult),
            .i_Factor1(in0_mult),
            .i_Factor2(in1_mult)
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

    `ifdef GPU_MEMORY_UART
        mem_ctrl mem_controller(
            .iClock(clk),
            .iRxByte(rx_byte),
            .oTxByte(tx_byte),
            .iRxReady(rx_ready),
            .oTxReady(tx_ready),
            .iTxSent(tx_sent),
            .iRxError(rx_error)
        );
    `endif


        assign in0_adder = adder_ifc.in0_adder;
        assign in1_adder = adder_ifc.in1_adder;
        assign adder_ifc.out_adder = out_adder;
        assign adder_ifc.base.clk = clk;

        assign in0_mult = mult_ifc.in0_mult;
        assign in1_mult = mult_ifc.in1_mult;
        assign mult_ifc.out_mult = out_mult;
        assign mult_ifc.base.clk = clk;

        assign in0_divider = divider_ifc.in0_divider;
        assign in1_divider = divider_ifc.in1_divider;
        assign divider_ifc.out_divider = out_divider;
        assign divider_ifc.base.clk = clk;

        assign rx_byte = uart_ifc.rx_byte;
        assign tx_byte = uart_ifc.tx_byte;
        assign rx_ready = uart_ifc.rx_ready;
        assign tx_ready = uart_ifc.tx_ready;
        assign tx_sent = uart_ifc.tx_sent;
        assign rx_error = uart_ifc.rx_error;
        assign uart_ifc.base.clk = clk;

        initial begin
            uvm_resource_db#(virtual adder_ifc)::set(.scope("*"), .name("adder_ifc"), .val(adder_ifc));
        end

        initial begin
            uvm_resource_db#(virtual mult_ifc)::set(.scope("*"), .name("mult_ifc"), .val(mult_ifc));
        end

        initial begin
            uvm_resource_db#(virtual divider_ifc)::set(.scope("*"), .name("divider_ifc"), .val(divider_ifc));
        end

        initial begin
            uvm_resource_db#(virtual uart_ifc)::set(.scope("*"), .name("uart_ifc"), .val(uart_ifc));
        end

    always #5 clk <= !clk;

    initial begin
        clk = 0;
        run_test("gpu_test");
    end

endmodule
