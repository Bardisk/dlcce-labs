`timescale 1ns/1ps

`include "lfsr-zzx.sv"

module lfsrzzx_tb();

reg clk = 0;
always #1 clk = ~clk;

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

wire [7:0] ledoutput;
reg on = 0;

lfsrzzx tb(
    .clk(clk),
    .rst(on),
    .seed(8'h36),
    .ledoutput(ledoutput)
);

initial begin
    #10 on = 1;
    #2000
    $finish;
end

endmodule

