//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 10/06/2022 10:06:29 PM
//// Design Name: 
//// Module Name: lab04
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////




//module LEDtube(
//        input light,
//        input en,
//        output reg target
//    );
    
//    always @(*)
//        if (en)
//            target = light;
//        else 
//            target = 0;
//endmodule

//module timeoutLEDtube(
//        input light,
//        input en,
//        input clk,
//        output target
//    );
//    parameter freq = 10000;
//    parameter timeout = 1000;
//    parameter limit = timeout * freq / 1000 - 1;
    
//    reg timeoutcnt = 0;
//    reg newen = 0;
//    LEDtube subtube(light, newen, target);
//    always @(negedge clk)
//    begin
//        if (en)
//        begin
//            newen <= 1;
//            timeoutcnt <= timeout;
//        end
//        else 
//        begin
//            if(newen)
//            begin
//                if (timeoutcnt >= 1)
//                    timeoutcnt <= timeoutcnt - 1;
//                else
//                    newen <= 0;
//            end
//        end
//    end
//endmodule

//function [7:0] seg7;
//    input [3:0] N;
//    input dot;
//    begin
//    casex (N)
//        9: seg7 = 8'b0010000;
//        8: seg7 = 8'b0000000;
//        7: seg7 = 8'b1111000;
//        6: seg7 = 8'b0000010;
//        5: seg7 = 8'b0010010;
//        4: seg7 = 8'b0011001;
//        3: seg7 = 8'b0110000;
//        2: seg7 = 8'b0100100;
//        1: seg7 = 8'b1111001;
//        0: seg7 = 8'b1000000;
//        default: seg7 = 8'b1111111;
//    endcase
//    if (dot == 0)
//        seg7 = seg7 + 8'b10000000;
//    end
//endfunction

//module monitor(
//        input clock,
////        input moden,
////        input [2:0] modselect,
////        input [7:0] modis,
//        input [5:0] nowNum,
//        input [7:0] en,
//        output reg [7:0] signal,
//        output reg [7:0] nowdisplay
//    );
    
//    reg [2:0] select;
//    always @(posedge clock)
//        begin
//        if (select == 7)
//            select <= 0;
//        else 
//            select <= select + 1;
//        end
    
//    always @(nowNum)
//    begin
//        display ;
//        display[0] = seg7(nowNum % 10, 0);
//        display[1] = seg7(nowNum / 10, 0);
//    end
   

//    always @(select)
//        case (select)
//            0: begin signal = 8'b11111110 | (~en); nowdisplay = display[0]; end
//            1: begin signal = 8'b11111101 | (~en); nowdisplay = display[1]; end
//            2: begin signal = 8'b11111011 | (~en); nowdisplay = display[2]; end
//            3: begin signal = 8'b11110111 | (~en); nowdisplay = display[3]; end
//            4: begin signal = 8'b11101111 | (~en); nowdisplay = display[4]; end
//            5: begin signal = 8'b11011111 | (~en); nowdisplay = display[5]; end
//            6: begin signal = 8'b10111111 | (~en); nowdisplay = display[6]; end
//            7: begin signal = 8'b01111111 | (~en); nowdisplay = display[7]; end
//       endcase
//endmodule

//module counter(
//        input clock,
//        input rst,
//        input en,
//        output reg [5:0] num 
//    );
    
//    always @(posedge clock)
//        begin
//            if(rst)
//            begin
//                num <= 0;
//            end
//            else
//            begin
//                if(en)
//                begin
//                    if (num == 59)
//                        num <= 0;
//                    else 
//                        num <= num + 1;
//                end
//            end
//        end
//endmodule

//module clkgen(
//        input clkin,
//        input rst,
//        input clken,
//        output reg clkout
//    );
//    parameter freq=1000;
//    parameter countlimit=50000000/freq-1;
//    reg [31:0] clkcnt;
//    always @(posedge clkin)
//    begin
//        if (rst)
//        begin
//            clkcnt <= 0;
//            clkout <= 0;
//        end
//        else 
//        begin
//            if (clkcnt >= countlimit)
//            begin
//                clkcnt <= 0;
//                clkout <= ~clkout; 
//            end
//            else 
//            begin
//                clkcnt <= clkcnt + 1;
//            end
//        end
//    end
//endmodule

//module fakeBottons(
//        input clk,
//        input watched,
//        output reg triggered
//    );
//    reg last = 0;
//    reg init = 0;
//    always @(posedge clk)
//    begin
//        if (!init)
//        begin
//            init = 1;
//            last = watched;
//            triggered = 0;
//        end
//        else
//        begin
//            if (last != watched)
//                triggered = 1;
//            else
//                triggered = 0;
//            last = watched;
//        end
//    end
//endmodule

//module lab04(
//    input [15:0] SW,
//    input CLK100MHZ,
//    output [7:0] HEX,
//    output [7:0] AN,
//    output [15:0] LED
//    );

//    reg isrunning = 0;
//    wire suspend;
//    assign suspend = SW[0];
           
//    wire reset;
//    assign reset = SW[1];
//    wire [7:0] inputTime;
//    assign inputTime = SW[15:8];
    
//    wire runninglight;
//    assign LED[1] = runninglight;
//    assign runninglight = isrunning;
    
//    wire clk_1HZ;
//    clkgen #(.freq(1)) clk_1(CLK100MHZ, 0, launched, clk_1HZ);

////    wire clk_1HZlight;
////    assign LED[5] = clk_1HZlight;
////    assign clk_1HZlight = clk_1HZ;
    
//    wire clk_10HZ;
//    clkgen #(.freq(10)) clk_10(CLK100MHZ, 0, launched, clk_10HZ);
    
//    wire clk_10KHZ;
//    clkgen #(.freq(10000)) clk_10000(CLK100MHZ, 0, launched, clk_10KHZ);
    
//    reg endlight;
////    assign LED[0] = endlight;
//    timeoutLEDtube #(.freq(10000), .timeout(1000))
//        endlightube(.en(endlight), .clk(clk_10KHZ), .light(clk_10HZ), .target(LED[0]));
    
//    wire beginbotton;
//    assign beginbotton = SW[2];
//    wire launchsignal;
//    fakeBottons fakeBotton(
//        .clk(clk_1HZ),
//        .watched(SW[2]),
//        .triggered(launchsignal)
//        );
//    reg launched = 0;

//    assign LED[4] = launchsignal;

//    reg [7:0] globalCountdown;
//    assign LED[15:8] = globalCountdown;
    
//    integer clock_timeout = 0;
//    reg [31:0] timeout = 0; 
//    always @(posedge clk_1HZ)
//    begin
////        endlight <= 0;
//        if(timeout >= clock_timeout)
//        begin
//            timeout <= 0;
//            endlight <= 0;
//            if (isrunning)
//            begin
//                if (globalCountdown >= 1)
//                    globalCountdown <= globalCountdown - 1;
//                else
//                begin
//                    isrunning <= 0;
//                    launched <= 0;
//                    endlight <= 1;
//                end
//            end
//        end
//        else
//            timeout <= timeout + 1;
//        if (suspend) 
//            isrunning <= 0;
//        else
//        begin
//            if (launched)
//                isrunning <= 1;
//        end
//        if (reset)
//            globalCountdown <= 0;
//        if (!launched && !suspend && launchsignal)
//        begin 
//            globalCountdown <= inputTime - 1;
//            launched <= 1;
//            isrunning <= 1;
//        end
//    end
    
//    wire [5:0] mainCounterOutput;
//    counter mainCounter(clk_1HZ, reset, isrunning, mainCounterOutput);

////    reg monitorManagerEnable, monitorManagerSelect, monitorManagerIs;
//    monitor monitorManager(clk_10KHZ, mainCounterOutput, 8'b00000011, AN[7:0], HEX[7:0]);

////    counter mainCounter(clk_1HZ, reset, isrunning, nowNum);
////    monitor monitorManager(CLK100MHZ, , )    

//endmodule

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
    input wire [7:0] nowNum,
    output wire [7:0] targeten,
    output wire [7:0] targetdisplay
);

    reg [7:0][7:0] display;

    ledmonitor mainMonitor(
        .clock(clock),
        .rst(rst),
        .en(8'b00000011),
        .display(display),
        .targeten(targeten),
        .targetdisplay(targetdisplay)
    );

    always @(nowNum) begin
        display[0] = seg7(nowNum % 10, 0);
        display[1] = seg7(nowNum / 10, 0);
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

module lab04(
    input wire clock_100MHZ,
    input wire [15:0] SW,
    output wire [15:0] LED,
    output wire [7:0] HEX,
    output wire [7:0] AN
);

    reg [31:0] systime;
    wire reset;
    assign reset = ~SW[1];

    wire clock_10KHZ;
    clockGenerator #(.freq(100000000)) generator10KHZ(
        .oclock(clock_100MHZ),
        .nclock(clock_10KHZ),
        .rst(reset)
    );

    wire clock_10HZ;
    clockGenerator #(.freq(100000000)) generator10HZ(
        .oclock(clock_100MHZ),
        .nclock(clock_10HZ),
        .rst(reset)
    );

    wire clock_1HZ;
    clockGenerator #(.freq(10000000)) generator1HZ(
        .oclock(clock_100MHZ),
        .nclock(clock_1HZ),
        .rst(reset)
    );
    

    wire toten;
    wire trystart;
    reg ended;
    wire parten;
    assign LED[0] = toten;
    assign parten = ~SW[0];
    assign trystart = SW[2];
    assign toten = parten & ((~ended) | trystart);

    reg endlighten;
    timeoutledTube #(.timeout(10000)) endlightube(
        .en(endlighten),
        .clock(clock_10KHZ),
        .signal(clock_10HZ),
        .rst(reset),
        .light(LED[1])
    );

    reg [7:0] count;
    
    assign LED[15:8] = count;
    reg [31:0] lastendlight;

    always @(posedge clock_1HZ, negedge reset) begin
        if (!reset)
            systime <= 0;
        else systime <= systime + 1;
    end

    always @(posedge clock_1HZ, negedge reset) begin
        if (!reset) begin
            count <= 0;
            ended <= 1;
        end
        else begin
            if (toten) begin
                if (count >= 59) begin
                    count <= 0;
                    ended <= 1;
                    endlighten <= 1;
                    lastendlight <= systime;
                end
                else begin
                    count <= count + 1;
                    ended <= 0;
                end
            end
            if (lastendlight != 0 && lastendlight < systime)
            begin
                lastendlight <= 0;
                endlighten <= 0;
            end
        end
    end

    ledmonitorControllerTimer monitorController(
        .nowNum(count),
        .rst(reset),
        .clock(clock_10KHZ),
        .targetdisplay(HEX),
        .targeten(AN)
    );

endmodule