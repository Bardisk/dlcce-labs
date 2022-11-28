`timescale 1ns/1ps

`include "lab07.sv"

module ps2_keyboard_model(
    output reg ps2_clk,
    output reg ps2_data
);
    parameter [31:0] kbd_clk_period = 60;
    initial ps2_clk = 1'b1;

    task kbd_sendcode;
        input [7:0] code; // key to be sent
        integer i;

        reg[10:0] send_buffer;
        begin
            send_buffer[0] = 1'b0; // start bit
            send_buffer[8:1] = code; // code
            send_buffer[9] = ~(^code); // odd parity bit
            send_buffer[10] = 1'b1; // stop bit
            i = 0;
            while (i < 11) begin
            // set kbd_data
                ps2_data = send_buffer[i];
                #(kbd_clk_period/2) ps2_clk = 1'b0;
                #(kbd_clk_period/2) ps2_clk = 1'b1;
                i = i + 1;
            end
        end
    endtask

endmodule

module lab07_tb();

    initial begin
        $dumpfile("build/wave.vcd");
        $dumpvars;
    end

    reg reset = 1;
    reg clock = 0;
    wire ps2_clk;
    wire ps2_data;

    ps2_keyboard_model model(
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data)
    );

    always #0.5 begin
        clock = ~clock;
    end

    lab07 tb(
        .clock100MHZ(clock),
        .SW({15'b0, reset}),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data)
    );

    integer i;

    initial begin
        reset = 0;
        #1500
        reset = 1;
        i = 0;
        while (i < 100) begin
            #20
            model.kbd_sendcode(8'h1C);
            #20
            model.kbd_sendcode(8'hF0);
            #20
            model.kbd_sendcode(8'h1C);
            i = i + 1;
        end
        $finish;
    end


endmodule

