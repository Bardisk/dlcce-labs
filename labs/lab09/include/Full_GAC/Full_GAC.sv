`ifndef module_Full_GAC
`define module_Full_GAC

`include "Vga_Ctr/Vga_Ctr.sv"
`include "config/config.sv"
`include "Memory/Memory.sv"

    // output  wire     [width-1:0]        valid_start_data,
    // output  wire     [width-1:0]        print_start_data,
    // output  wire     [width-1:0]        valid_end_data,
    // output  wire     [width-1:0]        print_end_data
//GAC and GDC may read the memory in the meantime
//GDC is always of higher priority
//So you should say to GAC that you're busy by gac_ready

`define WIDTH_BITS 6:0
`define HEIGHT_BITS 12:7
`define HEIGHT_WIDE 5:0

module Char_GRAM_Ctr(
    input   wire    [`VCHM_ADDR_WIDE]   gdc_read_addr,
    input   wire    [`VCHM_ADDR_WIDE]   gac_read_addr,
    input   wire    [`VCHM_ADDR_WIDE]   gac_write_addr,
    input   wire    [`VCHM_DATA_WIDE]   gac_data_in,
    input   wire                        clk,
    input   wire                        overall_en,
    input   wire                        gdc_ren,
    input   wire                        gac_wen,
    output  wire    [`VCHM_DATA_WIDE]   gdc_dataout,
    output  reg                         gac_ready,
    output  wire    [`VCHM_DATA_WIDE]   gac_dataout
);

    wire [`VCHM_ADDR_WIDE] read_addr;
    assign read_addr = gdc_ren ? gdc_read_addr : gac_read_addr;

    always @(posedge clk) begin
        if (gdc_ren)
            gac_ready <= 0;
        else gac_ready <= 1;
    end

    wire [`VCHM_DATA_WIDE] dataout;
    assign gac_dataout = gac_ready ? dataout : {`VCHM_ADDR_WIDTH{1'b0}};
    assign gdc_dataout = dataout;

    RAM #(
        .width(`VCHM_DATA_WIDTH),
        .addr_width(`VCHM_ADDR_WIDTH),
        .typ(`CHAR_VRAM)
    ) char_gram (
        .read_addr(read_addr),
        .write_addr(gac_write_addr),
        .datain(gac_data_in),
        .memclk(clk),
        .en(overall_en),
        .wen(gac_wen),
        .dataout(dataout)
    );

endmodule

//A conservative choice: only receive 8 bits a time, though.
//Actually we can read from the GRAM, But we dont need now.

module Graphics_Adapter_Char(
    //Given by bus of course
    input   wire                        clk,
    input   wire                        rst,
    //To interact with the MMU
    input   wire                        wen,
    input   wire    [`BYTE_WIDE]        datain,
    output  reg                         ready,
    //To tell the GDC
    output  reg     [`HEIGHT_WIDE]      print_start_line,
    output  reg     [`HEIGHT_WIDE]      print_end_line,
    output  reg     [`VCHM_ADDR_WIDE]   cursor_loc,
    //To interact with GRAM
    output  reg     [`VCHM_ADDR_WIDE]   gac_read_addr,
    input   wire    [`VCHM_DATA_WIDE]   gac_response,
    input   wire                        gac_ready,
    output  reg     [`VCHM_ADDR_WIDE]   gac_write_addr,
    output  reg     [`VCHM_DATA_WIDE]   gac_write_data,
    output  reg                         gac_wen
);
    //stats
    `define READY 3'b000
    `define ESCAPE 3'b001
    `define WAITCSI 3'b010
    `define OPERATE 3'b010
    //substats
    `define NONE 3'b111
    `define BACK 3'b000 
    `define WRITE_INTO_NEWLINE 3'b001
    `define FORCE_INTO_NEWLINE 3'b010
    `define BACK_INTO_PRELINE 3'b011
    `define IN_LINE_START 3'b100

    reg fore_r, fore_g, fore_b;
    reg back_r, back_g, back_b;
    reg underline, stress;

    wire [`BYTE_WIDE] stylepack = {back_r, back_g, back_b, underline, fore_r, fore_g, fore_b, stress};

    reg [2:0] state;
    reg [2:0] substate;

    always @(*) begin
        if(!wen)
            ready = 0;
        else begin
            case (state) 
                `READY: ready = 1;
                `ESCAPE: ready = 1;
                `OPERATE: ready = 0;
                default: ready = 1;
            endcase
        end
    end

    reg [`HEIGHT_WIDE] valid_start_line;
    reg [`HEIGHT_WIDE] valid_end_line;

    reg [`HALF_WIDE] timeout;
    
    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            valid_start_line <= 0;
            print_start_line <= 0;
            valid_end_line <= 6'b111111;
            print_end_line <= `C_FIELD_HEIGHT - 1;
            timeout <= 0;
            state <= `READY;
            substate <= `NONE;
            fore_b <= 1;
            fore_g <= 1;
            fore_r <= 1;
            back_b <= 0;
            back_g <= 0;
            back_r <= 0;
            stress <= 0;
            underline <= 0;
            cursor_loc <= 0;
            gac_read_addr <= 0;
            gac_write_addr <= 0;
            gac_wen <= 0;
            gac_write_data <= 0;
        end
        else begin
            case (state) 
                `READY: begin
                    if (wen) begin
                        //a printable character
                        if (datain & `ASCII_PRINTABLE_MASK) begin
                            //wait for write to GRAM
                            state <= `OPERATE;
                            //write into this
                            gac_wen <= 1;
                            gac_write_addr <= cursor_loc;
                            gac_write_data <= {stylepack, datain};
                            //trigger a new line
                            if (cursor_loc[`WIDTH_BITS] == `C_FIELD_WIDTH - 1) begin
                                timeout <= 16'b1;
                                substate <= `WRITE_INTO_NEWLINE;
                                //自然溢出时要注意位宽！！
                                if (cursor_loc[`HEIGHT_BITS] == print_end_line) begin
                                    print_end_line <= print_end_line + 6'b1;
                                    print_start_line <= print_start_line + 6'b1;
                                end
                                if (cursor_loc[`HEIGHT_BITS] == valid_end_line) begin
                                    valid_end_line <= valid_end_line + 6'b1;
                                    valid_start_line <= valid_start_line + 6'b1;
                                end
                                //here is not compatible with changes
                                cursor_loc <= cursor_loc + 13'b0000000111011;
                            end
                            else begin 
                                timeout <= 16'b0;
                                cursor_loc <= cursor_loc + 1;
                            end
                        end
                        else begin
                            case (datain)
                                `ASCII_BACK: begin
                                    if (!cursor_loc[`WIDTH_BITS]) begin
                                        //ignore otherwise
                                        if (cursor_loc[`HEIGHT_BITS] != valid_start_line) begin
                                            state <= `OPERATE;
                                            substate <= `IN_LINE_START;
                                            //read lf
                                            gac_read_addr <= (cursor_loc - 13'b0000000111011) | 13'b0000001111111;
                                            if (cursor_loc[`HEIGHT_BITS] == print_start_line) begin
                                                print_end_line <= print_end_line - 6'b1;
                                                print_start_line <= print_start_line - 6'b1;
                                            end
                                            cursor_loc <= cursor_loc - 13'b0000000111011;
                                        end
                                    end
                                    //normal back
                                    else begin
                                        state <= `OPERATE;
                                        cursor_loc <= cursor_loc - 1;
                                        gac_wen <= 1;
                                        gac_write_addr <= cursor_loc - 1;
                                        gac_write_data <= {stylepack, `BYTE_ZERO};
                                        timeout <= 16'b0;
                                    end
                                end
                                `ASCII_LF: begin
                                    timeout <= 16'b1;
                                    state <= `OPERATE;
                                    substate <= `FORCE_INTO_NEWLINE;
                                    gac_wen <= 0;
                                    if (cursor_loc[`HEIGHT_BITS] == print_end_line) begin
                                        print_end_line <= print_end_line + 1;
                                        print_start_line <= print_start_line + 1;
                                    end
                                    if (cursor_loc[`HEIGHT_BITS] == valid_end_line) begin
                                        valid_end_line <= valid_end_line + 1;
                                        valid_start_line <= valid_start_line + 1;
                                    end
                                    //here is not compatible with changes
                                    cursor_loc <= cursor_loc + 13'b0000000111011;
                                end
                                default: begin end
                            endcase
                        end
                    end
                end
                `OPERATE: begin
                    if (timeout) begin
                        case (substate)
                            `BACK: begin
                                //a clock is enough for write
                                gac_wen <= 1;
                                gac_write_addr <= cursor_loc;
                                gac_write_data <= {stylepack, `BYTE_ZERO};
                                timeout <= 0;
                            end
                            `WRITE_INTO_NEWLINE: begin
                                gac_wen <= 1;
                                gac_write_addr <= cursor_loc | 13'b0000001111111;
                                gac_write_data <= 0;
                                timeout <= 0;
                            end
                            `FORCE_INTO_NEWLINE: begin
                                gac_wen <= 1;
                                gac_write_addr <= cursor_loc | 13'b0000001111111;
                                gac_write_data <= 1;
                                timeout <= 0;
                            end
                            `IN_LINE_START: begin
                                //wait for response
                                if (gac_ready) begin
                                    //with a lf, check the empty chars
                                    if (gac_response) begin
                                        substate <= `BACK_INTO_PRELINE;
                                        timeout <= 16'b1;
                                        gac_read_addr <= cursor_loc;
                                    end
                                    //without lf, back a word
                                    else begin
                                        substate <= `BACK;
                                        timeout <= 16'b1;
                                    end
                                end
                                
                            end
                            `BACK_INTO_PRELINE: begin
                                if (gac_ready) begin
                                    //non-empty
                                    if (gac_response[`BYTE_WIDE]) begin
                                        //wipe lf
                                        gac_wen <= 1;
                                        gac_write_addr <= cursor_loc | 13'b0000001111111;
                                        gac_write_data <= 0;
                                        timeout <= 0;
                                    end
                                    else begin
                                        if (!cursor_loc[`WIDTH_BITS]) begin
                                            //wipe lf
                                            gac_wen <= 1;
                                            gac_write_addr <= cursor_loc | 13'b0000001111111;
                                            gac_write_data <= 0;
                                            timeout <= 0;
                                        end
                                        else begin
                                            timeout <= 16'b1;
                                            cursor_loc <= cursor_loc - 1;
                                            gac_read_addr <= cursor_loc - 1;
                                        end
                                    end
                                end
                            end
                            default: begin
                                timeout <= timeout - 1;
                            end
                        endcase
                    end
                    else begin 
                        state <= `READY;
                        timeout <= 0;
                        substate <= `NONE;
                        gac_wen <= 0;
                    end
                end
            endcase
        end
    end


endmodule

module Graphics_Decoder_Char(
    input   wire                            clk,
    input   wire                            fclk,
    input   wire                            sclk,
    input   wire                            rst,
    input   wire                            valid,
    input   wire    [9:0]                   h_addr,
    input   wire    [9:0]                   v_addr,
    input   wire    [`HEIGHT_WIDE]          print_start_line,
    input   wire    [`VCHM_ADDR_WIDE]       cur_addr,
    input   wire    [`VCHM_DATA_WIDE]       response,
    output  wire    [`VCHM_ADDR_WIDE]       req_addr,
    output  wire                            req_en,
    output  wire    [3:0]                   vga_r,
    output  wire    [3:0]                   vga_g,
    output  wire    [3:0]                   vga_b
);

    parameter block_width = 9;
    parameter block_height = 16;
    parameter field_width = `C_FIELD_WIDTH;
    parameter field_height = `C_FIELD_HEIGHT;
    parameter screen_width = `S_WIDTH;
    parameter screen_height = `S_HEIGHT;

    reg [3:0] offsetw;
    reg [3:0] offseth;
    reg [`WIDTH_BITS] hb_addr;
    reg [`HEIGHT_WIDE] vb_addr;
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

    wire [11:0] out;
    wire [11:0] rom_addr;
    

    ROM char_rom(
        .memclk(fclk),
        .read_addr(rom_addr),
        .en(1'b1),
        .dataout(out)
    );

    reg [11:0] vga_data;
    wire [11:0] bgcolor = {{4{response[15]}}, {4{response[14]}}, {4{response[13]}}};
    wire [11:0] frcolor = {{4{response[11]}}, {4{response[10]}}, {4{response[9]}}};

    assign req_addr = (hb_addr < field_width && vb_addr < field_height) ? {(vb_addr + print_start_line), hb_addr} : 12'b0;

    assign req_en = (hb_addr < field_width && vb_addr < field_height);

    assign rom_addr = (hb_addr < field_width && vb_addr < field_height) ? {response[`BYTE_WIDE], offseth} : 12'b0;

    assign rom_en = (hb_addr < field_width && vb_addr < field_height);

    always @(*) begin
        if (hb_addr < field_width && vb_addr < field_height) begin
            if (req_addr == cur_addr && offseth == 14 && sclk)
                vga_data = 12'heee;
            else vga_data = out[offsetw] ? frcolor : bgcolor;
        end
        else vga_data = 12'b0;
    end

    assign {vga_r, vga_g, vga_b} = vga_data;

endmodule

module Full_GAC(
    input   wire                    clk,
    input   wire                    vclk,
    input   wire                    sclk,
    input   wire                    rst,
    input   wire                    wen,
    input   wire    [`BYTE_WIDE]    datain,
    output  wire                    ready,
    output  wire    [3:0]           vga_r,
    output  wire    [3:0]           vga_g,
    output  wire    [3:0]           vga_b,
    output  wire                    hsync,
    output  wire                    vsync
);

    wire [`VCHM_ADDR_WIDE] gdc_read_addr;
    wire [`VCHM_ADDR_WIDE] gac_read_addr;
    wire [`VCHM_ADDR_WIDE] gac_write_addr;
    wire [`VCHM_DATA_WIDE] gac_data_in;
    wire [`VCHM_DATA_WIDE] gdc_dataout;
    wire [`VCHM_DATA_WIDE] gac_dataout;
    wire gdc_ren, gac_wen, gac_ready;
    Char_GRAM_Ctr gram_ctr(
        .gdc_read_addr(gdc_read_addr),
        .gac_read_addr(gac_read_addr),
        .gac_write_addr(gac_write_addr),
        .gac_data_in(gac_data_in),
        .clk(clk),
        .overall_en(1'b1),
        .gdc_ren(gdc_ren),
        .gac_wen(gac_wen),
        .gdc_dataout(gdc_dataout),
        .gac_ready(gac_ready),
        .gac_dataout(gac_dataout)
    );

    wire [`HEIGHT_WIDE] print_start_line;
    wire [`VCHM_ADDR_WIDE] cur_addr;

    Graphics_Adapter_Char gac(
        .clk(clk),
        .rst(rst),
        .wen(wen),
        .datain(datain),
        .ready(ready),
        .print_start_line(print_start_line),
        .cursor_loc(cur_addr),
        .gac_read_addr(gac_read_addr),
        .gac_response(gac_dataout),
        .gac_ready(gac_ready),
        .gac_write_addr(gac_write_addr),
        .gac_write_data(gac_data_in),
        .gac_wen(gac_wen)
    );

    wire valid;
    wire [9:0] h_addr;
    wire [9:0] v_addr;

    Graphics_Decoder_Char gdc(
        .clk(vclk),
        .fclk(clk),
        .sclk(sclk),
        .rst(rst),
        .valid(valid),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .print_start_line(print_start_line),
        .cur_addr(cur_addr),
        .response(gdc_dataout),
        .req_addr(gdc_read_addr),
        .req_en(gdc_ren),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

    Vga_Ctr vga_ctr(
        .clk(vclk),
        .rst(rst),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid)
    );

endmodule

`endif
