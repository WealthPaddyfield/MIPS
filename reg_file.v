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
assign rt_out =
    //番号が0の場合は0を返す
    (rt == 5'd0) ? 32'b0 :
    //rd == rtの場合はwrite_dataを返す そうでなければregfileのrt番の値を返す
    ((write_enable && (rd == rt) && (rd != 5'd0)) ? write_data : regfile[rt]);

assign rs_out =
    (rs == 5'd0) ? 32'b0 :
    ((write_enable && (rd == rs) && (rd != 5'd0)) ? write_data : regfile[rs]);

endmodule