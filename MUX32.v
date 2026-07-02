module MUX32(
    input [31:0]a,
    input [31:0]b,
    input s,
    output [31:0]z
);

    assign z = s ? a : b;

endmodule