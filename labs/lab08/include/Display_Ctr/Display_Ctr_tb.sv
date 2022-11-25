`timescale 1ns/1ps

`include "lab08.sv"

module Display_Ctr_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

Display_Ctr tb(

);

endmodule

