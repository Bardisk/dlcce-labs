`timescale 1ns/1ps

module lab04_tb();
    reg clock;
    wire [15:0] LED;
    reg [15:0] SW = 0;
    wire [7:0] HEX;
    wire [7:0] AN;

    always #1
        clock = ~clock;
    
    lab04 tb(
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

    wire runninglight;
    assign runninglight = LED[0];

    wire endlight;
    assign endlight = LED[1];

    wire [7:0] display0;
    assign display0 = tb.monitorController.display[0];
    wire [7:0] display1;
    assign display1 = tb.monitorController.display[1];

    initial begin
        clock = 0;
        $dumpfile("lab04_wave.vcd");
        $dumpvars;

        #10 SW[1] = 1;
        #10 SW[1] = 0;
        #100 SW[2] = 1;
        #100 SW[2] = 0;
        #1000 SW[2] = 1;
        #1000 SW[0] = 1;
        #1000 SW[0] = 0;
        #100 SW[2] = 0;
        #100 SW[1] = 1;
        #100 SW[1] = 0;

        $finish;
    end
endmodule
