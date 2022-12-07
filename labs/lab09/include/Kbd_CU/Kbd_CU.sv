`ifndef module_Kbd_CU
`define module_Kbd_CU

`include "config/config.sv"
`include "keyboardCtr/keyboardCtr.sv"

module Kbd_CU(
    input   wire                    clk,
    input   wire                    rst,
    input   wire                    ps2_clk,
    input   wire                    ps2_data,
    input   wire                    wen,
    output  wire                    ready,
    output  wire    [`HALF_WIDE]    mdata
);

    keyboardCtr keyboard_ctr(
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .mainclk(clk),
        .reset(rst),
        .en(wen),
        .res_ready(ready),
        .resAscii(mdata[15:8]),
        .resCode(mdata[7:0])
    );

endmodule

`endif
