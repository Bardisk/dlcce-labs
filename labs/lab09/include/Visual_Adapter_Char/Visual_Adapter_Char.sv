`ifndef module_Visual_Adapter_Char
`define module_Visual_Adapter_Char

`include "Memory/Memory.sv"
`include "config/config.sv"

module Visual_Adapter_Char(
    input   wire                clk,
    input   wire                fclk,
    input   wire                rst,
    input   wire                valid,
    input   wire    [9:0]       h_addr,
    input   wire    [9:0]       v_addr,
    input   wire    [7:0]       response,
    output  wire    [11:0]      req_addr,
    output  wire                req_en,
    output  wire    [3:0]       vga_r,
    output  wire    [3:0]       vga_g,
    output  wire    [3:0]       vga_b
);

    parameter block_width = 9;
    parameter block_height = 16;
    parameter field_width = `C_FIELD_WIDTH;
    parameter field_height = `C_FIELD_HEIGHT;
    parameter screen_width = `S_WIDTH;
    parameter screen_height = `S_HEIGHT;

    reg [3:0] offsetw, offseth;
    reg [6:0] hb_addr;
    reg [4:0] vb_addr;
    always @(posedge clk, negedge rst)
        if (!rst) offsetw <= 0;
        else if(valid) begin
            if (offsetw == block_width - 1 || h_addr == screen_width - 1)
                offsetw <= 0;
            else offsetw <= offsetw + 1;
        end
    
    always @(posedge clk, negedge rst)
        if (!rst) offseth <= 0;
        else if(valid) begin
            if (h_addr == screen_width - 1) begin
                if (offseth == block_height - 1 || v_addr == screen_height - 1)
                    offseth <= 0;
                else offseth <= offseth + 1;
            end 
        end

    always @(posedge clk, negedge rst)
        if (!rst) hb_addr <= 0;
        else if(valid) begin
            if (h_addr == screen_width - 1)
                hb_addr <= 0;
            else if (offsetw == block_width - 1)
                hb_addr <= hb_addr + 1;
        end

    always @(posedge clk, negedge rst)
        if (!rst) vb_addr <= 0;
        else if(valid) begin
            if (h_addr == screen_width - 1) begin
                if (v_addr == screen_height - 1)
                    vb_addr <= 0;
                else if (offseth == block_height - 1)
                    vb_addr <= vb_addr + 1;
            end 
        end

    wire [11:0] out, rom_addr;
    

    ROM char_rom(
        .memclk(fclk),
        .read_addr(rom_addr),
        .en(1'b1),
        .dataout(out)
    );

    wire [11:0] vga_data;
    
    assign req_addr = (hb_addr < field_width && vb_addr < field_height) ? {vb_addr, hb_addr} : 12'b0;

    assign req_en = (hb_addr < field_width && vb_addr < field_height);

    assign rom_addr = (hb_addr < field_width && vb_addr < field_height) ? {response, offseth} : 12'b0;

    assign rom_en = (hb_addr < field_width && vb_addr < field_height);

    assign vga_data = (hb_addr < field_width && vb_addr < field_height) ? (out[offsetw] ? 12'heee : 0) : 12'b0;

    assign {vga_r, vga_g, vga_b} = vga_data;

endmodule

`endif
