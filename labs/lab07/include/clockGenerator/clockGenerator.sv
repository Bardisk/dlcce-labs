`ifndef module_clockGenerator
`define module_clockGenerator

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

`endif
