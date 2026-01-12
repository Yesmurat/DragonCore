package pipeline_pkg;

    parameter XLEN = 32;
    
    // IFID
    typedef struct packed {

        logic [31:0] instr;
        logic [XLEN-1:0] PC;
        logic [XLEN-1:0] PCPlus4;

    } ifid_t;

    // IDEX
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;
        logic       MemWrite;
        logic       Jump;
        logic       Branch;
        logic [3:0] ALUControl;
        logic       ALUSrc;
        logic       SrcAsrc;
        logic [2:0] funct3;
        logic       jumpReg;

        // data
        logic [XLEN-1:0] RD1, RD2;
        logic [XLEN-1:0] PC;
        logic [XLEN-1:0] ImmExt;
        logic [XLEN-1:0] PCPlus4;
        logic [4:0]  Rs1, Rs2, Rd;

    } idex_t;

    // EXMEM
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;
        logic       MemWrite;
        logic [2:0] funct3;

        // data
        logic [XLEN-1:0] ALUResult;
        logic [XLEN-1:0] WriteData;
        logic [XLEN-1:0] PCPlus4;
        logic [XLEN-1:0] ImmExt;
        logic [4:0]  Rd;

    } exmem_t;

    // MEMWB
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;

        // data
        logic [XLEN-1:0] ALUResult;
        logic [XLEN-1:0] load_data;
        logic [XLEN-1:0] ImmExt;
        logic [XLEN-1:0] PCPlus4;
        logic [4:0]  Rd;

    } memwb_t;

endpackage

package hazard_io;

    typedef struct packed {

        logic [4:0] Rs1D;
        logic [4:0] Rs2D;
        logic [4:0] Rs1E;
        logic [4:0] Rs2E;
        logic [4:0] RdE;
        logic [4:0] RdM;
        logic [4:0] RdW;

        logic       ResultSrcE_zero;
        logic       PCSrcE;
        logic       RegWriteM;
        logic       RegWriteW;

    } hazard_in;

    typedef struct packed {
        
        logic       StallF;
        logic       StallD;
        logic       FlushD;
        logic       FlushE;
        logic [1:0] ForwardAE;
        logic [1:0] ForwardBE;

    } hazard_out;

endpackage