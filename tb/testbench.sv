`timescale 1ns/1ps

module testbench;

    localparam CLK_PERIOD = 10;
    localparam XLEN = 64;

    logic clk;
    logic reset;
    logic [4:0] Rs1D, Rs2D;

    riscv dut (

        .clk            (clk),
        .reset          (reset),
        
        .Rs1D           (Rs1D),
        .Rs2D           (Rs2D)

    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        reset = 1;
        #7;
        reset = 0;
        #1000;
        $stop;
    end

endmodule