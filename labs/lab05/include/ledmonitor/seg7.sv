`ifndef module_seg7
`define module_seg7

module seg7(
    input wire [3:0] N,
    input wire dot,
    output wire [7:0] target
);
    reg [6:0] body;

    always @(N, dot) begin
        casex (N)
            4'hf: body = 7'b0000111;
            4'he: body = 7'b0000011;
            4'hd: body = 7'b1000001;
            4'hc: body = 7'b1000110;
            4'hb: body = 7'b0000011;
            4'ha: body = 7'b0001000;
            4'h9: body = 7'b0010000;
            4'h8: body = 7'b0000000;
            4'h7: body = 7'b1111000;
            4'h6: body = 7'b0000010;
            4'h5: body = 7'b0010010;
            4'h4: body = 7'b0011001;
            4'h3: body = 7'b0110000;
            4'h2: body = 7'b0100100;
            4'h1: body = 7'b1111001;
            4'h0: body = 7'b1000000;
            default: body = 7'b1111111;
        endcase
    end

    assign target = {~dot, body};
endmodule

`endif