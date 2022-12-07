`ifndef module_config
`define module_config

`define WORD_WIDTH (32)
`define WORD_WIDE `WORD_WIDTH-1:0
`define BYTE_WIDE 7:0
`define HALF_WIDE 15:0
`define WORD_ZERO {`WORD_WIDTH{1'b0}}
`define HALF_ZERO {(`WORD_WIDTH/2){1'b0}}
`define BYTE_ZERO (8'b0)

//Device mmio settings
`define DEVICE (32'ha0000000)
`define DEV_MASK (32'h3ff00)
`define KBD_ADDR (`DEVICE | 32'h00000060)
`define VGA_ADDR (`DEVICE | 32'h00000100)
`define SD_ADDR (`DEVICE | 32'h00000300)
`define VGA_G_ADDR (`DEVICE | 32'h00000900)
`define KBD_MARK (32'h00000)
`define VGA_MARK (32'h00100)
`define SD_MARK (32'h00300)
`define VGA_G_MARK (32'h00900)

//cache settings
//text cache of 256B in 64 registers
//data cache of 16KB in DTRAM
//text block as 32B, 8 lines
//data block as 32B, 128 lines
`define TEXT_CACHE_SZ (32'h00000100)
`define TEXT_BLOCK_SZ (32'h00000020)
`define DATA_CACHE_SZ (32'h00004000)
`define DATA_BLOCK_SZ (32'h00000020)

//memory settings
//text memory of 16KB in DTRAM
//data memory of 256KB in BRAM
//visual char memory of 16KB in DTRAM
//visual graphics memory of 84000B in BRAM
`define TEXT_SIZE (32'h00004000)
`define DATA_SIZE (32'h00040000)
`define VCHM_SIZE (32'h00001000)
`define VGPM_SIZE (32'h00014820)
`define TEXT_ADDR_WIDTH (14)
`define DATA_ADDR_WIDTH (18)
`define VCHM_ADDR_WIDTH (13)
`define VCHM_DATA_WIDTH (16)
`define VGPM_ADDR_WIDTH (17)
`define VGPM_DATA_WIDTH (12)
`define TEXT_ADDR_WIDE `TEXT_ADDR_WIDTH-1:0
`define DATA_ADDR_WIDE `DATA_ADDR_WIDTH-1:0
`define VCHM_ADDR_WIDE `VCHM_ADDR_WIDTH-1:0
`define VCHM_DATA_WIDE `VCHM_DATA_WIDTH-1:0
`define VGPM_ADDR_WIDE `VGPM_ADDR_WIDTH-1:0
`define VGPM_DATA_WIDE `VGPM_DATA_WIDTH-1:0
`define SEGMENT_MASK (32'hfffc0000)
`define TEXT_MASK (32'h3c000)
`define VCHM_MASK (32'h3e000)
`define VGPM_MASK (32'h20000)
`define DATA_SEGMENT (32'h00040000)
`define TEXT_SEGMENT (32'h00000000)
`define DEVI_SEGMENT (32'ha0000000)
`define VCHM_SEGMENT (32'ha1000000)
`define VGPM_SEGMENT (32'ha0100000)

`define BYTE_MODE (2'b00)
`define HALF_MODE (2'b01)
`define WORD_MODE (2'b10)
`define LONG_MODE (2'b11)
`define USIG_MODE (3'b100)
`define SIGN_MODE (3'b000)

//vga_controller settings
`define RES_640_480
`ifdef RES_640_480
    `define H_FRONTPROCH (96)
    `define H_ACTIVE (144)
    `define H_BACKPORCH (784)
    `define H_TOTAL (800)
    `define V_FRONTPROCH (2)
    `define V_ACTIVE (35)
    `define V_BACKPORCH (515)
    `define V_TOTAL (525)
    `define S_WIDTH (640)
    `define S_HEIGHT (480)
    `define C_FIELD_WIDTH (70)
    `define C_FIELD_HEIGHT (29)
`endif

//exception encodings
`define EXCEPT_RD_INVALID (5'b00010)
`define EXCEPT_WR_INVALID (5'b00011)
`define EXCEPT_UNDEFINED (5'b11111)

`define ASCII_PRINTABLE_MASK (8'he0)
`define ASCII_ESC (8'h1b)
`define ASCII_BACK (8'h08)
`define ASCII_LF (8'h0a)

`define REG_NUM_WIDTH (5)
`define REG_NUM_WIDE `REG_NUM_WIDTH-1:0

`endif
