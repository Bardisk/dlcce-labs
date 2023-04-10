`define SIM

`include "config/config.sv"
//add includes here

module unisys(
    input   wire    [15:0]  SW,
    output  wire    [15:0]  LED,
    output  wire    [7:0]   HEX,
    output  wire    [7:0]   AN,
    output  wire    [3:0]   VGA_R,
    output  wire    [3:0]   VGA_G,
    output  wire    [3:0]   VGA_B,
    output  wire            VGA_HSYNC,
    output  wire            VGA_
);



endmodule
