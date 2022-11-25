`timescale 1ns/1ps

`include "dfa.sv"

module dfa_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

dfa tb(

);

endmodule

