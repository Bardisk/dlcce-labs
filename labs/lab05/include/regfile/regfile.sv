`ifndef module_regfile
`define module_regfile

module regfile
#(parameter size = 16, width = 8) (
    input wire clock,
    input wire reset,
    input wire readSel,
    input wire writeSel,
    input wire writeEn,
    input wire [width-1:0] indata,
    output wire [width-1:0] outdata
);

    reg [width-1:0] file [size-1:0];
    integer i;

    initial begin
        for (i = 0; i < size; i++)
            file[i] <= 0;
    end

    always @(posedge clock, negedge reset) begin
        if (!reset) begin
            for (i = 0; i < size; i++)
                file[i] <= 0;
        end
        else if (writeEn) begin
            file[writeSel] <= 0;
        end
    end

    assign outdata = file[readSel];

endmodule

`endif
