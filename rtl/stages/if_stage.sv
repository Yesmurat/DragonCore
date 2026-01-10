module if_stage (
    
        input logic  [31:0] PC,
        
        ifid_if.wr outputs
        
    );

    assign outputs.data.PC = PC;
    assign outputs.data.PCPlus4 = PC + 32'd4;

    imem instr_mem(

        .address    (PC),
        .rd         (outputs.data.instr)

    );

endmodule // IF stage