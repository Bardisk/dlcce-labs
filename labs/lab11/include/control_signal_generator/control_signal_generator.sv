`ifndef module_control_signal_generator
`define module_control_signal_generator

`include "config/config.sv"

module control_signal_generator (
    input  wire [31:0] instr,
    output wire [2:0]  ExtOp,
    output wire        RegWr,
    output wire        ALUAsrc,
    output wire [1:0]  ALUBsrc,
    output wire [3:0]  ALUctr,
    output wire [2:0]  Branch,
    output wire        MemtoReg,
    output wire        MemWr,
    output wire [2:0]  MemOp,
    output wire [`REG_NUM_WIDE] rd,
    output wire [`REG_NUM_WIDE] rs1,
    output wire [`REG_NUM_WIDE] rs2
);
// ======== Decode ======
    wire [6:0] op    = instr[6:0];
    assign  rs1   = instr[19:15];
    assign  rs2   = instr[24:20];
    assign  rd    = instr[11:7];
    wire [2:0] func3 = instr[14:12];
    wire [6:0] func7 = instr[31:25];
// ======================    
    
    reg [18:0] control_signal;
    assign {ExtOp, RegWr, Branch, MemtoReg, MemWr, MemOp, ALUAsrc, ALUBsrc, ALUctr} = control_signal;

    always @(*) begin
        casex ({op[6:2], func3, func7[5]})
            //ARI
            9'b01101xxxx: control_signal = 19'b001_1_000_0_0_000_0_01_0011;
            9'b00101xxxx: control_signal = 19'b001_1_000_0_0_000_1_01_0000;
            9'b00100000x: control_signal = 19'b000_1_000_0_0_000_0_01_0000;
            9'b00100010x: control_signal = 19'b000_1_000_0_0_000_0_01_0010;
            9'b00100011x: control_signal = 19'b000_1_000_0_0_000_0_01_1010;
            9'b00100100x: control_signal = 19'b000_1_000_0_0_000_0_01_0100;
            9'b00100110x: control_signal = 19'b000_1_000_0_0_000_0_01_0110;
            9'b00100111x: control_signal = 19'b000_1_000_0_0_000_0_01_0111;
            9'b001000010: control_signal = 19'b000_1_000_0_0_000_0_01_0001;
            9'b001001010: control_signal = 19'b000_1_000_0_0_000_0_01_0101;
            9'b001001011: control_signal = 19'b000_1_000_0_0_000_0_01_1101;
            9'b011000000: control_signal = 19'b000_1_000_0_0_000_0_00_0000;
            9'b011000001: control_signal = 19'b000_1_000_0_0_000_0_00_1000;
            9'b011000010: control_signal = 19'b000_1_000_0_0_000_0_00_0001;
            9'b011000100: control_signal = 19'b000_1_000_0_0_000_0_00_0010;
            9'b011000110: control_signal = 19'b000_1_000_0_0_000_0_00_1010;
            9'b011001000: control_signal = 19'b000_1_000_0_0_000_0_00_0100;
            9'b011001010: control_signal = 19'b000_1_000_0_0_000_0_00_0101;
            9'b011001011: control_signal = 19'b000_1_000_0_0_000_0_00_1101;
            9'b011001100: control_signal = 19'b000_1_000_0_0_000_0_00_0110;
            9'b011001110: control_signal = 19'b000_1_000_0_0_000_0_00_0111;
            //J
            9'b11011xxxx: control_signal = 19'b100_1_001_0_0_000_1_10_0000;
            9'b11001000x: control_signal = 19'b000_1_010_0_0_000_1_10_0000;
            9'b11000000x: control_signal = 19'b011_0_100_0_0_000_0_00_0010;
            9'b11000001x: control_signal = 19'b011_0_101_0_0_000_0_00_0010;
            9'b11000100x: control_signal = 19'b011_0_110_0_0_000_0_00_0010;
            9'b11000101x: control_signal = 19'b011_0_111_0_0_000_0_00_0010;
            9'b11000110x: control_signal = 19'b011_0_110_0_0_000_0_00_1010;
            9'b11000111x: control_signal = 19'b011_0_111_0_0_000_0_00_1010;
            //L&S
            9'b00000000x: control_signal = 19'b000_1_000_1_0_000_0_01_0000;
            9'b00000001x: control_signal = 19'b000_1_000_1_0_001_0_01_0000;
            9'b00000010x: control_signal = 19'b000_1_000_1_0_010_0_01_0000;
            9'b00000100x: control_signal = 19'b000_1_000_1_0_100_0_01_0000;
            9'b00000101x: control_signal = 19'b000_1_000_1_0_101_0_01_0000;
            9'b01000000x: control_signal = 19'b010_0_000_0_1_000_0_01_0000;
            9'b01000001x: control_signal = 19'b010_0_000_0_1_001_0_01_0000;
            9'b01000010x: control_signal = 19'b010_0_000_0_1_010_0_01_0000;
            default: begin control_signal = 19'b010_0_000_0_1_010_0_01_0000; end
        endcase 
    end

endmodule

`endif
