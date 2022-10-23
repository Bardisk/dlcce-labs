`ifndef module_timeoutledTube
`define module_timeoutledTube

`include "ledTubes/ledTube.sv"

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

`endif
