`ifndef module_Mem_Ctr
`define module_Mem_Ctr

`include "RAM/RAM.sv"

module Mem_Ctr(
    input   wire            clk,
    input   wire    [18:0]  position,    
    input   wire            en,        
    output  wire    [3:0]   vga_r,
    output  wire    [3:0]   vga_g,
    output  wire    [3:0]   vga_b
);

    wire [11:0] data;
//    wire [18:0] r_addr = position;
    // reg offset = 0;
    // reg [7:0] res [1:0];

    RAM #(
        .width (12),
        .addr_width (19),
        .size (327680)
    ) vmem(
        .memclk(clk),
        .read_addr(position),
        .write_addr(19'b0),
        .datain(12'b0),
        .en(en),
        .wen(1'b0),
        .dataout(data)
    );

    assign vga_r = en ? (data[11:8]) : 4'b0;  
    assign vga_g = en ? (data[ 7:4]) : 4'b0;  
    assign vga_b = en ? (data[ 3:0]) : 4'b0;  


    // always @(posedge clk) begin
    //     offset <= ~offset;
    // end

    // always @(posedge clk)
    //     if(en)
    //         if (position[0])
    //             r_addr <= (position >> 1) * 3 + offset;
    //         else
    //             r_addr <= (position >> 1) * 3 + offset + 1;

    // always @(offset)
    //     if (offset)
    //         res[1] = data;
    //     else
    //         res[0] = data;

    // assign vga_r = en ? (position[0] ? res[1][3:0] : res[1][7:4]) : 4'b0;  
    // assign vga_g = en ? (position[0] ? res[0][7:4] : res[1][3:0]) : 4'b0;
    // assign vga_b = en ? (position[0] ? res[0][3:0] : res[0][7:4]) : 4'b0;

endmodule

`endif
