`ifndef module_Bus
`define module_Bus

`include "config/config.sv"
`include "CPU/CPU.sv"

module Bus(
    input   wire                    clk,
    input   wire                    rst
);

    wire [`WORD_WIDE] inst_read_addr, inst_read_data, data_read_addr, data_write_addr, data_read_data, data_write_data;

    wire inst_read_en, data_read_en, data_write_en;
    wire [2:0] data_mode;

    CPU cpu(
        .clk(clk),
        .rst(rst),
        .inst_read_addr(inst_read_addr),
        .inst_read_data(inst_read_data),
        .inst_read_en(inst_read_en),
        .data_read_addr(data_read_addr),
        .data_read_data(data_read_data),
        .data_write_addr(data_write_addr),
        .data_write_data(data_write_data),
        .data_read_en(data_read_en),
        .data_write_en(data_write_en),
        .data_mode(data_mode)
    );

    data_memory DM(
        .addr(data_write_en ? data_write_addr : data_read_addr),
        .rdclk(clk),
        .wrclk(~clk),
        .memop(data_mode),
        .we(data_write_en),
        .datain(data_write_data),
        .dataout(data_read_data)
    );

    inst_memory IM(
        .clk(clk),
        .addr(inst_read_addr),
        .instr(inst_read_data)
    );

endmodule

`endif
