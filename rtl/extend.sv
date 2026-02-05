`timescale 1ns/1ps

module extend
    #( parameter XLEN = 32 ) (

    input  logic [31:0] instr,

    output logic [XLEN-1:0] immext
    
);

    localparam [6:0]
        load    = 7'b0000011, // 3
        i_type  = 7'b0010011, // 19
        s_type  = 7'b0100011, // 35
        b_type  = 7'b1100011, // 99
        lui     = 7'b0110111, // 55
        auipc   = 7'b0010111, // 23
        jal     = 7'b1101111, // 111
        jalr    = 7'b1100111; // 103

    logic [6:0] opcode;
    logic [2:0] funct3;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];

    logic [11:0] itype_imm;
    logic [11:0] stype_imm;

    assign itype_imm = instr[31:20];
    assign stype_imm = { instr[31:25], instr[11:7] };
    // logic [12:0] btype_imm = ...;


    always_comb begin

        unique case (opcode)

            // I-type (load, i_type, jalr)

            load, jalr : immext = { { (XLEN-12) { instr[31] } }, itype_imm };

            i_type : begin

                if (funct3 == 3'b001 | funct3 == 3'b101) begin // slli, sr(l/a)i

                    immext = { '0, itype_imm[4:0] };

                end

                else begin

                    immext = { { (XLEN-12) { instr[31] } }, itype_imm };

                end

            end

            // S-type (sb, sh, sw)
            s_type: immext = { {(XLEN-12){instr[31]}}, stype_imm };

            // B-type (branches)
            b_type: immext = { {(XLEN-13){instr[31]}}, instr[7], instr[30:25],
                               instr[11:8], 1'b0 };

            // U-type
            lui, auipc: immext = { {(XLEN-32){instr[31]}}, instr[31:12], 12'b0 };

            // J-type (jal)
            jal: immext = { {(XLEN-21){instr[31]}}, instr[19:12], instr[20],
                               instr[30:21], 1'b0 };

            default: immext = '0;

        endcase

    end

endmodule