module dfa(
    input   wire            clk,
	input   wire    [7:0]   data,
	input   wire            reset,
	output  reg             result
	);

    reg [31:0] ns, length;    

    always @(posedge clk) begin
        if (reset) begin
            result <= 0;
            ns <= 0;
            length <= 0;
        end
        else if (data == 8'h0) begin
            result <= (length[0] && ns[0]);
            ns <= 0; length <= 0;
        end
        else begin
            length <= length + 1;
            if (data == 8'h4E || data == 8'h6E)
                ns <= ns + 1;
        end
    end
//add your code here
endmodule