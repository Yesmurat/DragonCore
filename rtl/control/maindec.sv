(* dont_touch = "true" *)

`timescale 1ns/1ps

module maindec (
    
            input logic [6:0]  opcode,
            input logic [2:0]  funct3,

            output logic [1:0] ResultSrcD,
            output logic       MemWriteD,
            output logic       BranchD,
            output logic       ALUSrcD,
            output logic       RegWriteD,
            output logic       JumpD,
            output logic [1:0] ALUOp,
            output logic       SrcAsrcD,
            output logic       jumpRegD,
            output logic       is_word_op
            
    );

    localparam [6:0]
        load   = 7'b0000011, // same for rv32 & rv64
        store  = 7'b0100011, // same for rv32 & rv64
        r_type  = 7'b0110011,
        i_type  = 7'b0010011,
        branch = 7'b1100011,
        lui    = 7'b0110111,
        auipc  = 7'b0010111,
        jal    = 7'b1101111,
        jalr   = 7'b1100111,

        // rv64
        i_type64 = 7'b0011011,
        r_type64 = 7'b0111011;

    always_comb begin

        ResultSrcD = '0;
        MemWriteD = '0;
        BranchD = '0;
        ALUSrcD = '0;
        RegWriteD = '0;
        JumpD = '0;
        ALUOp = '0;
        SrcAsrcD = '0;
        jumpRegD = '0;
        is_word_op = '0;

        unique case (opcode)

            load: begin

                // 1'b1, 3'b000, 1'b1, 1'b0, 2'b01, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1
                RegWriteD  = 1'b1;
                ALUSrcD    = 1'b1;
                ResultSrcD = 2'b01;
                jumpRegD   = 1'b1;

                is_word_op = (funct3 == 3'b110) ? 1 : 0; // lwu
                
            end // loads (I-type) (32/64)

            store: begin
            
                // 1'b0, 3'b001, 1'b1, 1'b1, 2'b00, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1
                ALUSrcD   = 1'b1;
                MemWriteD = 1'b1;
                jumpRegD  = 1'b1;
                
            end // S-type (32/64)

            r_type: begin

                // 1'b1, 3'b000, 1'b0, 1'b0, 2'b00, 1'b0, 2'b10, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b1;
                ALUOp     = 2'b10;
                jumpRegD  = 1'b1;
                
            end // R-type

            i_type: begin
                
                // 1'b1, 3'b000, 1'b1, 1'b0, 2'b00, 1'b0, 2'b10, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b1;
                ALUSrcD   = 1'b1;
                ALUOp     = 2'b10;
                jumpRegD  = 1'b1;
                
            end // I-type (immediates)

            branch: begin

                // 1'b0, 3'b010, 1'b0, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, 1'b1, 1'b1
                BranchD  = 1'b1;
                ALUOp    = 2'b01;
                jumpRegD = 1'b1;
                
            end // B-type

            lui: begin

                // 1'b1, 3'b100, 1'b1, 1'b0, 2'b11, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1
                RegWriteD  = 1'b1;
                ALUSrcD    = 1'b1;
                ResultSrcD = 2'b11;
                jumpRegD   = 1'b1;
                
            end // lui (U-type)

            auipc: begin

                // 1'b1, 3'b100, 1'b1, 1'b0, 2'b00, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1
                RegWriteD = 1'b1;
                ALUSrcD    = 1'b1;
                SrcAsrcD   = 1'b1;
                jumpRegD   = 1'b1;
                
            end // auipc (U-type)

            jal: begin

                // 1'b1, 3'b011, 1'b0, 1'b0, 2'b10, 1'b0, 2'b00, 1'b1, 1'b1, 1'b1
                RegWriteD  = 1'b1;
                ResultSrcD = 2'b10;
                JumpD      = 1'b1;
                SrcAsrcD   = 1'b1;
                jumpRegD   = 1'b1;
                
            end // jal (J-type)

            jalr: begin

                // 1'b1, 3'b000, 1'b0, 1'b0, 2'b10, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0
                RegWriteD  = 1'b1;
                ResultSrcD = 2'b10;
                JumpD      = 1'b1;
                
            end // jalr (I-type)

            i_type64: begin

                RegWriteD = 1'b1;
                ALUSrcD   = 1'b1;
                ALUOp     = 2'b10;
                jumpRegD  = 1'b1;

                is_word_op = (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b101) ? 1 : 0;
                // addiw, slliw, srliw, sraiw
                
            end

            r_type64: begin

                RegWriteD  = 1'b1;
                ALUOp      = 2'b10;
                jumpRegD   = 1'b1;
                is_word_op = 1'b1;
                
            end

            default: begin
                ResultSrcD = '0;
                MemWriteD = '0;
                BranchD = '0;
                ALUSrcD = '0;
                RegWriteD = '0;
                JumpD = '0;
                ALUOp = '0;
                SrcAsrcD = '0;
                jumpRegD = '0;
                is_word_op = '0;
            end

        endcase
        
    end
    
endmodule