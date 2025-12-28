`timescale 1ns/1ps

module testbench;

    localparam CLK_PERIOD = 10;

    logic clk;
    logic reset;
    logic [3:0] LED;

    top DUT(

        .clk(clk),
        .reset(reset),
        .LED(LED)

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