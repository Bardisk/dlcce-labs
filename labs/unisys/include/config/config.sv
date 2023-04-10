`ifndef module_config
`define module_config

`include "config/memory_config.sv"
`include "config/screen_config.sv"

//General
`define WORD_WIDTH (32)
`define WORD_WIDE `WORD_WIDTH-1:0
`define BYTE_WIDE 7:0
`define HALF_WIDE 15:0
`define WORD_ZERO {`WORD_WIDTH{1'b0}}
`define HALF_ZERO {(`WORD_WIDTH/2){1'b0}}
`define BYTE_ZERO (8'b0)

`endif
