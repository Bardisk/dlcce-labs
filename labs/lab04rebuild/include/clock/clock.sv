`ifndef module_clock
`define module_clock

`include "ledmonitorControllerClock/ledmonitorControllerClock.sv"
`include "ledTubes/ledTubes.sv"

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

`endif
