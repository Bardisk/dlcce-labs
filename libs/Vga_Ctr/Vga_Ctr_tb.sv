`timescale 1ns/1ps

`include "lab08.sv"

module Vga_Ctr_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

Vga_Ctr tb(

);

endmodule

