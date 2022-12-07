`ifndef module_Simple_MMU
`define module_Simple_MMU

`include "config/config.sv"

//4 slices of RAM of size 64KB
module Simple_MMU(
    //interact with cpu
    input   wire    [`WORD_WIDE]            r_addr,
    input   wire    [`WORD_WIDE]            w_addr,
    input   wire                            en,
    input   wire                            wen,
    input   wire    [2:0]                   r_mode,
    input   wire    [2:0]                   w_mode,
    input   wire    [`WORD_WIDE]            w_data,
    output  reg     [`WORD_WIDE]            r_data,
    output  wire                            err,
    output  wire    [4:0]                   errid,
    output  reg                             r_ready,
    output  reg                             w_ready,
    //keybroad related
    output  wire                            kbd_en,
    input   wire    [`HALF_WIDE]            kbd_respond,
    input   wire                            kbd_r_ready,
    //visual_adpater_adapater related
    output  wire                            vga_char_wen,
    output  wire                            vga_char_w_offset,
    output  wire    [`BYTE_WIDE]            vga_char_w_data,
    output  wire                            vga_gui_wen,
    output  wire    [11:0]                  vga_gui_w_data,
    input   wire                            vga_w_ready,
    //visual char memory related
    // output  wire                            gmem_char_wen,
    // output  wire    [`VCHM_ADDR_WIDE]       gmem_char_addr,
    // output  reg     [`VCHM_DATA_WIDE]       gmem_char_w_data,
    //visual gui memory related
    output  wire                            gmem_gui_wen,
    output  wire    [`VGPM_ADDR_WIDE]       gmem_gui_addr,
    output  wire    [`VGPM_DATA_WIDE]       gmem_gui_w_data,
    //text_memory related
    output  wire    [2:0]                   tmem_r_mode,
    output  wire    [2:0]                   tmem_w_mode,
    output  wire                            tmem_en,
    output  wire                            tmem_wen,
    output  wire    [`TEXT_ADDR_WIDE]       tmem_r_addr,
    output  wire    [`TEXT_ADDR_WIDE]       tmem_w_addr,
    input   wire    [`WORD_WIDE]            tmem_r_data,
    output  wire    [`WORD_WIDE]            tmem_w_data,     
    //data_memory related
    output  wire    [2:0]                   dmem_r_mode,
    output  wire    [2:0]                   dmem_w_mode,
    output  wire                            dmem_en,
    output  wire                            dmem_wen,
    output  wire    [`DATA_ADDR_WIDE]       dmem_r_addr,
    output  wire    [`DATA_ADDR_WIDE]       dmem_w_addr,
    input   wire    [`WORD_WIDE]            dmem_r_data,
    output  wire    [`WORD_WIDE]            dmem_w_data
);

    //memories are readable with no side-effects
    assign tmem_en = en;
    assign dmem_en = en;
    //keyboard reading are of side-effect!
    wire [`WORD_WIDE] test1 = r_addr & `DEV_MASK;
    wire [`WORD_WIDE] test2 = r_addr & `SEGMENT_MASK;

    assign kbd_en = en && ((r_addr & `DEV_MASK) == `KBD_MARK) && ((r_addr & `SEGMENT_MASK) == `DEVI_SEGMENT);

    //Writing should be more cautious
    assign dmem_wen = en && wen && ((w_addr & `SEGMENT_MASK) == `DATA_SEGMENT);
    assign tmem_wen = en && wen && ((w_addr & `SEGMENT_MASK) == `TEXT_SEGMENT);
    assign gmem_gui_wen = en && wen && ((w_addr & `SEGMENT_MASK) == `VGPM_SEGMENT);
    assign vga_char_wen = en && wen && ((r_addr & `DEV_MASK) == `VGA_MARK) && ((r_addr & `SEGMENT_MASK) == `DEVI_SEGMENT);
    assign vga_gui_wen = en && wen && ((r_addr & `DEV_MASK) == `VGA_G_MARK) && ((r_addr & `SEGMENT_MASK) == `DEVI_SEGMENT);

    //inherited
    assign tmem_r_mode = r_mode;
    assign tmem_w_mode = w_mode;
    assign dmem_r_mode = r_mode;
    assign dmem_w_mode = w_mode;

    //address can be distributed safely since enability has been controlled
    //read address distribution
    assign tmem_r_addr = r_addr[`TEXT_ADDR_WIDE];
    assign dmem_r_addr = r_addr[`DATA_ADDR_WIDE];
    //write address distribution
    assign tmem_w_addr = w_addr[`TEXT_ADDR_WIDE];
    assign dmem_w_addr = w_addr[`DATA_ADDR_WIDE];
    // assign gmem_char_addr = w_addr[`VCHM_ADDR_WIDE];
    assign gmem_gui_addr = w_addr[`VGPM_ADDR_WIDE];

    //w_data can be distributed safely as well since write-enability has been controlled
    assign vga_char_w_data = w_data[`VCHM_DATA_WIDE];
    assign vga_char_w_offset = 0;
    assign dmem_w_data = w_data;
    assign tmem_w_data = w_data;

    reg rerr, werr;
    assign err = rerr | werr;
    assign errid = rerr ? `EXCEPT_RD_INVALID : (werr ? `EXCEPT_WR_INVALID : `EXCEPT_UNDEFINED);

    //attempt to launch read
    //select the one to bus
    always @(*) if(en) begin
        case (r_addr & `SEGMENT_MASK)
            //from devices
            `DEVI_SEGMENT: begin
                case (r_addr & `DEV_MASK)
                    `KBD_MARK: begin r_data = {`HALF_ZERO, kbd_respond}; r_ready = kbd_r_ready; rerr = 0; end
                    //unreadable
                    default: begin r_data = `WORD_ZERO; r_ready = 0; rerr = 1; end
                endcase
            end
            //from memories
            //to-do complete readies
            `TEXT_SEGMENT: begin r_ready = 0; r_data = tmem_r_data;/* r_ready = tmem_r_ready;*/ rerr = (r_addr & `TEXT_MASK) != 0; end
            `DATA_SEGMENT: begin r_ready = 0; r_data = dmem_r_data; rerr = 0; end
            //unreadable
            default: begin r_ready = 0; r_data = `WORD_ZERO; rerr = 1; end
        endcase
    end
    else begin r_data = `WORD_ZERO; r_ready = 0; end

    //detect_write_err
    always @(*) if(en && wen) begin
        case (w_addr & `SEGMENT_MASK)
            `DEVI_SEGMENT: begin
                case (w_addr & `DEV_MASK)
                    `VGA_MARK: begin werr = 0; w_ready = vga_w_ready; end
                    //unwriteable
                    default: begin werr = 1; w_ready = 0; end
                endcase
            end
            `VCHM_SEGMENT: begin werr = 1; w_ready = 0; end
            //not implemented yet
            `VGPM_SEGMENT: begin werr = 1; w_ready = 0; end
            `DATA_SEGMENT: begin werr = 0; w_ready = 0; end
            `TEXT_SEGMENT: begin werr = (w_addr & `TEXT_MASK) != 0; w_ready = 0; end
            default: begin werr = 1; w_ready = 0; end
        endcase
    end

endmodule

`endif
