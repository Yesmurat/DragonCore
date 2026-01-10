module ID (

    input logic clk,
    input logic en,
    input logic reset,

    ifid_if.rd inputs,
    ifid_if.wr outputs
    
);

    always_ff @( posedge clk or posedge reset ) begin : ID_register
        
        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;    
        end

    end
    
endmodule