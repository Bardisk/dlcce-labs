`ifndef module_pc_generator
`define module_pc_generator

`include "config/config.sv"

module pc_generator(
    input   wire    [`WORD_WIDE]    pc,             //pcbsrc
    input   wire                    pc_source_sel,  //pcasrc
    input   wire                    pc_offset_sel,
    input   wire    [`WORD_WIDE]    jalr_reg,
    input   wire    [`WORD_WIDE]    offset,
    output  wire    [`WORD_WIDE]    next_pc
);

    
    wire [`WORD_WIDE] pc_source = pc_source_sel ? jalr_reg : pc;
    wire [`WORD_WIDE] pc_offset = pc_offset_sel ? offset : 4;

    assign next_pc = pc_source + pc_offset;

endmodule

`endif
