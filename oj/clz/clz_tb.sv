`timescale 1ns/1ps

`include "clz.sv"

module clz_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

endmodule

