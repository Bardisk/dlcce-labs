`timescale 1ns/1ps

`include "ojcpu/ojcpu.sv"
module ojcpu_tb();

reg clk = 1, rst = 1;
reg [`WORD_WIDE] inst_read_data = 0;

always #1
    clk = ~clk;

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

initial begin
    #1
    rst = 0;
    #1
    inst_read_data = 32'h000f0067;
    #20
    
    $finish;
end

rv32is tb(
    .clock(clk),
    .reset(rst),
    .imemdataout(inst_read_data)
);
    

endmodule

