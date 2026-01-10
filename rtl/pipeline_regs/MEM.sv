module MEM (

    input logic clk,

    exmem_if.rd inputs,
    exmem_if.wr outputs
    
);

    always_ff @( posedge clk ) begin : MEM_register
        outputs <= inputs;
    end
    
endmodule