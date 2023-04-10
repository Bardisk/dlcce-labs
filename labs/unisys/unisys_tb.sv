`timescale 1ns/1ps

`include "unisys.sv"

module unisys_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

unisys tb(

);

endmodule

