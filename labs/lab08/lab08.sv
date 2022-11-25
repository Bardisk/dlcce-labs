`include "clockGenerator/clockGenerator.sv"
`include "RAM/RAM.sv"
`include "Vga_Ctr/Vga_Ctr.sv"
`include "Mem_Ctr/Mem_Ctr.sv"
`include "Display_Ctr/Display_Ctr.sv"
`include "Mem_Ctr/Mem_Ctr.sv"
`include "Vga_Ctr/Vga_Ctr.sv"
//add includes here

`ifdef SIM
    `define SPEED 100
`else
    `define SPEED 25000000
`endif

module lab08(
    input   wire                clock100MHZ,
    input   wire    [15:0]      SW,
    output  wire    [3:0]       VGA_R,
    output  wire    [3:0]       VGA_G,
    output  wire    [3:0]       VGA_B,
    output  wire                VGA_HS,
    output  wire                VGA_VS,
    output  wire    [15:0]      LED
);

    wire clock25MHZ;
    clockGenerator #(.freq(`SPEED)) clockgen25MHZ(clock100MHZ, SW[0], clock25MHZ);

    assign LED[15:2] = {VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS};

    Display_Ctr display_ctr(
        .clk(clock25MHZ),
        .fclk(clock100MHZ),
        .rst(SW[0]),
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .valid(LED[0])
    );

endmodule
