`ifndef module_keyboardCtr
`define module_keyboardCtr

`include "codeToAscii/codeToAscii.sv"
`include "ps2Keyboard/ps2Keyboard.sv"

module keyboardCtr(
    input wire ps2_clk,
    input wire ps2_data,
    input wire mainclk,
    input wire reset,
    output reg ctrlLight,
    output reg shiftLight,
    output reg [7:0] en,
    output wire [7:0][3:0] display
);

    reg nextdata_n;
    wire ready, overflow;
    wire [7:0] data;

    reg [7:0] counter;
    assign display[7:6] = counter;

    reg [7:0] nowCode, lastCode;
    wire [7:0] nowAscii;
    codeToAscii transvertor({ctrlLight, shiftLight, nowCode}, nowAscii);

    assign display[3:2] = nowCode;
    assign display[1:0] = nowAscii;

    ps2Keyboard coreController(
        .clk(mainclk),
        .clrn(reset),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .nextdata_n(nextdata_n),
        .data(data),
        .ready(ready),
        .overflow(overflow)
    );

    
    always @(posedge mainclk, negedge reset) begin
        if (!reset) begin
            en <= 8'b11000000;
            nowCode <= 0;
            counter <= 0;
        end
        else begin
            if (ready) begin
                en <= 8'b11001111;
                lastCode <= nowCode;
                if (nowCode != 8'hF0)
                    nowCode <= data;
                else if (lastCode != nowCode)
                    counter <= counter + 1;
                nextdata_n <= 0;
            end
            else begin
                nextdata_n <= 1;
                en <= 8'b11000000;
            end
        end
    end

endmodule

`endif
