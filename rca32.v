module rca32 (
    input  wire [31:0] X,
    input  wire [31:0] Y,
    input  wire        CI0,
    input  wire        chain_en,
    output wire [31:0] F,
    output wire [31:0] CO
);
    wire [32:0] carry;
    assign carry[0] = CI0;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : FA_ARRAY
            wire cin_stage;

            if (i == 0) begin : CIN0
                assign cin_stage = carry[0];
            end else begin : CINn
                assign cin_stage = carry[i] & chain_en;
            end

            full_adder fa_inst (
                .X   (X[i]),
                .Y   (Y[i]),
                .CIn (cin_stage),
                .F   (F[i]),
                .CO  (carry[i+1])
            );
        end
    endgenerate

    assign CO = carry[32:1];
endmodule
