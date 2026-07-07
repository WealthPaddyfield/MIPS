`timescale  1ns/1ps

module tb_cpu();

    integer i =0;
    reg clk = 0;
    reg reset;
    reg [31:0]mem[0:256];
    wire [31:0]instr;     //フェッチした命令
    wire [31:0]pc_addr;   //命令アドレス（PC）
    wire [31:0]mem_rdata; //読み込みデータ
    wire [31:0]mem_addr;  //データメモリアドレス
    wire [31:0]mem_wdata; //でーた
    wire MemRead;
    wire MemWrite;

    always #5 clk = ~clk;

    //命令フェッチ
    assign instr = mem[pc_addr[9:2]];

    //データ読み出し
    assign mem_rdata = mem[mem_addr[9:2]];

    //データ書き込み
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[mem_addr[9:2]] <= mem_wdata;
        end
    end


    CPU uut(
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .pc_addr(pc_addr),
        .mem_rdata(mem_rdata),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .MemRead(MemRead),
        .MemWrite(MemWrite)
    );

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_cpu);

    for (i = 0; i < 32; i = i + 1) begin
      uut.RF.regfile[i] = 32'b0;
    end

    for (i = 0; i <= 256; i = i + 1) begin
      mem[i] = 32'b0;
    end

    //データ
    mem[0] = 32'd100;
    mem[1] = 32'd1;

    //プログラム（PC=40 = mem[10]から開始）
    mem[10] = 32'h00001020; //add $2, $0, $0   カウンタ初期化
    mem[11] = 32'h8c030000; //lw  $3, 0($0)    $3 = 100
    mem[12] = 32'h8c040004; //lw  $4, 4($0)    $4 = 1
    mem[13] = 32'h00441020; //add $2, $2, $4   カウンタ+1
    mem[14] = 32'h00220820; //add $1, $1, $2   合計に加算
    mem[15] = 32'h0043282a; //slt $5, $2, $3   $5 = ($2 < 100)
    mem[16] = 32'h10a4fffc; //beq $5, $4, -4   ループ継続ならmem[13]へ
    mem[17] = 32'hac010008; //sw  $1, 8($0)    合計をmem[2]へ格納


    #5
    reset = 1;

    uut.PC = 32'd40;          // mem[10] から
    
    #5500
    $finish;
end

endmodule