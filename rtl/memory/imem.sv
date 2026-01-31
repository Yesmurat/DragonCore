(* dont_touch = "true" *)
`timescale 1ns/1ps

// Instruction memory
module imem #(

        parameter XLEN       = 32,
        parameter MEMORY_CAPACITY = 1024 // 256 instructions

    )
    
    (
        // input logic                   clk,
        input logic  [XLEN-1:0] address,

        output logic [31:0]           rd
        
    );
    
    logic [31:0] ROM[ MEMORY_CAPACITY - 1 : 0 ];
    
    initial $readmemh("./imem.mem", ROM);

    // always_ff @(posedge clk) begin

    //     rd <= ROM[address];

    // end

    assign rd = ROM[address];

endmodule // Instruction memory