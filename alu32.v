module alu32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  S,      // S = {S2, S1, S0}
    output reg  [31:0] F,
    output reg Z
);
    wire S2 = S[2];
    wire S1 = S[1];
    wire S0 = S[0];

    reg  [31:0] X, Y;
    reg         CI0;

    wire [31:0] rca_F;
    wire [31:0] rca_CO;
    wire        chain_en = S1;

    rca32 u_rca (
        .X        (X),
        .Y        (Y),
        .CI0      (CI0),
        .chain_en (chain_en),
        .F        (rca_F),
        .CO       (rca_CO)
    );

    always @(*) begin
        case ({S2, S1, S0})
            3'b010: begin  // ADD : F = A + B
                X   = A;
                Y   = B;
                CI0 = 1'b0;
            end
            3'b110: begin  // SUB : F = A - B
                X   = A;
                Y   = ~B;
                CI0 = 1'b1;
            end
            3'b001: begin  // OR  : F = A | B
                X   = A | B;
                Y   = 32'b0;
                CI0 = 1'b0;
            end
            3'b000: begin  // AND : F = A & B
                X   = A | (~B);
                Y   = ~B;
                CI0 = 1'b0;
            end
            3'b111: begin  // CMP : F = (A<B) ? 1 : 0
                X   = A;
                Y   = ~B;
                CI0 = 1'b1;
            end
            default: begin
                X   = A;
                Y   = B;
                CI0 = 1'b0;
            end
        endcase
    end

    always @(*) begin
        case ({S2, S1, S0})
            3'b111:  F = {31'b0, ~rca_CO[31]};
            default: F = rca_F;
        endcase
    end

    // 0判定: Fがオール0のとき1
    always @(*) begin
        Z = (F == 32'b0);
    end
endmodule