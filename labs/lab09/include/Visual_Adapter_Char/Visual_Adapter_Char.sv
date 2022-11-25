`ifndef module_Visual_Adapter_Char
`define module_Visual_Adapter_Char

`include "Memory/Memory.sv"

module Visual_Adapter_Char(
    input   wire                clk,
    input   wire                fclk,
    input   wire                rst,
    input   wire                valid,
    input   wire    [9:0]       h_addr,
    input   wire    [9:0]       v_addr,
    input   wire    [7:0]       response,
    output  wire    [10:0]      req_addr,
    output  wire    [3:0]       vga_r,
    output  wire    [3:0]       vga_g,
    output  wire    [3:0]       vga_b,
);

    parameter block_width = 9;
    parameter block_height = 16;
    parameter field_width = 70;
    parameter field_height = 30;
    parameter screen_width = 640;
    parameter screen_

    wire [3:0] offsetw, offseth;
    always @(posedge clk) begin
        if (offsetw < block_width - 1 || h_addr)
            
    end

    wire [11:0] out;
    reg [11:0] rom_addr;

    ROM char_rom(
        .memclk(fclk)
        .read_addr(rom_addr),
        .en(1'b1),
        .dataout(out)
    );

    always @(posedge clk) begin
        
    end

    always @(negedge clk) begin
        
    end

endmodule

`endif
