`timescale 1ns/1ps
module lab04plus_tb();

initial
begin
    $dumpfile("lab04plus_wave.vcd");
    $dumpvars;
end

reg clock;
wire [15:0] LED;
reg [15:0] SW = 0;
wire [7:0] HEX;
wire [7:0] AN;

always #1
    clock = ~clock;

lab04plus tb(
    .clock_100MHZ(clock),
    .LED(LED),
    .SW(SW),
    .AN(AN),
    .HEX(HEX)
);

wire suspend;
assign suspend = SW[0];
wire reset;
assign reset = ~SW[1];
wire beginsw;
assign beginsw = SW[2];

wire [2:0] mode;
assign mode = SW[15:13];

initial begin

    clock = 0;

    SW[1] = 1;
    #100
    SW[1] = 0;
    #100
    SW[15:13] = 3'b001;
    #100
    SW[2] = 1;
    #90000
    SW[0] = 1;
    #1000
    SW[0] = 0;
    #5000
    SW[1] = 1;
    #1000
    SW[1] = 0;
    #10000
    $finish;
end

endmodule
