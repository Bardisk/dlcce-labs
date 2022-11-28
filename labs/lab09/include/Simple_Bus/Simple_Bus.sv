`ifndef module_Simple_Bus
`define module_Simple_Bus

`include "keyboardCtr/keyboardCtr.sv"
`include "Visual_Adapter_Char/Visual_Adapter_Char.sv"
`include "Vga_Ctr/Vga_Ctr.sv"
`include "Memory/Memory.sv"

module Simple_Bus(
    input   wire            clk,
    input   wire            vclk,
    input   wire            rst,
    output  wire    [3:0]   vga_r,
    output  wire    [3:0]   vga_g,
    output  wire    [3:0]   vga_b,
    output  wire            hsync,
    output  wire            vsync
);

    wire [9:0] h_addr, v_addr;
    wire valid, memen;

    Vga_Ctr vgacontroller(
        .clk(vclk),
        .rst(rst),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid)
    );

    wire [7:0] vmemout;
    wire [11:0] vmemWraddr, vmemRdaddr;
    wire reqvmemen;

    RAM #(8, 12, 4096, `CHAR_VRAM) vmem (
        .read_addr(vmemRdaddr),
        .write_addr(vmemWraddr),
        .datain(8'h00),
        .dataout(vmemout),
        .memclk(clk),
        .wen(1'b0),
        .en(reqvmemen)
    );
 
    Visual_Adapter_Char char_adapter (
        .clk(vclk),
        .fclk(clk),
        .rst(rst),
        .valid(valid),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .response(vmemout),
        .req_addr(vmemRdaddr),
        .req_en(reqvmemen),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

endmodule

`endif
