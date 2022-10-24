`define SIM

`include "codeToAscii/codeToAscii.sv"
`include "ps2Keyboard/ps2Keyboard.sv"
`include "ledmonitor/ledmonitor.sv"
`include "clockGenerator/clockGenerator.sv"
`include "keyboardCtr/keyboardCtr.sv"
//add includes here

module lab07(
    input wire clock100MHZ,
    input wire [15:0] SW,
    input wire ps2_clk,
    input wire ps2_data,
    output wire [15:0] LED,
    output wire [7:0] AN,
    output wire [7:0] HEX
);

    wire reset = SW[0];

    wire clock10KHZ;
    clockGenerator clock10KHZ_Gen(
        .oclock(clock100MHZ),
        .rst(reset),
        .nclock(clock10KHZ)
    );

    wire [7:0] screenEn;
    wire [7:0][3:0] display;

    numScreen mainScreen(
        .clock(clock10KHZ),
        .rst(reset),
        .en(screenEn),
        .display(display),
        .dots(8'b0),
        .targeten(AN),
        .targetdisplay(HEX)
    );

    keyboardCtr mainController(
        .reset(reset),
        .display(display),
        .ps2_clk(ps2_clk),
        .en(screenEn),
        .ps2_data(ps2_data),
        .mainclk(clock100MHZ)
    );

endmodule
