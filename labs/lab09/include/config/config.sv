`ifndef module_config
`define module_config

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
`endif

`endif
