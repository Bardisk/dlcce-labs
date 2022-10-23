`ifndef module_ledTube
`define module_ledTube

module ledTube(
    input wire en,
    input wire signal,
    output wire light
);
    
    assign light = signal & en;

endmodule

`endif
