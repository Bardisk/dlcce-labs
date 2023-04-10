
`ifndef module_Main_Memory
`define module_Main_Memory

`include "config/config.sv"

module Main_Memory_Slice #(
    parameter width = 8,
    parameter addr_width = 16,
    parameter size = 2**addr_width,
    //A 64KB Memory Slice
)(
    input   wire    [addr_width-1:0]    read_addr,
    input   wire    [addr_width-1:0]    write_addr,
    input   wire    [width-1:0]         datain,
    input   wire                        memclk,
    input   wire                        en,
    input   wire                        wen,
    output  reg     [width-1:0]         dataout
    //used only for char_vram
);

    reg [width-1:0] memory [size-1:0];

    initial begin dataout <= 0; end
    
    always @(posedge memclk)
        if (en) dataout <= memory[read_addr];
        else dataout <= 0;

    always @(posedge memclk)
        if (en && wen)
            memory[write_addr] <= datain;
    
    integer i;

    initial begin
        for (i = 0; i < size; i++)
            memory[i] = 0;
    end
endmodule

module Main_Memory #(
    parameter width = 32,
    parameter slice = 4,
    parameter addr_width = 18,
    parameter size = 2**addr_width
)(
    input
);

    genvar i = slice;
    generate
        for (i = 0; i < slice; i = i + 1) begin: slices
            Main_Memory_Slice #(

            ) memory_chip(
                
            );
        end
    endgenerate

endmodule
`endif