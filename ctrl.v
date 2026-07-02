module ctrl(
    input [5:0]opCode,
    output [6:0]ctrlSig,
    output [1:0]aluOp
);

    wire r_type = (opCode == 6'b000000);
    wire lw     = (opCode == 6'b100011);
    wire sw     = (opCode == 6'b101011);
    wire beq    = (opCode == 6'b000100);

    wire RegDst   = r_type;
    wire ALUSrc   = lw | sw;
    wire MemtoReg = lw;
    wire RegWrite = r_type | lw;
    wire MemRead  = lw;
    wire MemWrite = sw;
    wire PCSrc    = beq;
    wire ALUOp1   = r_type;
    wire ALUOp2   = beq;

    assign ctrlSig = {RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, PCSrc};
    assign aluOp   = {ALUOp1, ALUOp2};
endmodule
