`ifndef module_keyboardCtr
`define module_keyboardCtr

`include "keyboardCtr/codeToAscii.sv"
`include "keyboardCtr/ps2Keyboard.sv"

`define CTRL_SC (7'h14)
`define RIGHT_SHIFT_SC (7'h59)
`define LEFT_SHIFT_SC (7'h12)
`define CAPS_SC (7'h58)

module keyboardCtr(
    input wire ps2_clk,
    input wire ps2_data,
    input wire mainclk,
    input wire reset,
    output reg capsLight,
    output wire ctrlLight,
    output wire shiftLight,
    output wire ready,
    output wire overflow,
    output reg [7:0] en,
    output wire [7:0][3:0] display
);

    wire [7:0] data;

    reg [7:0] counter = 0;
    assign display[7:6] = counter;

    reg [7:0] nowCode;
    wire [7:0] nowAscii;
    codeToAscii transvertor({shiftLight ^ (capsLight & ~ctrlLight), ctrlLight, nowCode}, nowAscii);

    assign display[3:2] = nowCode;
    assign display[1:0] = nowAscii;
    ps2Keyboard coreController(
        .clk(mainclk),
        .clrn(reset),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .nextdata_n(1'b0),
        .data(data),
        .ready(ready),
        .overflow(overflow)
    );

    reg relkey = 0;
    
    reg [255:0] ispressed = 128'b0; 
    
    assign ctrlLight = ispressed[`CTRL_SC];
    assign shiftLight = ispressed[`LEFT_SHIFT_SC] | ispressed[`RIGHT_SHIFT_SC];

    always @(posedge mainclk, negedge reset) begin
        if (!reset) begin
            nowCode <= 0;
        end
        else if (ready)
            nowCode <= data;
    end
    
    wire extkey = (nowCode == 8'hE0);
    
    reg lastCaps;

    always @(posedge mainclk, negedge reset) begin
        if (!reset)
            lastCaps <= 0;
        else if (ready && data == `CAPS_SC) begin
            if (!relkey && !ispressed[`CAPS_SC]) //newly pressed
                lastCaps <= capsLight;
        end
    end

    always @(posedge mainclk, negedge reset) begin
        if (!reset) begin
            ispressed <= 128'b0;
            capsLight <= 0;
            counter <= 0;
        end
        else if (ready && data != 8'hE0 && data != 8'hF0) begin
            if (relkey) begin
                if (ispressed[data[6:0]]) begin
                    ispressed[data[6:0]] <= 0;
                    if (data == `CAPS_SC && lastCaps)
                        capsLight <= 0;
                end
                
            end
            else begin
                if (!ispressed[data[6:0]]) begin //newly pressed
                    ispressed[data[6:0]] <= 1;
                    if (data == `CAPS_SC)
                        capsLight <= 1;
                    counter <= counter + 1;
                end
                
            end
        end
    end

    always @(posedge mainclk, negedge reset) begin
        if (!reset)
            relkey <= 0;
        else if (ready && data != 8'hE0)
            relkey <= (data == 8'hF0);
    end

    always @(posedge mainclk, negedge reset) begin
        if (!reset)
            en <= 8'b0;
        else begin
            if (nowCode != 8'hE0 && nowCode != 8'hF0 && ispressed[nowCode[6:0]])
                en <= 8'b11001111;
            else en <= 8'b11000000;
        end
    end

endmodule

`endif
