module encryption(
    input   wire    [63:0]  seed,
    input   wire            clk,
    input   wire            load,
    input   wire    [7:0]   datain,
    output  reg             ready,
    output  reg    [7:0]   dataout
);

    reg [2:0] count;

    reg [63:0] randreg;
    always @(posedge clk) begin
        if (load) begin
            randreg <= seed;
        end
        else begin
            randreg <= {randreg[1] ^ randreg[0] ^ randreg[4] ^ randreg[3], randreg[63:1]};
        end
    end

    always @(posedge clk) begin
        if (load) begin
            count <= 0;
        end
        else begin
            if (count < 5)
                count <= count + 1;
            else
                count <= 0;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            ready <= 0;
        end
        else if (count < 5) begin
            ready <= 0;
        end
        else ready <= 1;
    end

    always @(posedge clk) begin
        if (count < 5) begin
            dataout <= 0;
        end
        else dataout <= datain ^ {2'b00, randreg[1] ^ randreg[0] ^ randreg[4] ^ randreg[3], randreg[63:59]};
    end

endmodule
