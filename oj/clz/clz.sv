module clz(
 input [31:0] in,
 output [4:0] out,
 output zero
);

assign out[4]=~|(in & ((32'hFFFF0000) >> ({1'b0,   1'b0,   1'b0,   1'b0,   1'b0})));
assign out[3]=~|(in & ((32'hFF000000) >> ({out[4], 1'b0,   1'b0,   1'b0,   1'b0})));
assign out[2]=~|(in & ((32'hF0000000) >> ({out[4], out[3], 1'b0,   1'b0,   1'b0})));
assign out[1]=~|(in & ((32'hC0000000) >> ({out[4], out[3], out[2], 1'b0,   1'b0})));
assign out[0]=~|(in & ((32'h80000000) >> ({out[4], out[3], out[2], out[1], 1'b0})));
assign zero = ~|in;

endmodule
