`timescale 1ns/1ps

`include "lab09.sv"



module lab09_tb();
reg rst = 0;
reg clock = 0;
always #1
    clock = ~clock;

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;

    #10
    rst = 1;
    #4000000
    $finish;
end

lab09 tb(
.clock100MHZ(clock),.SW({15'b0, rst})
);

endmodule

