module wdext #(
    parameter XLEN = 32
) (

    input logic MemWriteM,
    input logic [ $clog2(XLEN/8)-1:0 ] byteAddrM,
    input logic [2:0] funct3M,
    output logic [ XLEN/8-1:0 ] byteEnable

);

    integer i;

    always_comb begin

        byteEnable = { (XLEN/8){1'b0} };

        if (MemWriteM) begin

            unique case (funct3M)

                3'b000: begin // sb

                    // case (byteAddrM)

                    //     2'b00: byteEnable = 4'b0001;
                    //     2'b01: byteEnable = 4'b0010;
                    //     2'b10: byteEnable = 4'b0100;
                    //     2'b11: byteEnable = 4'b1000;

                    // endcase

                    byteEnable = 1 << byteAddrM;

                end

                3'b001: begin // sh

                    // byteEnable = (byteAddrM[1] == 1'b0) ? 4'b0011 : 4'b1100;
                    for (i = 0; i < XLEN/8; i = i + 1) begin

                        if (i[0] == byteAddrM[0]) begin
                            byteEnable[i] = 1;
                        end

                    end

                end

                3'b010: begin // SW/SD

                    // byteEnable = 4'b1111;
                    byteEnable = { (XLEN/8){1'b1} }; // bytes

                end

                default: begin

                    // byteEnable = 4'b0000;
                    byteEnable = { (XLEN/8){1'b0} };
                    
                end

            endcase

        end

    end
    
endmodule