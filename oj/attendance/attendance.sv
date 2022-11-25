module attendance(
	input [127:0] name,
	input clk,
	input rst,
	input [1:0] cmd,
	output reg [127:0] dataout
);

    always @(posedge clk) begin
        if (rst) dataout <= 0;
        else if(cmd) dataout <= dataout ^ name;
    end

endmodule
