`timescale 1ns/1ps

`include "lab09.sv"

module Visual_Adapter_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

Visual_Adapter tb(

);

endmodule

