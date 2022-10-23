`ifndef module_timer
`define module_timer

`include "ledmonitorControllerTimer/ledmonitorControllerTimer.sv"

module timer(
    input wire clock_10KHZ,
    input wire clock_100HZ,
    input wire reset,
    input wire trystart,
    input wire suspend,
    output wire runninglight,
    output wire [7:0] HEX,
    output wire [7:0] AN
);
    reg [31:0] systime;

    wire toten;
    assign runninglight = toten;
    assign toten = !suspend & ((systime != 0) | trystart);

    always @(posedge clock_100HZ, negedge reset) begin
        if (!reset)
            systime <= 0;
        else
            if (toten)
                systime <= systime + 1;
    end

    ledmonitorControllerTimer monitorController(
        .systime(systime),
        .rst(reset),
        .clock(clock_10KHZ),
        .targetdisplay(HEX),
        .targeten(AN)
    );

endmodule

`endif
