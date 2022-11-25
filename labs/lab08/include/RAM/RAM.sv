`ifndef module_RAM
`define module_RAM

module RAM #(
    parameter width = 8,
    parameter addr_width = 19,
    parameter size = 2**addr_width
    //A 512KB RAM by default
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
    initial begin
        $readmemh("C:/Users/Bardi/Desktop/default.memory", memory, 0, size - 1);
    end
endmodule

`endif
