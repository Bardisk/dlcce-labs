`timescale 1ns/1ps

`include "lab11.sv"

module pc_generator_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

pc_generator tb(

);

endmodule

