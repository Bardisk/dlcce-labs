`ifndef module_Vga_Ctr
`define module_Vga_Ctr

module Vga_Ctr(
    input   wire                clk,
    input   wire                rst,
    // input   wire    [11:0]      vga_data,
    output  wire    [9:0]       h_addr,
    output  wire    [9:0]       v_addr,
    output  wire                hsync,
    output  wire                vsync,
    output  wire                valid
    // output  wire                vga_r,
    // output  wire                vga_g,
    // output  wire                vga_b
);

    parameter h_frontporch = `H_FRONTPROCH;
    parameter h_active = `H_ACTIVE;
    parameter h_backporch = `H_BACKPORCH;
    parameter h_total = `H_TOTAL;

    parameter v_frontporch = `V_FRONTPROCH;
    parameter v_active = `V_ACTIVE;
    parameter v_backporch = `V_BACKPORCH;
    parameter v_total = `V_TOTAL;

    reg [9:0] x_cnt, y_cnt;
    wire h_valid, v_valid;

    // assign vga_r = vga_data[11:8];
    // assign vga_g = vga_data[7:4];
    // assign vga_b = vga_data[3:D0];

    assign h_valid = (x_cnt > h_active) & (x_cnt <= h_backporch);
    assign v_valid = (y_cnt > v_active) & (y_cnt <= v_backporch);
    assign valid = h_valid & v_valid;

    assign h_addr = h_valid ? (x_cnt - h_active - 10'b1) : {10{1'b0}};
    assign v_addr = v_valid ? (y_cnt - v_active - 10'b1) : {10{1'b0}};

    assign hsync = (x_cnt > h_frontporch);
    assign vsync = (y_cnt > v_frontporch);

    always @(posedge clk, negedge rst) begin
        if(!rst)
            x_cnt <= 1;
        else begin
            if (x_cnt == h_total)
                 x_cnt <= 1;
            else
                x_cnt <= x_cnt + 10'd1;
        end
    end

    always @(posedge clk, negedge rst) begin
        if(!rst)
            y_cnt <= 1;
        else begin
            if (y_cnt == v_total & x_cnt == h_total)
                y_cnt <= 1;
            else if (x_cnt == h_total)
                y_cnt <= y_cnt + 10'd1;
        end
    end

endmodule

`endif