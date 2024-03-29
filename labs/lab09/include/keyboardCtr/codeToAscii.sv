`ifndef module_codeToAscii
`define module_codeToAscii

module codeToAscii(addr, out);
    input [9:0] addr;
    output [7:0] out;
    reg [7:0] lut [0:95][0:3];
    initial
    begin
        $readmemh("C:/Users/Bardi/Work/Hardware/Shadow/memories/meml.memory", lut);
    end
    assign out = lut[addr[7:0]][addr[9:8]];
endmodule

`endif
