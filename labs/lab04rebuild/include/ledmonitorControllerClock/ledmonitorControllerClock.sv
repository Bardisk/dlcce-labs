`ifndef module_ledmonitorControllerClock
`define module_ledmonitorControllerClock

`include "ledmonitor/ledmonitor.sv"

module ledmonitorControllerClock(
    input wire clock,
    input wire rst,
    input wire [7:0] hour,
    input wire [7:0] minute,
    input wire [7:0] second,
    output wire [7:0] targeten,
    output wire [7:0] targetdisplay
);

    reg [7:0][7:0] display;

    always @(hour) begin
        display[6] = seg7(hour % 10, 0);
        display[7] = seg7(hour / 10, 0);
    end

    always @(minute) begin
        display[4] = seg7(minute % 10, 0);
        display[5] = seg7(minute / 10, 0);
    end

    always @(second) begin
        display[2] = seg7(second % 10, 0);
        display[3] = seg7(second / 10, 0);
    end

    ledmonitor mainMonitor(
        .clock(clock),
        .rst(rst),
        .en(8'b11111100),
        .display(display),
        .targeten(targeten),
        .targetdisplay(targetdisplay)
    );

    function [7:0] seg7;
        input [3:0] N;
        input dot;
        begin
        casex (N)
            9: seg7 = 8'b0010000;
            8: seg7 = 8'b0000000;
            7: seg7 = 8'b1111000;
            6: seg7 = 8'b0000010;
            5: seg7 = 8'b0010010;
            4: seg7 = 8'b0011001;
            3: seg7 = 8'b0110000;
            2: seg7 = 8'b0100100;
            1: seg7 = 8'b1111001;
            0: seg7 = 8'b1000000;
            default: seg7 = 8'b1111111;
        endcase
        if (dot == 0)
            seg7 = seg7 + 8'b10000000;
        end
    endfunction

endmodule

`endif
