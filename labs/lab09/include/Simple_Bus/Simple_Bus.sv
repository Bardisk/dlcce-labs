`ifndef module_Simple_Bus
`define module_Simple_Bus

`include "keyboardCtr/keyboardCtr.sv"
`include "Vga_Ctr/Vga_Ctr.sv"
`include "Memory/Memory.sv"
`include "Full_GAC/Full_GAC.sv"
`include "Kbd_CU/Kbd_CU.sv"
`include "Simple_MMU/Simple_MMU.sv"
`include "Simple_MCU/Simple_MCU.sv"

module Simple_Bus(
    input   wire            clk,
    input   wire            vclk,
    input   wire            sclk,
    input   wire            rst,
    input   wire            ps2_clk,
    input   wire            ps2_data,
    output  wire    [3:0]   vga_r,
    output  wire    [3:0]   vga_g,
    output  wire    [3:0]   vga_b,
    output  wire            hsync,
    output  wire            vsync
);

    wire kbd_en;
    wire [`HALF_WIDE] kbd_respond;
    wire kbd_r_ready;

    wire vga_char_wen;
    wire [`BYTE_WIDE] vga_char_w_data;
    wire vga_w_ready;

    Kbd_CU kbd(
        .clk(clk),
        .rst(rst),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .wen(kbd_en),
        .ready(kbd_r_ready),
        .mdata(kbd_respond)
    );

    Full_GAC gac(
        .clk(clk),
        .vclk(vclk),
        .sclk(sclk),
        .rst(rst),
        .wen(vga_char_wen),
        .datain(vga_char_w_data),
        .ready(vga_w_ready),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .hsync(hsync),
        .vsync(vsync)
    );

    wire [`WORD_WIDE] r_addr;
    wire [`WORD_WIDE] w_addr;
    wire [`WORD_WIDE] r_data;
    wire [`WORD_WIDE] w_data;
    wire en, wen, w_ready, r_ready;

    Simple_MMU mmu(
        .r_addr(r_addr),
        .w_addr(w_addr),
        .r_data(r_data),
        .w_data(w_data),
        .w_ready(w_ready),
        .r_ready(r_ready),
        .r_mode(0),
        .w_mode(0),
        .tmem_r_data(0),
        .dmem_r_data(0),
        .en(en),
        .wen(wen),
        .kbd_en(kbd_en),
        .kbd_respond(kbd_respond),
        .kbd_r_ready(kbd_r_ready),
        .vga_char_wen(vga_char_wen),
        .vga_char_w_data(vga_char_w_data),
        .vga_w_ready(vga_w_ready)
    );

    Simple_MCU mcu(
        .clk(clk),
        .rst(rst),
        .r_addr(r_addr),
        .w_addr(w_addr),
        .r_data(r_data),
        .w_data(w_data),
        .w_enable(wen),
        .r_enable(en),
        .w_ready(w_ready),
        .r_ready(r_ready)
    );

endmodule

`endif
