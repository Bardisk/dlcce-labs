`ifndef module_ojcpu
`define module_ojcpu

`include "config/config.sv"
`include "CPU/CPU.sv"

module rv32is(
    input 	clock,
	input 	reset,
	output [31:0] imemaddr,
	input  [31:0] imemdataout,
	output 	imemclk,
	output [31:0] dmemaddr,
	input  [31:0] dmemdataout,
	output [31:0] dmemdatain,
	output 	dmemrdclk,
	output	dmemwrclk,
	output [2:0] dmemop,
	output	dmemwe,
	output [31:0] dbgdata
);

    assign imemclk   = ~clock;
    assign dmemrdclk = clock;
    assign dmemwrclk = ~clock;

    wire clk = clock;
    wire rst = reset;
    wire [31:0] inst_read_data = imemdataout, data_read_data = dmemdataout;
    wire [31:0] inst_read_addr, data_read_addr, data_write_addr, data_write_data;
    reg [31:0] pc;
    wire data_write_en;
    wire [2:0] data_mode;
    
    wire [`WORD_WIDE] next_pc, jalr_reg, offset;
    wire pc_offset_sel, pc_source_sel;
    wire [`WORD_WIDE] inst = inst_read_data;
    wire RegWr, ALUAsrc, MemtoReg, MemWr;
    wire [2:0] Branch, MemOp, ExtOp;
    wire [1:0] ALUBsrc;
    wire [3:0] ALUctr;
    wire [`REG_NUM_WIDE] Ranum, Rbnum, Rwnum;
    wire [`WORD_WIDE] Ra, Rb;
    wire [`WORD_WIDE] imm;

    pc_generator PG (
        .next_pc(next_pc),
        .pc_offset_sel(pc_offset_sel),
        .pc_source_sel(pc_source_sel),
        .pc(pc),
        .jalr_reg(Ra),
        .offset(imm)
    );

    always @(negedge clk, posedge rst)
        if (rst) pc <= 0;
        else pc <= next_pc;

    assign inst_read_addr = next_pc;
    
    control_signal_generator CSG(
        .instr(inst),
        .ALUAsrc(ALUAsrc),
        .ALUBsrc(ALUBsrc),
        .ALUctr(ALUctr),
        .Branch(Branch),
        .MemtoReg(MemtoReg),
        .MemWr(MemWr),
        .MemOp(MemOp),
        .ExtOp(ExtOp),
        .RegWr(RegWr),
        .rs1(Ranum),
        .rs2(Rbnum),
        .rd(Rwnum)
    );

    imm_generator IG(
        .instr(inst),
        .ExtOp(ExtOp),
        .imm(imm)
    );

    wire [`WORD_WIDE] aluresult;

    wire [`WORD_WIDE] dataa = ALUAsrc ? next_pc : Ra;
    reg [`WORD_WIDE] datab;

    regheap myregfile(
        .WrClk(clk),
        .RegWr(RegWr),
        .Ra(Ranum),
        .Rb(Rbnum),
        .Rw(Rwnum),
        .busW(MemtoReg ? data_read_data : aluresult),
        .busA(Ra),
        .busB(Rb)
    );

    always @(*)
        case (ALUBsrc)
            2'b01: datab = imm;
            2'b10: datab = 4;
            2'b00: datab = Rb;
        endcase

    wire less, zero;

    ALU alu(
        .dataa(dataa),
        .datab(datab),
        .ALUctr(ALUctr),
        .less(less),
        .zero(zero),
        .aluresult(aluresult)
    );

    jump_control JC(
        .branch(Branch),
        .less(less),
        .zero(zero),
        .pc_offset_sel(pc_offset_sel),
        .pc_source_sel(pc_source_sel)
    );

    assign data_write_en = MemWr;

    assign data_mode = MemOp;
    assign data_write_addr = aluresult;
    assign data_write_data = Rb;
    

    assign dmemwe = data_write_en;
    assign dmemop = data_mode;
    assign dbgdata = pc;
    assign imemaddr = inst_read_addr;
    assign dmemaddr = MemWr ? data_write_addr : data_read_addr;
    assign dmemdatain = data_write_data;
endmodule

`endif
