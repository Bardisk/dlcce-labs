`timescale 1ns/1ps

`include "lab09.sv"

module Simple_MCU_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

Simple_MCU tb(

);

endmodule

