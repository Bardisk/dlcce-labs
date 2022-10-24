`ifndef module_ledmonitor
`define module_ledmonitor

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

`endif
