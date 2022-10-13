`timescale 1ns/1ps
module template_tb();

initial begin
    $dumpfile("template_wave.vcd");
    $dumpvars;
end

template tb(

);

initial begin
    $finish;
end

endmodule
