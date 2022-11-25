`timescale 1ns/1ps

`include "attendance.sv"

module attendance_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

attendance tb(

);

endmodule

