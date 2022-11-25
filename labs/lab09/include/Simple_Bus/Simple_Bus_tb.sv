`timescale 1ns/1ps

`include "lab09.sv"

module Simple_Bus_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

Simple_Bus tb(

);

endmodule

