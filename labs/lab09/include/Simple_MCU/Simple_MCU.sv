`ifndef module_Simple_MCU
`define module_Simple_MCU

`include "config/config.sv"

`define WAIT_KBD (2'b01)
`define WAIT_CHM (2'b11)
`define UNDEF (2'b00)

module Simple_MCU(
    input   wire                    clk,
    input   wire                    rst,
    input   wire    [`WORD_WIDE]    r_data,
    output  reg     [`WORD_WIDE]    w_data,
    output  reg                     w_enable,
    output  reg                     r_enable,
    output  wire    [2:0]           r_mode,
    output  wire    [2:0]           w_mode,
    input   wire                    w_ready,
    input   wire                    r_ready,
    output  reg     [`WORD_WIDE]    r_addr,
    output  reg     [`WORD_WIDE]    w_addr
);

    reg stalled;

    //the only thing to do is
    //1. receive the keyboard code
    //2. write it to the gmem

    reg [1:0] state;

    reg r_timeout, w_timeout;

    always @(*) begin
        case (state)
            `WAIT_KBD: begin
                r_enable = ~r_ready;
                w_enable = 0;
                r_addr = `KBD_ADDR;
            end
            `WAIT_CHM: begin
                r_enable = 0;
                w_enable = ~w_ready;
                w_addr = `VGA_ADDR;
            end
        endcase
    end

    always @(posedge clk, negedge rst) begin
        if (!rst) state <= `WAIT_KBD;
        else begin
            case (state)
                `WAIT_KBD: begin
                    if (r_ready) begin
                        w_data <= r_data;
                        state <= `WAIT_CHM;
                    end
                end
                `WAIT_CHM: begin
                    if (w_ready)
                        state <= `WAIT_KBD;
                end
                default: begin end
            endcase
        end
    end

endmodule

`endif
