`timescale 1ns/1ps

`include "CPU/CPU.sv"

module CPU_tb();

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
    inst_read_data = 32'h00128293;
    #20
    $finish;
end

CPU tb(
    .clk(clk),
    .rst(rst),
    .inst_read_data(inst_read_data)
);
    

endmodule

