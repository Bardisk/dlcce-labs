`timescale 1ns/1ps

`include "template.sv"

module template_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

template tb(

);

endmodule

