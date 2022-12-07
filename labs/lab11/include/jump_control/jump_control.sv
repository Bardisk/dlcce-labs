`ifndef module_jump_control
`define module_jump_control

`include "config/config.sv"

module jump_control(
    input   wire    [2:0]   branch,
    input   wire            zero,
    input   wire            less, 
    output  wire            pc_source_sel,
    output  wire            pc_offset_sel
);

    reg [1:0] pc_sel;
    assign {pc_source_sel, pc_offset_sel} = pc_sel;

    always @(*)
        casex ({branch, zero, less})
            5'b000xx: pc_sel = 2'b00;
            5'b001xx: pc_sel = 2'b01;
            5'b010xx: pc_sel = 2'b11;
            5'b1000x: pc_sel = 2'b00;
            5'b1001x: pc_sel = 2'b01;
            5'b1010x: pc_sel = 2'b01;
            5'b1011x: pc_sel = 2'b00;
            //to-do
            5'b110x0: pc_sel = 2'b00;
            5'b110x1: pc_sel = 2'b01;
            5'b111x0: pc_sel = 2'b01;
            5'b111x1: pc_sel = 2'b00;
        endcase

endmodule

`endif
