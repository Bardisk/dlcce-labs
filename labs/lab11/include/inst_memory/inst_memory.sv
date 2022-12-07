`ifndef module_inst_memory
`define module_inst_memory

`include "config/config.sv"

module inst_memory (
    input  wire clk,
    input  wire [31:0] addr,
    output reg [31:0] instr
);
    parameter instr_size = 1000;
    reg [31:0] instr_mem [instr_size:0];
    initial 
    begin
        $readmemh("", instr_mem);
    end
    always @(negedge clk)
        instr <= instr_mem[addr];
endmodule

`endif
