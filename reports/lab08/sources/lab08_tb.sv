`timescale 1ns/1ps

`include "lab08.sv"

module lab08_tb();

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars;
end

reg [15:0] SW;
reg clock100MHZ=0;

always #1 begin
    clock100MHZ = ~clock100MHZ;
end

lab08 tb(
    .SW(SW),
    .clock100MHZ(clock100MHZ)
);

initial begin
    SW[0] = 0;
#10
    SW[0] = 1;
#4000000
$finish;
end

endmodule

