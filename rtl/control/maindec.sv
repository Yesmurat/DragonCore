(* dont_touch = "true" *)

import control_pkg::control_signals;

`timescale 1ns/1ps

module maindec (
    
            input logic [6:0] opcode,
            input logic [2:0] funct3,

            output control_signals ctrl
            
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

        ctrl = '0;

        unique case (opcode)

            load: begin

                // 1'b1, 3'b000, 1'b1, 1'b0, 2'b01, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1
                ctrl.RegWriteD  = 1'b1;
                ctrl.ALUSrcD    = 1'b1;
                ctrl.ResultSrcD = 2'b01;
                ctrl.jumpRegD   = 1'b1;

                ctrl.is_word_op = (funct3 == 3'b110) ? 1 : 0; // lwu
                
            end // loads (I-type) (32/64)

            store: begin
            
                // 1'b0, 3'b001, 1'b1, 1'b1, 2'b00, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1
                ctrl.ALUSrcD   = 1'b1;
                ctrl.MemWriteD = 1'b1;
                ctrl.jumpRegD  = 1'b1;
                
            end // S-type (32/64)

            r_type: begin

                // 1'b1, 3'b000, 1'b0, 1'b0, 2'b00, 1'b0, 2'b10, 1'b0, 1'b1, 1'b1
                ctrl.RegWriteD = 1'b1;
                ctrl.ALUOp     = 2'b10;
                ctrl.jumpRegD  = 1'b1;
                
            end // R-type

            i_type: begin
                
                // 1'b1, 3'b000, 1'b1, 1'b0, 2'b00, 1'b0, 2'b10, 1'b0, 1'b1, 1'b1
                ctrl.RegWriteD = 1'b1;
                ctrl.ALUSrcD   = 1'b1;
                ctrl.ALUOp     = 2'b10;
                ctrl.jumpRegD  = 1'b1;
                
            end // I-type (immediates)

            branch: begin

                // 1'b0, 3'b010, 1'b0, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, 1'b1, 1'b1
                ctrl.BranchD  = 1'b1;
                ctrl.ALUOp    = 2'b01;
                ctrl.jumpRegD = 1'b1;
                
            end // B-type

            lui: begin

                // 1'b1, 3'b100, 1'b1, 1'b0, 2'b11, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1
                ctrl.RegWriteD  = 1'b1;
                ctrl.ALUSrcD    = 1'b1;
                ctrl.ResultSrcD = 2'b11;
                ctrl.jumpRegD   = 1'b1;
                
            end // lui (U-type)

            auipc: begin

                // 1'b1, 3'b100, 1'b1, 1'b0, 2'b00, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1
                ctrl.RegWriteD = 1'b1;
                ctrl.ALUSrcD    = 1'b1;
                ctrl.SrcAsrcD   = 1'b1;
                ctrl.jumpRegD   = 1'b1;
                
            end // auipc (U-type)

            jal: begin

                // 1'b1, 3'b011, 1'b0, 1'b0, 2'b10, 1'b0, 2'b00, 1'b1, 1'b1, 1'b1
                ctrl.RegWriteD  = 1'b1;
                ctrl.ResultSrcD = 2'b10;
                ctrl.JumpD      = 1'b1;
                ctrl.SrcAsrcD   = 1'b1;
                ctrl.jumpRegD   = 1'b1;
                
            end // jal (J-type)

            jalr: begin

                // 1'b1, 3'b000, 1'b0, 1'b0, 2'b10, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0
                ctrl.RegWriteD  = 1'b1;
                ctrl.ResultSrcD = 2'b10;
                ctrl.JumpD      = 1'b1;
                
            end // jalr (I-type)

            i_type64: begin

                ctrl.RegWriteD = 1'b1;
                ctrl.ALUSrcD   = 1'b1;
                ctrl.ALUOp     = 2'b10;
                ctrl.jumpRegD  = 1'b1;

                ctrl.is_word_op = (funct3 == 3'b000 || funct3 == 3'b001 || funct3 == 3'b101) ? 1 : 0;
                // addiw, slliw, srliw, sraiw
                
            end

            r_type64: begin

                ctrl.RegWriteD  = 1'b1;
                ctrl.ALUOp      = 2'b10;
                ctrl.jumpRegD   = 1'b1;
                ctrl.is_word_op = 1'b1;
                
            end

            default: ctrl = '0;

        endcase
        
    end
    
endmodule