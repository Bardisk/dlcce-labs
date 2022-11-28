`ifndef module_Display_Ctr
`define module_Display_Ctr

`include "RAM/RAM.sv"
`include "Vga_Ctr/Vga_Ctr.sv"

module Display_Ctr(
    input   wire            clk,
    input   wire            fclk,
    input   wire            rst,
    output  wire    [3:0]   vga_r,
    output  wire    [3:0]   vga_g,
    output  wire    [3:0]   vga_b,
    output  wire            hsync,
    output  wire            vsync,
    output  wire            valid
);

    wire [9:0] h_addr, v_addr;
    Vga_Ctr vga_ctr(
        .clk(clk),
        .rst(rst),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .valid(valid),
        .hsync(hsync),
        .vsync(vsync)
    );

    wire [18:0] vmemidx;
    assign vmemidx = {h_addr, v_addr[8:0]};

    Mem_Ctr mem_ctr(
        .clk(fclk),
        .position(vmemidx),
        .en(valid),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );    


endmodule

`endif
