module CPU(
    input clk,
    input reset,
    input [31:0]mem_rdata, //読み込みデータ
    output [31:0]mem_addr, //メモリアドレス
    output [31:0]mem_wdata, //でーた
    output MemRead,
    output MemWrite
);


wire [1:0]aluOp;    //ALUOp
wire [6:0]ctrlSig;  //制御信号
wire [5:0]funct = mem_rdata[5:0];    //funct 命令
wire [2:0]aluFunc;  //ALU操作（ALU制御の出力）
wire [31:0]F;       //ALU出力
wire isZero;
wire [4:0]rs = mem_rdata[25:21];  //読み出し番号1
wire [4:0]rt = mem_rdata[20:16];  //読み出し番号2
wire [4:0]rd = mem_rdata[15:11];
wire [4:0]writeNum; //書き込み番号：MUX_TOREGの出力
wire [31:0]signExt = {{16{mem_rdata[15]}},mem_rdata[15:0]}; //命令15-０を符号拡張した信号
wire [31:0]write_data;

//ctrlSig:制御信号
//制御信号の各ビットを割り当て
wire RegDst = ctrlSig[6];
wire ALUSrc = ctrlSig[5];
wire MemtoReg = ctrlSig[4];
wire RegWrite = ctrlSig[3];
assign MemRead = ctrlSig[2];
assign MemWrite = ctrlSig[1];
wire PCSrc = ctrlSig[0];

wire pcSel = isZero & PCSrc; //左上のANDのつもり
wire [31:0]rdata1; //図中　読み出しデータ1
wire [31:0]rdata2; //読み出しデータ2

reg [31:0]PC = 32'b0;
//reg [31:0]PC;

//u_
//IR decode
wire [5:0]opcode = mem_rdata[31:26];

//制御（図中：左下）
ctrl u_ctrl(
    .opCode(opcode),
    .ctrlSig(ctrlSig),
    .aluOp(aluOp)
);

//レジスタの手前のMUX
MUX05 MUX_TOREG(
    .a(rd),           //命令[15-11]
    .b(rt),           //命令[20-16]
    .s(RegDst),     //RegDst
    .z(writeNum)            //書き込み番号    
);

//レジスタ
REG_FILE RF(
    .rs(rs),
    .rt(rt),
    .rd(writeNum),
    .write_data(write_data),
    .write_enable(RegWrite),
    .clk(clk), //クロックを入れる
    .rs_out(rdata1),
    .rt_out(rdata2)
);


/*

reg [31:0] registerFile [31:0];
*/



//writeBack process

//ALU
wire [31:0]aluIn1 = rdata1;
wire [31:0]aluIn2;

//ALU制御
aluctrl u_aluctrl(
    .aluOp(aluOp),
    .funct(funct),
    .aluFunc(aluFunc)
);

MUX32 MUX_TOALU(
    .a(signExt),      //符号拡張出力
    .b(rdata2),      //読み出しデータ2
    .s(ALUSrc),           //ALUSrc
    .z(aluIn2)            //ALUに入力
);

//ALU
alu32 u_alu(
    .A(aluIn1),
    .B(aluIn2),
    .S(aluFunc),
    .F(F),
    .Z(isZero)
);

MUX32 MUX_ALUOUT(
    .a(mem_rdata),
    .b(F),
    .s(MemtoReg),
    .z(write_data)    //書き込みデータ
);

assign mem_addr = PC;

assign mem_wdata = rdata2;

//parameter ADDR_WIDTH = 24;

wire [31:0] nextPC = PC + 4; //順次実行される際の次の実行位置
wire [31:0] bAddr = nextPC + (signExt << 2); //計算

always @(posedge clk)begin
    if(!reset)
        PC <= 32'b0;
    else
        PC <= pcSel ? bAddr : nextPC;
end

endmodule