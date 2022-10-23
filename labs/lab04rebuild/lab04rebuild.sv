`define SIM

`include "ledmonitor/ledmonitor.sv"
`include "ledmonitorControllerTimer/ledmonitorControllerTimer.sv"
`include "ledTubes/ledTubes.sv"
`include "clockGenerator/clockGenerator.sv"
`include "ledmonitorControllerClock/ledmonitorControllerClock.sv"
`include "timer/timer.sv"
`include "clock/clock.sv"
`include "ledTubes/ledTubes.sv"
//add includes here


`ifdef SIM
    `define TIMEMUL (100000)
    `define TTH (10000000)
`endif

`ifdef DEF
    `define TIMEMUL (1)
    `define TTH (10000)
`endif

`ifdef FST
    `define TIMEMUL (100)
    `define TTH (10000)
`endif

`ifdef UFST
    `define TIMEMUL (1000)
    `define TTH (10000)
`endif

module lab04rebuild(
    input wire clock_100MHZ,
    input wire [15:0] SW,
    output wire [15:0] LED,
    output wire [7:0] HEX,
    output wire [7:0] AN
);

    wire reset;
    assign reset = ~SW[1];

    wire [2:0] mode;
    assign mode = SW[15:13];
    assign LED[15:13] = SW[15:13];

    wire [7:0] groupreset;
    assign groupreset = 8'b0 | ((8'b0 | reset) << mode);

    wire suspend;
    assign suspend = SW[0];

    wire trystart;
    assign trystart = SW[2];

    wire clock_10KHZ;
    clockGenerator #(.freq(`TTH)) generator10KHZ(
        .oclock(clock_100MHZ),
        .nclock(clock_10KHZ),
        .rst(reset)
    );

    wire clock_10HZ;
    clockGenerator #(.freq(10)) generator10HZ(
        .oclock(clock_100MHZ),
        .nclock(clock_10HZ),
        .rst(reset)
    );

    wire clock_100HZ;
    clockGenerator #(.freq(100*`TIMEMUL)) generator100HZ(
        .oclock(clock_100MHZ),
        .nclock(clock_100HZ),
        .rst(reset)
    );

    wire clock_1HZ;
    clockGenerator #(.freq(1*`TIMEMUL)) generator1HZ(
        .oclock(clock_100MHZ),
        .nclock(clock_1HZ),
        .rst(reset)
    );
    
    wire clock_1HZ_real;
    clockGenerator #(.freq(1)) generator1HZ_real(
        .oclock(clock_100MHZ),
        .nclock(clock_1HZ_real),
        .rst(reset)
    );

    wire [7:0] targetHEX [7:0];
    wire [7:0] targetAN [7:0];
    wire [5:0] publicLED [7:0];

    assign HEX = targetHEX[mode];
    assign AN = targetAN[mode];
    assign LED[5:0] = publicLED[mode];

    timer mainTimer(
        .clock_10KHZ(clock_10KHZ),
        .clock_100HZ(clock_100HZ),
        .reset(groupreset[1]),
        .trystart(trystart),
        .suspend(suspend),
        .runninglight(publicLED[1][0]),
        .HEX(targetHEX[1]),
        .AN(targetAN[1])
    );

    clock mainClock(
        .clock_1HZ(clock_1HZ),
        .clock_10HZ(clock_10HZ),
        .clock_10KHZ(clock_10KHZ),
        .clock_1HZ_real(clock_1HZ_real),
        .reset(groupreset[0]),
        .adjust(SW[0]),
        .adjustline(SW[9:4]),
        .adjustlight(publicLED[0][0]),
        .trysetalert(SW[2]),
        .setalertlight(publicLED[0][2]),
        .enablealert(SW[3]),
        .enablealertlight(publicLED[0][3]),
        .alertlight(publicLED[0][1]),
        .HEX(targetHEX[0]),
        .AN(targetAN[0])
    );
    
endmodule
