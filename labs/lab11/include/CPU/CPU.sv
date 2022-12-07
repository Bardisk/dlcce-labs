`ifndef module_CPU
`define module_CPU

`include "config/config.sv"
`include "control_signal_generator/control_signal_generator.sv"
`include "imm_generator/imm_generator.sv"
`include "pc_generator/pc_generator.sv"
`include "inst_memory/inst_memory.sv"
`include "data_memory/data_memory.sv"
`include "regheap/regheap.sv"
`include "CPU/CPU.sv"
`include "ALU/ALU.sv"
`include "jump_control/jump_control.sv"

module CPU(
    input   wire                    clk,
    input   wire                    rst,
    output  wire    [`WORD_WIDE]    inst_read_addr,
    input   wire    [`WORD_WIDE]    inst_read_data,
    output  wire                    inst_read_en,
    output  wire    [`WORD_WIDE]    data_read_addr,
    output  wire    [`WORD_WIDE]    data_write_addr,
    input   wire    [`WORD_WIDE]    data_read_data,
    output  wire    [`WORD_WIDE]    data_write_data,
    output  wire                    data_read_en,
    output  wire                    data_write_en,
    output  wire    [2:0]           data_mode
);

    reg [`WORD_WIDE] pc;
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

    regheap RH(
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
    assign data_read_en = MemtoReg;
    assign inst_read_en = 1;

    assign data_mode = MemOp;
    assign data_write_addr = aluresult;
    assign data_write_data = Rb;

endmodule

`endif
