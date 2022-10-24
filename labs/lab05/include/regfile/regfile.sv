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

    always @(posedge clock, negedge reset) begin
        if (!reset) begin
            file = '{default:0};
        end
        else if (writeEn) begin
            file[writeSel] <= indata;
        end
    end
    assign outdata = file[readSel];
    

endmodule

`endif
