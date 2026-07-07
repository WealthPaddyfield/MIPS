module REG_FILE(
    input  [4:0] rs,
    input  [4:0] rt,
    input  [4:0] rd,
    input  [31:0] write_data,
    input write_enable,
    input clk,

    output [31:0] rs_out,
    output [31:0] rt_out
);

reg [31:0] regfile [31:0];

// 書き戻し(WriteBack)
always @(posedge clk) begin
    //書き込み信号がオンかつレジスタが0番でないことを確認
    if (write_enable && (rd != 5'd0))
        regfile[rd] <= write_data;
end

// 読み出し
//番号が0の場合は0を返す
//単一サイクルCPUでは書き込みはクロックエッジで確定するため
//同一サイクル内のフォワーディングは不要（write_dataを返すと
//rs_out→ALU→write_data→rs_outの組み合わせループになる）
assign rt_out = (rt == 5'd0) ? 32'b0 : regfile[rt];

assign rs_out = (rs == 5'd0) ? 32'b0 : regfile[rs];

endmodule