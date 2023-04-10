`timescale 1ns/1ps

`include "unisys.sv"

module Number_Screen_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

Number_Screen tb(

);

endmodule

