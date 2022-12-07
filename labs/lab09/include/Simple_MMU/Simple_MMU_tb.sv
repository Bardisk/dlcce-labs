`include "Simple_MMU/Simple_MMU.sv"
`timescale 1ns/1ps

module Simple_MMU_tb (

);

    reg [`WORD_WIDE] r_addr, w_addr;

    initial begin
        $dumpfile("build/wave.vcd");
        $dumpvars;
        w_addr = 0;
        r_addr = 0;
        #20
        w_addr = `VGA_ADDR;
        r_addr = `KBD_ADDR;
        #20
        $finish;
    end

    

    Simple_MMU tb(
        .w_addr(w_addr),
        .r_addr(r_addr),
        .kbd_r_ready(1),
        .vga_w_ready(1),
        .en(1)
    );

endmodule