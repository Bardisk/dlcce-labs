`ifndef module_ledmonitorControllerTimer
`define module_ledmonitorControllerTimer

`include "ledmonitor/ledmonitor.sv"

module ledmonitorControllerTimer(
    input wire clock,
    input wire rst,
    input wire [31:0] systime,
    output wire [7:0] targeten,
    output wire [7:0] targetdisplay
);

    reg [7:0][7:0] display;

    ledmonitor mainMonitor(
        .clock(clock),
        .rst(rst),
        .en(8'b11111111),
        .display(display),
        .targeten(targeten),
        .targetdisplay(targetdisplay)
    );

    always @(systime) begin
        //percent sec
        display[0] = seg7(systime % 10, 0);
        display[1] = seg7((systime / 10) % 10, 0);
        //second
        display[2] = seg7((systime / 100) % 10, 1);
        display[3] = seg7((systime / 1000) % 6, 0);
        //minute
        display[4] = seg7((systime / 6000) % 10, 0);
        display[5] = seg7((systime / 60000) % 6, 0);
        //hour
        display[6] = seg7(((systime / 360000) % 24) % 10, 0);
        display[7] = seg7(((systime / 360000) % 24) / 10, 0);
    end
    
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
