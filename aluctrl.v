module aluctrl(
    input [1:0]aluOp,
    input [5:0]funct,
    output [2:0]aluFunc
);

    wire i_type = ~aluOp[1];
    wire r_type = aluOp[1];

    wire beq = (aluOp == 2'b01);
    wire add = r_type & (funct == 6'b100000);
    wire sub = r_type & (funct == 6'b100010);
    wire and_= r_type & (funct == 6'b100100);
    wire or_ = r_type & (funct == 6'b100101);
    wire slt = r_type & (funct == 6'b101010);

    wire ALUFunc1 = beq | sub | slt;
    wire ALUFunc2 = ~and_ & ~or_; 
    wire ALUFunc3 = or_ | slt;

    assign aluFunc = {ALUFunc1,ALUFunc2,ALUFunc3};
endmodule
