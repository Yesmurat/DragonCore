module WB (
    
    input logic clk,

    memwb_if.rd inputs,
    memwb_if.wr outputs
);

    always_ff @( posedge clk ) begin : WB_register
        outputs <= inputs;
    end
    
endmodule