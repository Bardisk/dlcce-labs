`ifndef module_Memory
`define module_Memory

`define TPLT_VRAM   7001
`define CHAR_VRAM   7002
`define CHAR_ROM    9001
`define MAIN_VRAM   7000

module RAM #(
    parameter width = 8,
    parameter addr_width = 19,
    parameter size = 2**addr_width,
    parameter typ = `MAIN_VRAM
    //A 512KB Memory by default
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
    generate
        
    endgenerate
    generate
        if (typ == `CHAR_VRAM) begin
            
            always @(posedge memclk) begin
                
            end
        end
    endgenerate

    reg [width-1:0] memory [size-1:0];

    initial begin
        dataout <= 0;
    end
    
    always @(posedge memclk)
        if (en)
            dataout <= memory[read_addr];
        else
            dataout <= 0;

    always @(posedge memclk)
        if (en && wen)
            memory[write_addr] <= datain;
    
    integer i;

    initial begin
        if (typ == `TPLT_VRAM)
            $readmemh("C:/Users/Bardi/Work/Hardware/Shadow/memories/VRAM_templates/shizuku1.memory", memory, 0, size - 1);
        else if (typ == `CHAR_VRAM)
            $readmemh("C:/Users/Bardi/Work/Hardware/Shadow/memories/VRAM_templates/charram.memory", memory, 0, 10);
        else begin
            for (i = 0; i < size; i++)
                memory[i] = 0;
        end
    end
endmodule

module ROM #(
    parameter width = 12,
    parameter addr_width = 12,
    parameter size = 2**addr_width,
    parameter typ = `CHAR_ROM
    //A 512KB Memory by default
)(
    input   wire    [addr_width-1:0]    read_addr,
    input   wire                        memclk,
    input   wire                        en,
    output  reg     [width-1:0]         dataout
);

    reg [width-1:0] memory [size-1:0];

    initial begin
        dataout <= 0;
    end
    
    always @(posedge memclk)
        if (en)
            dataout <= memory[read_addr];
        else
            dataout <= 0;

    initial begin
        if (typ == `CHAR_ROM)
            $readmemh("C:/Users/Bardi/Work/Hardware/Shadow/memories/font.memory", memory, 0, size - 1);
    end
endmodule

module FIFO
#(
    parameter addr_length = 4,
    parameter width = 8
)(
    input   wire                    clk,
    input   wire                    rst,
    input   wire                    wren,
    input   wire                    rden,
    input   wire    [width-1:0]     datain,
    output  wire    [width-1:0]     dataout,
    output  reg                     valid,
    output  reg                     overflow
);

    reg [width-1:0] body [(2**addr_length-1):0];
    reg [addr_length-1:0] w_ptr, r_ptr;

    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
            overflow <= 0;
            valid <= 0;
        end
        else begin
            if (rden && valid) begin
                r_ptr <= r_ptr + {width{1'b1}};
                if (w_ptr == r_ptr + {width{1'b1}})
                    valid <= 0;
            end
            if (wren) begin
                body[w_ptr] <= datain;
                w_ptr <= w_ptr +  {width{1'b1}};
                valid <= 1;
                overflow <= overflow | (r_ptr == (w_ptr +  {width{1'b1}}));
            end
        end
    end

    assign dataout = body[r_ptr];

endmodule

// module Memhub_Write #(
//     parameter width = 8,
//     parameter addr_width = 19,
//     parameter channels = 2,
//     //A 512KB Memory by default
// )(
//     input   wire    [addr_width-1:0]    write_addr [channels-1:0],
//     input   wire    [width-1:0]         datain [channels-1:0],
//     input   wire    [channels-1:0]      en,
//     input   wire    []      wen,
//     output  reg     [width-1:0]         dataout
// );

//     FIFO #(.width(addr_width + width))

// endmodule

`endif
