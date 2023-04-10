`ifndef module_regheap
`define module_regheap

`include "config/config.sv"

module regheap (
    input  wire WrClk,
    input  wire [4:0] Ra,
    input  wire [4:0] Rb,
    input  wire [4:0] Rw,
    input  wire        RegWr,
    input  wire [31:0] busW,
    output wire [31:0] busA,
    output wire [31:0] busB
);
    integer i;

    reg [31:0] regs [31:0];
    initial begin    
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 0;
    end
    assign busA = regs[Ra];
    assign busB = regs[Rb];
    always @(negedge WrClk) 
    begin
        if(RegWr && Rw)
            regs[Rw] <= busW;
    end
    
endmodule

`endif
