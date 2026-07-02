`timescale  1ns/1ps

module tb_cpu();

    integer i =0;
    reg clk = 0;
    //reg reset;
    reg [31:0]mem[0:256];
    reg [31:0]mem_rdata; //読み込みデータ
    wire [31:0]mem_addr; //メモリアドレス
    wire [31:0]mem_wdata; //でーた
    wire MemRead;
    wire MemWrite;

    always #5 clk = ~clk;

    //always @(posedge clk) begin
    //    mem_rdata <= mem[mem_addr[9:2]];
    //end
    always @(posedge clk) begin
    if (MemWrite) begin
        mem[mem_addr[9:2]] <= mem_wdata;
    end
    mem_rdata <= mem[mem_addr[9:2]];
    end


    CPU uut(
        .clk(clk),
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

    
    uut.RF.regfile[2] = 32'h8;
    uut.RF.regfile[3] = 32'h5;

//    mem[0] = 32'b00000000010000110000100000100000;
    mem[0] = 32'd100;
    mem[4] = 32'd1;
    mem[10] = 32'h00001020;
    mem[11] = 32'h8c030000;
    mem[12] = 32'h8c040004`timescale  1ns/1ps

module tb_cpu();

    integer i =0;
    reg clk = 0;
    reg reset;
    reg [31:0]mem[0:256];
    reg [31:0]mem_rdata; //読み込みデータ
    wire [31:0]mem_addr; //メモリアドレス
    wire [31:0]mem_wdata; //でーた
    wire MemRead;
    wire MemWrite;

    always #5 clk = ~clk;

    always @(posedge clk) begin
    if (MemWrite) begin
        mem[mem_addr[9:2]] <= mem_wdata;
    end
    mem_rdata <= mem[mem_addr[9:2]];
    end


    CPU uut(
        .clk(clk),
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

    //mem[0] = 32'b00000000010000110000100000100000;
    mem[0] = 32'd100;
    mem[4] = 32'd1;
    mem[10] = 32'h00001020;
    mem[11] = 32'h8c030000;
    mem[12] = 32'h8c040004;
    mem[13] = 32'h00441020;
    mem[14] = 32'h00220820;
    mem[15] = 32'h0043282a;
    mem[16] = 32'h10a4fffc;
    mem[17] = 32'hac010008;
    
    
    reset = 0;
    #10
    reset = 1;
    #10
    
    uut.PC = 32'd40;          // mem[10] から開始
    #1500

    $finish;
end
    

endmodule;
    mem[13] = 32'h00441020;
    mem[14] = 32'h00220820;
    mem[15] = 32'h0043282a;
    mem[16] = 32'h10a4fffc;
    mem[17] = 32'hac010008;
    #500

    $finish;
end
    

endmodule