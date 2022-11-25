`ifndef module_Memory
`define module_Memory

`define TPLT_VRAM   7001
`define CHAR_VRAM   7002
`define CHAR_ROM    9001

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

    always @(posedge memclk)
        if (en && wen)
            memory[write_addr] <= datain;
    
    integer i;

    initial begin
        if (typ == `TPLT_VRAM)
            $readmemh("C:/Users/Bardi/Work/Hardware/Shadow/memories/VRAM_templates/shizuku1.memory", memory, 0, size - 1);
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
    parameter length = 16,
)(
    input   wire            wren,
    input   wire            rden,
    input   wire    [8]
    output data,
    output 
);


endmodule

`endif
