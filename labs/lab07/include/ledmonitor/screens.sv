`ifndef module_screens
`define module_screens

`include "ledmonitor/seg7.sv"
`include "ledmonitor/ledmonitor.sv"

module numScreen(
    input wire clock,
    input wire rst,
    input wire [7:0] en,
    input wire [7:0][3:0] display,
    input wire [7:0] dots,
    output wire [7:0] targeten,
    output wire [7:0] targetdisplay
);
    wire [7:0][7:0] monitorDisplay;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1)
            begin: seggroups
            seg7 myseg7(
                .N(display[i]), 
                .dot(dots[i]),
                .target(monitorDisplay[i])
            );
        end
    endgenerate

    ledmonitor mainmonitor(
        .clock(clock),
        .en(en),
        .rst(rst),
        .display(monitorDisplay),
        .targeten(targeten),
        .targetdisplay(targetdisplay)
    );

endmodule

`endif 