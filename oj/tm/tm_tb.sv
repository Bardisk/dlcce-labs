`timescale 1ns/1ps

`include "tm.sv"

module tm_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

tm tb(

);

endmodule

