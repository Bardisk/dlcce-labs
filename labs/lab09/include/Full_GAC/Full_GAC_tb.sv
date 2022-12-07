`timescale 1ns/1ps

`include "Full_GAC/Full_GAC.sv"
`include "config/config.sv"

module Full_GAC_tb();

reg clock = 0;
reg reset = 0;
always #1
    clock = ~clock;

reg wen;
reg [`BYTE_WIDE] datain;

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
    #10;
    reset = 1;
    wen = 1;
    datain = 8'h60;
    #500
    datain = `ASCII_LF;
    #10
    datain = `ASCII_BACK;
    #150
    datain = 8'h60;
    #150000
    $finish;
    
end



Graphics_Adapter_Char tb(
    .clk(clock),
    .rst(reset),
    .wen(wen),
    .datain(datain),
    .gac_ready(1),
    .gac_response(0)
);

endmodule

