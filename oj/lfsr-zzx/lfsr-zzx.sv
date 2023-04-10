module shiftreg8(
    input wire [7:0] pardata,
    input wire ld,
    input wire datin,
    input wire rst,
    input wire clk,
    output wire [7:0] outnum
);

    reg [7:0] regfile;
    always @(posedge clk, negedge rst) begin
        if (!rst)
            regfile <= 0;
        else if(ld) regfile <= pardata;
        else regfile <= (regfile[6:0] << 1) | datin;
    end

    assign outnum = regfile;

endmodule

module lfsrzzx(
    input wire [7:0] seed,
    input wire rst,
    input wire clk,
    output wire [7:0] ledoutput
);

    shiftreg8 shiftreg(
        .clk(clk),
        .rst(1'b1),
        .ld(~rst),
        .pardata(seed),
        .outnum(ledoutput),
        .datin(ledoutput[7] ^ ledoutput[5] ^ ledoutput[4] ^ ledoutput[3])
    );

endmodule
