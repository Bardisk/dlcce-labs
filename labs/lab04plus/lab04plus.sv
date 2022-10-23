module ledmonitor(
    input wire clock,
    input wire rst,
    input wire [7:0] en,
    input wire [7:0][7:0] display,
    output wire [7:0] targeten,
    output wire [7:0] targetdisplay
);

    reg [2:0] select;

    assign targeten = (8'b11111111 ^ (8'b1 << select)) | (~en);
    assign targetdisplay = display[select];

    always @(posedge clock, negedge rst) begin
        if (!rst)
            select <= 0;
        else begin
            if (select == 7)
                select <= 0;
            else
                select <= (select + 1);
        end
    end

endmodule

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

module ledTube(
    input wire en,
    input wire signal,
    output wire light
);
    
    assign light = signal & en;

endmodule

module timeoutledTube(
    input wire en,
    input wire clock,
    input wire rst,
    input wire signal,
    output wire light
);
    parameter timeout = 10000;
    reg myen;
    reg [31:0] cnt;
    ledTube innerTube(myen, signal, light);
    always @(posedge clock, negedge rst) begin
        if (!rst) begin
            myen <= 0;
            cnt <= 0;
        end
        else begin
            if (!en) begin
                if (cnt == 0) myen <= 0;
                else cnt <= cnt - 1;
            end
            else begin
                myen <= 1;
                cnt <= timeout;
            end
        end
    end
endmodule

module clockGenerator(
    input wire oclock,
    input wire rst,
    output reg nclock
);

    parameter freq = 10000;
    parameter timeout = 50000000/freq - 1;

    reg [31:0] cnt;
    always @(posedge oclock, negedge rst) begin
        if (!rst) begin
            cnt <= 0;
            nclock <= 0;
        end
        else begin
            if (cnt >= timeout) begin
                cnt <= 0;
                nclock <= ~nclock;
            end
            else
                cnt <= cnt + 1;
        end
    end

endmodule

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

module clock(
    input wire clock_1HZ,
    input wire clock_10HZ,
    input wire clock_10KHZ,
    input wire clock_1HZ_real,
    input wire reset,
    input wire adjust,
    input wire [5:0] adjustline,
    output wire adjustlight,
    input wire trysetalert,
    output wire setalertlight,
    input wire enablealert,
    output wire enablealertlight,
    output wire alertlight,
    output wire [7:0] HEX,
    output wire [7:0] AN
);

    reg [7:0] hour, minute, second;

    assign adjustlight = adjust;
    
    wire setalert;
    assign setalert = trysetalert & (!adjust);
    assign setalertlight = setalert;
    assign enablealertlight = enablealert;

    //adjust
    reg [7:0] adh, adm, ads;

    //alert
    reg [7:0] alh, alm, als;

    //hour
    always @(posedge clock_1HZ, negedge reset) begin
        if(!reset) begin
            hour <= 0;
        end
        else begin
            if (!adjust) begin
                if (minute >= 59 && second >= 59) begin
                    if (hour >= 23) hour <= 0;
                    else hour <= hour + 1;
                end
            end
            else hour <= adh;
        end
    end

    //minute
    always @(posedge clock_1HZ, negedge reset) begin
        if(!reset) begin
            minute <= 0;
        end
        else begin
            if (!adjust) begin
                if (second >= 59) begin
                    if (minute >= 59) minute <= 0;
                    else minute <= minute + 1;
                end
            end
            else minute <= adm;
        end
    end

    //second
    always @(posedge clock_1HZ, negedge reset) begin
        if(!reset) begin
            second <= 0;
        end
        else begin
            if (!adjust) begin
                if (second >= 59) second <= 0;
                else second <= second + 1;
            end
            else second <= ads;
        end
    end

    //adh
    always @(posedge clock_1HZ_real, negedge reset) begin
        if(!reset) begin
            adh <= 0;
        end
        else begin
            if (adjust) begin
                if (adjustline[5]) begin
                    if (adh >= 14) begin
                        if (adh >= 20)
                            adh <= adh - 20;
                        else adh <= adh - 10;
                    end
                    else
                        adh <= adh + 10;
                end
                else if (adjustline[4]) begin
                    if (adh >= 23)
                        adh <= 0;
                    else
                        adh <= adh + 1;
                end
            end
            else adh <= hour;
        end
    end

    //adm
    always @(posedge clock_1HZ_real, negedge reset) begin
        if(!reset) begin
            adm <= 0;
        end
        else begin
            if (adjust) begin
                if (adjustline[3]) begin
                    if (adm >= 50)
                        adm <= adm - 50;
                    else
                        adm <= adm + 10;
                end
                else if (adjustline[2]) begin
                    if (adm >= 59)
                        adm <= 0;
                    else
                        adm <= adm + 1;
                end
            end
            else adm <= minute;
        end
    end

    //ads
    always @(posedge clock_1HZ_real, negedge reset) begin
        if(!reset) begin
            ads <= 0;
        end
        else begin
            if (adjust) begin
                if (adjustline[1]) begin
                    if (ads >= 50)
                        ads <= ads - 50;
                    else
                        ads <= ads + 10;
                end
                else if (adjustline[0]) begin
                    if (ads >= 59)
                        ads <= 0;
                    else
                        ads <= ads + 1;
                end
            end
            else ads <= second;
        end
    end

    //alh
    always @(posedge clock_1HZ_real, negedge reset) begin
        if(!reset) begin
            alh <= 0;
        end
        else begin
            if (setalert) begin
                if (adjustline[5]) begin
                    if (alh >= 14) begin
                        if (alh >= 20)
                            alh <= alh - 20;
                        else alh <= alh - 10;
                    end
                    else
                        alh <= alh + 10;
                end
                else if (adjustline[4]) begin
                    if (alh >= 23)
                        alh <= 0;
                    else
                        alh <= alh + 1;
                end
            end
        end
    end

    //alm
    always @(posedge clock_1HZ_real, negedge reset) begin
        if(!reset) begin
            alm <= 0;
        end
        else begin
            if (setalert) begin
                if (adjustline[3]) begin
                    if (alm >= 50)
                        alm <= alm - 50;
                    else
                        alm <= alm + 10;
                end
                else if (adjustline[2]) begin
                    if (alm >= 59)
                        alm <= 0;
                    else
                        alm <= alm + 1;
                end
            end
        end
    end

    //als
    always @(posedge clock_1HZ_real, negedge reset) begin
        if(!reset) begin
            als <= 0;
        end
        else begin
            if (setalert) begin
                if (adjustline[1]) begin
                    if (als >= 50)
                        als <= als - 50;
                    else
                        als <= als + 10;
                end
                else if (adjustline[0]) begin
                    if (als >= 59)
                        als <= 0;
                    else
                        als <= als + 1;
                end
            end
        end
    end

    //distribute the display
    reg [7:0] dish, dism, diss;
    always @(*) begin
        if (reset) begin
            if (adjust) begin
                dish = adh;
                dism = adm;
                diss = ads;
            end
            else begin
                if (setalert) begin
                    dish = alh;
                    dism = alm;
                    diss = als;
                end
                else begin
                    dish = hour;
                    dism = minute;
                    diss = second;
                end
            end
        end
        else begin
            dish = hour;
            dism = minute;
            diss = second;
        end
    end

    //alertlight
    wire alertlighten;
    assign alertlighten = (enablealert && (hour == alh) && (minute == alm) && (second == als));

    timeoutledTube #(.timeout(10000)) alertube(
        .en(alertlighten),
        .clock(clock_10KHZ),
        .signal(clock_10HZ),
        .rst(reset),
        .light(alertlight)
    );

    ledmonitorControllerClock monitorController(
        .clock(clock_10KHZ),
        .rst(reset),
        .hour(dish),
        .minute(dism),
        .second(diss),
        .targeten(AN),
        .targetdisplay(HEX)
    );

endmodule

`define SIM

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

module lab04plus(
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