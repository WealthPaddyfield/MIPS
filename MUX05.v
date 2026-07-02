module MUX05(
    input [4:0]a,
    input [4:0]b,
    input s,
    output [4:0]z
);

    assign z = s ? a : b;

endmodule