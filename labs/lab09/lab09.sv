`define SIM

`include "clockGenerator/clockGenerator.sv"
`include "Visual_Adapter_Char/Visual_Adapter_Char.sv"
`include "keyboardCtr/keyboardCtr.sv"
`include "Simple_Bus/Simple_Bus.sv"
`include "Vga_Ctr/Vga_Ctr.sv"
`include "ledmonitor/ledmonitor.sv"
`include "config/config.sv"
`include "Kbd_CU/Kbd_CU.sv"
`include "Simple_MMU/Simple_MMU.sv"
`include "Simple_MCU/Simple_MCU.sv"
`include "Full_GAC/Full_GAC.sv"
`include "lab11/lab11.sv"
//add includes here

module lab09(
    input   wire                clock100MHZ,
    input   wire    [15:0]      SW,
    input   wire                ps2_clk,
    input   wire                ps2_data,
    output  wire    [3:0]       VGA_R,
    output  wire    [3:0]       VGA_G,
    output  wire    [3:0]       VGA_B,
    output  wire                VGA_HS,
    output  wire                VGA_VS,
    output  wire    [15:0]      LED
);

    wire clock25MHZ, clock1HZ;
    clockGenerator #(.freq(25000000)) clock25MHZgener(clock100MHZ, SW[0], clock25MHZ);
    clockGenerator #(.freq(1)) clock1HZgener(clock100MHZ, SW[0], clock1HZ);

    Simple_Bus main(
        .clk(clock100MHZ),
        .vclk(clock25MHZ),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .sclk(clock1HZ),
        .rst(SW[0]),
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B),
        .hsync(VGA_HS),
        .vsync(VGA_VS)
    );

endmodule
