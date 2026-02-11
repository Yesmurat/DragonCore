`timescale 1ns/1ps

import pipeline_pkg::idex_t;

module idex_reg (
    
    input logic clk,
    // input logic en,
    input logic reset,

    input idex_t inputs,
    output idex_t outputs

);

    always_ff @( posedge clk or posedge reset ) begin : EX_register

        if (inputs.Rd == 14 && inputs.ImmExt == 32'h12345000) begin
            $display("Time %t: LUI entering IDEX", $time);
            $display("reset or flush = %b", reset);
            $display(" rd_in = %d, imm_in=%h", inputs.Rd, inputs.ImmExt);
        end

        if (outputs.Rd == 0 && outputs.ImmExt == 0) begin
            $display("Time %t: IDEX outputs are ZERO", $time);
            $display("  reset or flush = %b", reset);
        end

        if (reset) begin
            outputs <= '0;
        end

        else begin
            outputs <= inputs;
        end
        
    end
    
endmodule