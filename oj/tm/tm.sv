module tm(input  clk,
	input  [7:0] datain,
	input  reset,
	output reg [7:0] dataout,
	output reg move,
	output reg halt
        );
    reg [3:0] STATE;
    always @(posedge clk) begin
        if (reset == 1)
            halt <= 0;
        else begin
            if (datain == 8'b00101000) begin
                if (STATE == 4'h0) begin
                    dataout <= 8'h0;
                    move <= 1'b0;
                end
                if (STATE == 4'h1) begin
                    dataout <= 8'b00101000;
                    move <= 1'b0;
                end
                if (STATE == 4'h2) begin
                    dataout <= 8'b01000110;
                    move <= 1'b0;
                    halt <= 1'b1;
                end
                if (STATE == 4'h4) begin
                    dataout <= 8'b00101000;
                    move <= 1'b1;
                end
                if (STATE == 4'h7) begin
                    halt <= 1'b1;
                end
            end
            else if (datain == 8'b00101001) begin
                if (STATE == 4'h0) begin
                    dataout <= 8'b01000110;
                    move <= 1'b0;
                    halt <= 1'b1;
                end
                if (STATE == 4'h1) begin
                    dataout <= 8'b00101001;
                    move <= 1'b0;
                end
                if (STATE == 4'h2) begin
                    dataout <= 8'b00101001;
                    move <= 1'b0;
                end
                if (STATE == 4'h3) begin
                    dataout <= 8'h0;
                    move <= 1'b1;
                end
                if (STATE == 4'h4) begin
                    dataout <= 8'b00101001;
                    move <= 1'b1;
                end
                if (STATE == 4'h7) begin
                    halt <= 1'b1;
                end
            end
            else begin
                if (STATE == 4'h0) begin
                    dataout <= 8'b01010100;
                    move <= 1'b0;
                    halt <= 1'b1;
                end
                if (STATE == 4'h1) begin
                    dataout <= 8'b01000110;
                    move <= 1'b0;
                    halt <= 1'b1;
                end
                if (STATE == 4'h2) begin
                    dataout <= 8'h0;
                    move <= 1'b1;
                end
                if (STATE == 4'h4) begin
                    dataout <= 8'h0;
                    move <= 1'b0;
                end
                if (STATE == 4'h7) begin
                    halt <= 1'b1;
                end
            end
        end
    end
    always @(posedge clk) begin
        if (reset == 1)
            STATE <= 4'h0;
        else begin
            if (datain == 8'b00101000) begin
                if (STATE == 4'h0)
                    STATE <= 4'h1;
                if (STATE == 4'h1)
                    STATE <= 4'h1;
                if (STATE == 4'h2)
                    STATE <= 4'h7;
                if (STATE == 4'h4)
                    STATE <= 4'h4;
                if (STATE == 4'h7)
                    STATE <= 4'h7;
            end
            else if (datain == 8'b00101001) begin
                if (STATE == 4'h0)
                    STATE <= 4'h7;
                if (STATE == 4'h1)
                    STATE <= 4'h2;
                if (STATE == 4'h2)
                    STATE <= 4'h2;
                if (STATE == 4'h3)
                    STATE <= 4'h4;
                if (STATE == 4'h4)
                    STATE <= 4'h4;
                if (STATE == 4'h7)
                    STATE <= 4'h7;
            end
            else begin
                if (STATE == 4'h0)
                    STATE <= 4'h7;
                if (STATE == 4'h1)
                    STATE <= 4'h7;
                if (STATE == 4'h2)
                    STATE <= 4'h3;
                if (STATE == 4'h4)
                    STATE <= 4'h0;
                if (STATE == 4'h7) 
                    STATE <= 4'h7;
            end
        end
    end
endmodule

