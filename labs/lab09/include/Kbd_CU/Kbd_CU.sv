`ifndef module_Kbd_CU
`define module_Kbd_CU

`include "config/config.sv"
`include "keyboardCtr/keyboardCtr.sv"

module Kbd_CU(
    input   wire                clk,
    input   wire                rst,
    output  wire    [11:0]      m_addr,
    output  wire    [11:0]      m_data
);

    wire [7:0] nowCode;
    wire [7:0] nowAscii;

    always @(posedge clk, negedge rst) begin
        if (!rst) 
    end

endmodule

`endif
