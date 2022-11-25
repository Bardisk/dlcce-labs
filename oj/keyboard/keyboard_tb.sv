`timescale 1ns/1ps

`include "keyboard.sv"

module keyboard_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

keyboard tb(

);

endmodule

