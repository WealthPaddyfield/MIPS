module full_adder (
    input  wire X,
    input  wire Y,
    input  wire CIn,
    output wire F,
    output wire CO
);
    assign F  = X ^ Y ^ CIn;
    assign CO = (X & Y) | (Y & CIn) | (X & CIn);
endmodule
