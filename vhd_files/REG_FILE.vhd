library IEEE;
use IEEE.std_logic_1164.all;


entity REG_FILE is

  --レジスタ選択信号 3オペランドなので3つ rt rs rd それぞれ5-bit
  --書き込むデータの信号線 write_data 32-bit
  --書き込みを許可する信号線 write_enable 1-bit
  --クロック入力 clk 1-bit

  --rt で読出したデータの出力 rt_out 32-bit
  --rs で読出したデータの出力 rs_out 32-bit
  Port( rt , rs , rd : in std_logic_vector( 4 downto 0 );
        write_data   : in std_logic_vector( 31 downto 0 );
        write_enable : in std_logic;
        clk          : in std_logic;
        
        rt_out       : out std_logic_vector( 31 downto 0 );
        rs_out       : out std_logic_vector( 31 downto 0 )
        
        );

end REG_FILE;


architecture RTL of REG_FILE is


  component REG_EN_TTBIT

      Port( data_in : in std_logic_vector( 31 downto 0 ) ;
            en_in   : in std_logic ;
            clk_in  : in std_logic ;
        
            q       : out std_logic_vector( 31 downto 0 ));

  end component;

  --レジスタの出力ライン 32x32
  signal REG_OUT : std_logic_vector( 1023 downto 0 );

  --このラインが１になったレジスタが書き込まれる
  signal WRITE_REG_SELECT : std_logic_vector( 31 downto 0 );

  --レジスタレジスタからマルチプレクサへのライン
  signal RT_DETEC : std_logic_vector( 1023 downto 0 );
  signal RS_DETEC : std_logic_vector( 1023 downto 0 );
  
  --セレクトアドレス線の正負逆転の信号線
  signal NOT_RT : std_logic_vector( 4 downto 0 );
  signal NOT_RS : std_logic_vector( 4 downto 0 );
  signal NOT_RD : std_logic_vector( 4 downto 0 );

  --アドレス一致の判定ライン
  signal ADDRESS_CMP_RT : std_logic_vector( 4 downto 0 );
  signal ADDRESS_CMP_RS : std_logic_vector( 4 downto 0 );
  signal ENABLE_CHECK_RT : std_logic;
  signal ENABLE_CHECK_RS : std_logic;
  signal ADDRESS_CONSISTENT_RT : std_logic;
  signal ADDRESS_CONSISTENT_RS : std_logic;

  --WBステージの書き込みを読出した場合を考慮しない出力ライン
  signal INTERIM_RT_OUT : std_logic_vector( 31 downto 0 );
  signal INTERIM_RS_OUT : std_logic_vector( 31 downto 0 );

  --アドレス一致判定ラインの反転
  signal NOT_AC_RT : std_logic;
  signal NOT_AC_RS : std_logic;

  --WBステージから来たデータかレジスタ内のデータかをセレクトするライン
  signal SELECT_RT_WB_OR_ID : std_logic_vector( 63 downto 0 );
  signal SELECT_RS_WB_OR_ID : std_logic_vector( 63 downto 0 );

  --ゼロレジスタのための 0 を出力する信号線
  signal ZERO_REG_OUT : std_logic;

  --出力出口でのレジスタ値かrdで書き込もうとする値か選択のときに
  --レジスタアドレスが０でないという条件を追加するための信号線
  signal REG_ADDR_ZERO_RT : std_logic;
  signal REG_ADDR_ZERO_RS : std_logic;
  signal NOT_REG_ADDR_ZERO_RT : std_logic;
  signal NOT_REG_ADDR_ZERO_RS : std_logic;
  
  begin

    --３２ビットのレジスタを３２個用意する。
    --generate文で３２個つくる。
    UNIT_LOOP : for I in 0 to 31 generate
    
      U : REG_EN_TTBIT port map( data_in  => write_data ,
                                 en_in    => WRITE_REG_SELECT( I ) ,
                                 clk_in   => clk ,

                                 q( 0 )   => REG_OUT( 0  + 32 * I ) ,
                                 q( 1 )   => REG_OUT( 1  + 32 * I ) ,
                                 q( 2 )   => REG_OUT( 2  + 32 * I ) ,
                                 q( 3 )   => REG_OUT( 3  + 32 * I ) ,
                                 q( 4 )   => REG_OUT( 4  + 32 * I ) ,
                                 q( 5 )   => REG_OUT( 5  + 32 * I ) ,
                                 q( 6 )   => REG_OUT( 6  + 32 * I ) ,
                                 q( 7 )   => REG_OUT( 7  + 32 * I ) ,
                                 q( 8 )   => REG_OUT( 8  + 32 * I ) ,
                                 q( 9 )   => REG_OUT( 9  + 32 * I ) ,
                                 q( 10 )  => REG_OUT( 10 + 32 * I ) ,
                                 q( 11 )  => REG_OUT( 11 + 32 * I ) ,
                                 q( 12 )  => REG_OUT( 12 + 32 * I ) ,
                                 q( 13 )  => REG_OUT( 13 + 32 * I ) ,
                                 q( 14 )  => REG_OUT( 14 + 32 * I ) ,
                                 q( 15 )  => REG_OUT( 15 + 32 * I ) ,
                                 q( 16 )  => REG_OUT( 16 + 32 * I ) ,
                                 q( 17 )  => REG_OUT( 17 + 32 * I ) ,
                                 q( 18 )  => REG_OUT( 18 + 32 * I ) ,
                                 q( 19 )  => REG_OUT( 19 + 32 * I ) ,
                                 q( 20 )  => REG_OUT( 20 + 32 * I ) ,
                                 q( 21 )  => REG_OUT( 21 + 32 * I ) ,
                                 q( 22 )  => REG_OUT( 22 + 32 * I ) ,
                                 q( 23 )  => REG_OUT( 23 + 32 * I ) ,
                                 q( 24 )  => REG_OUT( 24 + 32 * I ) ,
                                 q( 25 )  => REG_OUT( 25 + 32 * I ) ,
                                 q( 26 )  => REG_OUT( 26 + 32 * I ) ,
                                 q( 27 )  => REG_OUT( 27 + 32 * I ) ,
                                 q( 28 )  => REG_OUT( 28 + 32 * I ) ,
                                 q( 29 )  => REG_OUT( 29 + 32 * I ) ,
                                 q( 30 )  => REG_OUT( 30 + 32 * I ) ,
                                 q( 31 )  => REG_OUT( 31 + 32 * I ) );

      end generate UNIT_LOOP;

      --最初に読出しを定義する。
      --まずマルチプレクサのための選択信号 rt rs rd の正負反転信号を定義する。
      loop0 : for I in 0 to 4 generate

        NOT_RT( I ) <= not rt( I );
        NOT_RS( I ) <= not rs( I );
        NOT_RD( I ) <= not rd( I );

      end generate loop0;

      --rt rs レジスタアドレスでどちらでも「レジスタアドレス０」が指定された場合は中に何が入っていても
      --0を読出さねばならない。これを実現するためにもっとも簡単な修正として０番レジスタの出力を
      --無視して 0 を強制出力するようにすればよい。
      --よって以下の0を出力する信号線を定義して REG_OUT( 0 * 32 + I ) とスワップする。
      ZERO_REG_OUT <= '0';
      

      --出力 rt のための条件を用意する。5ビット＝32通り
      --RT_DETEC は32条件なので 32x32で1024本要る。
      --例えば rt(0) は RT_DETEC(0) or RT_DETEC(1) or RT_DETEC(2) or RT_DETEC(3) => => => or RT_DETEC(31)
      --RT_DETEC(0)～RT_DETEC(31)の一つでも１ならrtには１が入る
      --という感じにしたい。
      
      loop1 : for I in 0 to 31 generate

      RT_DETEC( I * 32 + 0 )  <= NOT_RT( 0 ) and NOT_RT( 1 ) and NOT_RT( 2 ) and NOT_RT( 3 ) and NOT_RT( 4 ) and ZERO_REG_OUT;
      RT_DETEC( I * 32 + 1 )  <= rt( 0 )     and NOT_RT( 1 ) and NOT_RT( 2 ) and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 1 * 32 + I );
      RT_DETEC( I * 32 + 2 )  <= NOT_RT( 0 ) and rt( 1 )     and NOT_RT( 2 ) and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 2 * 32 + I );
      RT_DETEC( I * 32 + 3 )  <= rt( 0 )     and rt( 1 )     and NOT_RT( 2 ) and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 3 * 32 + I );
      RT_DETEC( I * 32 + 4 )  <= NOT_RT( 0 ) and NOT_RT( 1 ) and rt( 2 )     and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 4 * 32 + I );
      RT_DETEC( I * 32 + 5 )  <= rt( 0 )     and NOT_RT( 1 ) and rt( 2 )     and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 5 * 32 + I );
      RT_DETEC( I * 32 + 6 )  <= NOT_RT( 0 ) and rt( 1 )     and rt( 2 )     and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 6 * 32 + I );
      RT_DETEC( I * 32 + 7 )  <= rt( 0 )     and rt( 1 )     and rt( 2 )     and NOT_RT( 3 ) and NOT_RT( 4 ) and REG_OUT( 7 * 32 + I );
      RT_DETEC( I * 32 + 8 )  <= NOT_RT( 0 ) and NOT_RT( 1 ) and NOT_RT( 2 ) and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 8 * 32 + I );
      RT_DETEC( I * 32 + 9 )  <= rt( 0 )     and NOT_RT( 1 ) and NOT_RT( 2 ) and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 9 * 32 + I );
      RT_DETEC( I * 32 + 10 ) <= NOT_RT( 0 ) and rt( 1 )     and NOT_RT( 2 ) and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 10 * 32 + I );
      RT_DETEC( I * 32 + 11 ) <= rt( 0 )     and rt( 1 )     and NOT_RT( 2 ) and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 11 * 32 + I );
      RT_DETEC( I * 32 + 12 ) <= NOT_RT( 0 ) and NOT_RT( 1 ) and rt( 2 )     and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 12 * 32 + I );
      RT_DETEC( I * 32 + 13 ) <= rt( 0 )     and NOT_RT( 1 ) and rt( 2 )     and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 13 * 32 + I );
      RT_DETEC( I * 32 + 14 ) <= NOT_RT( 0 ) and rt( 1 )     and rt( 2 )     and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 14 * 32 + I );
      RT_DETEC( I * 32 + 15 ) <= rt( 0 )     and rt( 1 )     and rt( 2 )     and rt( 3 )     and NOT_RT( 4 ) and REG_OUT( 15 * 32 + I );
      RT_DETEC( I * 32 + 16 ) <= NOT_RT( 0 ) and NOT_RT( 1 ) and NOT_RT( 2 ) and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 16 * 32 + I );
      RT_DETEC( I * 32 + 17 ) <= rt( 0 )     and NOT_RT( 1 ) and NOT_RT( 2 ) and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 17 * 32 + I );
      RT_DETEC( I * 32 + 18 ) <= NOT_RT( 0 ) and rt( 1 )     and NOT_RT( 2 ) and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 18 * 32 + I );
      RT_DETEC( I * 32 + 19 ) <= rt( 0 )     and rt( 1 )     and NOT_RT( 2 ) and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 19 * 32 + I );
      RT_DETEC( I * 32 + 20 ) <= NOT_RT( 0 ) and NOT_RT( 1 ) and rt( 2 )     and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 20 * 32 + I );
      RT_DETEC( I * 32 + 21 ) <= rt( 0 )     and NOT_RT( 1 ) and rt( 2 )     and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 21 * 32 + I );
      RT_DETEC( I * 32 + 22 ) <= NOT_RT( 0 ) and rt( 1 )     and rt( 2 )     and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 22 * 32 + I );
      RT_DETEC( I * 32 + 23 ) <= rt( 0 )     and rt( 1 )     and rt( 2 )     and NOT_RT( 3 ) and rt( 4 )     and REG_OUT( 23 * 32 + I );
      RT_DETEC( I * 32 + 24 ) <= NOT_RT( 0 ) and NOT_RT( 1 ) and NOT_RT( 2 ) and rt( 3 )     and rt( 4 )     and REG_OUT( 24 * 32 + I );
      RT_DETEC( I * 32 + 25 ) <= rt( 0 )     and NOT_RT( 1 ) and NOT_RT( 2 ) and rt( 3 )     and rt( 4 )     and REG_OUT( 25 * 32 + I );
      RT_DETEC( I * 32 + 26 ) <= NOT_RT( 0 ) and rt( 1 )     and NOT_RT( 2 ) and rt( 3 )     and rt( 4 )     and REG_OUT( 26 * 32 + I );
      RT_DETEC( I * 32 + 27 ) <= rt( 0 )     and rt( 1 )     and NOT_RT( 2 ) and rt( 3 )     and rt( 4 )     and REG_OUT( 27 * 32 + I );
      RT_DETEC( I * 32 + 28 ) <= NOT_RT( 0 ) and NOT_RT( 1 ) and rt( 2 )     and rt( 3 )     and rt( 4 )     and REG_OUT( 28 * 32 + I );
      RT_DETEC( I * 32 + 29 ) <= rt( 0 )     and NOT_RT( 1 ) and rt( 2 )     and rt( 3 )     and rt( 4 )     and REG_OUT( 29 * 32 + I );
      RT_DETEC( I * 32 + 30 ) <= NOT_RT( 0 ) and rt( 1 )     and rt( 2 )     and rt( 3 )     and rt( 4 )     and REG_OUT( 30 * 32 + I );
      RT_DETEC( I * 32 + 31 ) <= rt( 0 )     and rt( 1 )     and rt( 2 )     and rt( 3 )     and rt( 4 )     and REG_OUT( 31 * 32 + I );

      end generate loop1;

      --上から32づつ orを取る。
      loop2 : for I in 0 to 31 generate

        INTERIM_RT_OUT( I ) <= RT_DETEC( 0 + 32 * I )  or
                               RT_DETEC( 1 + 32 * I )  or
                               RT_DETEC( 2 + 32 * I )  or
                               RT_DETEC( 3 + 32 * I )  or
                               RT_DETEC( 4 + 32 * I )  or
                               RT_DETEC( 5 + 32 * I )  or
                               RT_DETEC( 6 + 32 * I )  or
                               RT_DETEC( 7 + 32 * I )  or
                               RT_DETEC( 8 + 32 * I )  or
                               RT_DETEC( 9 + 32 * I )  or
                               RT_DETEC( 10 + 32 * I ) or
                               RT_DETEC( 11 + 32 * I ) or
                               RT_DETEC( 12 + 32 * I ) or
                               RT_DETEC( 13 + 32 * I ) or
                               RT_DETEC( 14 + 32 * I ) or
                               RT_DETEC( 15 + 32 * I ) or
                               RT_DETEC( 16 + 32 * I ) or
                               RT_DETEC( 17 + 32 * I ) or
                               RT_DETEC( 18 + 32 * I ) or
                               RT_DETEC( 19 + 32 * I ) or
                               RT_DETEC( 20 + 32 * I ) or
                               RT_DETEC( 21 + 32 * I ) or
                               RT_DETEC( 22 + 32 * I ) or
                               RT_DETEC( 23 + 32 * I ) or
                               RT_DETEC( 24 + 32 * I ) or
                               RT_DETEC( 25 + 32 * I ) or
                               RT_DETEC( 26 + 32 * I ) or
                               RT_DETEC( 27 + 32 * I ) or
                               RT_DETEC( 28 + 32 * I ) or
                               RT_DETEC( 29 + 32 * I ) or
                               RT_DETEC( 30 + 32 * I ) or
                               RT_DETEC( 31 + 32 * I );                                  

      end generate loop2;

      --rsについての条件判定
      loop3 : for I in 0 to 31 generate

      RS_DETEC( I * 32 + 0 )  <= ZERO_REG_OUT;
      RS_DETEC( I * 32 + 1 )  <= rs( 0 )     and NOT_RS( 1 ) and NOT_RS( 2 ) and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 1 * 32 + I );
      RS_DETEC( I * 32 + 2 )  <= NOT_RS( 0 ) and rs( 1 )     and NOT_RS( 2 ) and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 2 * 32 + I );
      RS_DETEC( I * 32 + 3 )  <= rs( 0 )     and rs( 1 )     and NOT_RS( 2 ) and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 3 * 32 + I );
      RS_DETEC( I * 32 + 4 )  <= NOT_RS( 0 ) and NOT_RS( 1 ) and rs( 2 )     and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 4 * 32 + I );
      RS_DETEC( I * 32 + 5 )  <= rs( 0 )     and NOT_RS( 1 ) and rs( 2 )     and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 5 * 32 + I );
      RS_DETEC( I * 32 + 6 )  <= NOT_RS( 0 ) and rs( 1 )     and rs( 2 )     and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 6 * 32 + I );
      RS_DETEC( I * 32 + 7 )  <= rs( 0 )     and rs( 1 )     and rs( 2 )     and NOT_RS( 3 ) and NOT_RS( 4 ) and REG_OUT( 7 * 32 + I );
      RS_DETEC( I * 32 + 8 )  <= NOT_RS( 0 ) and NOT_RS( 1 ) and NOT_RS( 2 ) and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 8 * 32 + I );
      RS_DETEC( I * 32 + 9 )  <= rs( 0 )     and NOT_RS( 1 ) and NOT_RS( 2 ) and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 9 * 32 + I );
      RS_DETEC( I * 32 + 10 ) <= NOT_RS( 0 ) and rs( 1 )     and NOT_RS( 2 ) and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 10 * 32 + I );
      RS_DETEC( I * 32 + 11 ) <= rs( 0 )     and rs( 1 )     and NOT_RS( 2 ) and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 11 * 32 + I );
      RS_DETEC( I * 32 + 12 ) <= NOT_RS( 0 ) and NOT_RS( 1 ) and rs( 2 )     and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 12 * 32 + I );
      RS_DETEC( I * 32 + 13 ) <= rs( 0 )     and NOT_RS( 1 ) and rs( 2 )     and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 13 * 32 + I );
      RS_DETEC( I * 32 + 14 ) <= NOT_RS( 0 ) and rs( 1 )     and rs( 2 )     and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 14 * 32 + I );
      RS_DETEC( I * 32 + 15 ) <= rs( 0 )     and rs( 1 )     and rs( 2 )     and rs( 3 )     and NOT_RS( 4 ) and REG_OUT( 15 * 32 + I );
      RS_DETEC( I * 32 + 16 ) <= NOT_RS( 0 ) and NOT_RS( 1 ) and NOT_RS( 2 ) and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 16 * 32 + I );
      RS_DETEC( I * 32 + 17 ) <= rs( 0 )     and NOT_RS( 1 ) and NOT_RS( 2 ) and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 17 * 32 + I );
      RS_DETEC( I * 32 + 18 ) <= NOT_RS( 0 ) and rs( 1 )     and NOT_RS( 2 ) and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 18 * 32 + I );
      RS_DETEC( I * 32 + 19 ) <= rs( 0 )     and rs( 1 )     and NOT_RS( 2 ) and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 19 * 32 + I );
      RS_DETEC( I * 32 + 20 ) <= NOT_RS( 0 ) and NOT_RS( 1 ) and rs( 2 )     and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 20 * 32 + I );
      RS_DETEC( I * 32 + 21 ) <= rs( 0 )     and NOT_RS( 1 ) and rs( 2 )     and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 21 * 32 + I );
      RS_DETEC( I * 32 + 22 ) <= NOT_RS( 0 ) and rs( 1 )     and rs( 2 )     and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 22 * 32 + I );
      RS_DETEC( I * 32 + 23 ) <= rs( 0 )     and rs( 1 )     and rs( 2 )     and NOT_RS( 3 ) and rs( 4 )     and REG_OUT( 23 * 32 + I );
      RS_DETEC( I * 32 + 24 ) <= NOT_RS( 0 ) and NOT_RS( 1 ) and NOT_RS( 2 ) and rs( 3 )     and rs( 4 )     and REG_OUT( 24 * 32 + I );
      RS_DETEC( I * 32 + 25 ) <= rs( 0 )     and NOT_RS( 1 ) and NOT_RS( 2 ) and rs( 3 )     and rs( 4 )     and REG_OUT( 25 * 32 + I );
      RS_DETEC( I * 32 + 26 ) <= NOT_RS( 0 ) and rs( 1 )     and NOT_RS( 2 ) and rs( 3 )     and rs( 4 )     and REG_OUT( 26 * 32 + I );
      RS_DETEC( I * 32 + 27 ) <= rs( 0 )     and rs( 1 )     and NOT_RS( 2 ) and rs( 3 )     and rs( 4 )     and REG_OUT( 27 * 32 + I );
      RS_DETEC( I * 32 + 28 ) <= NOT_RS( 0 ) and NOT_RS( 1 ) and rs( 2 )     and rs( 3 )     and rs( 4 )     and REG_OUT( 28 * 32 + I );
      RS_DETEC( I * 32 + 29 ) <= rs( 0 )     and NOT_RS( 1 ) and rs( 2 )     and rs( 3 )     and rs( 4 )     and REG_OUT( 29 * 32 + I );
      RS_DETEC( I * 32 + 30 ) <= NOT_RS( 0 ) and rs( 1 )     and rs( 2 )     and rs( 3 )     and rs( 4 )     and REG_OUT( 30 * 32 + I );
      RS_DETEC( I * 32 + 31 ) <= rs( 0 )     and rs( 1 )     and rs( 2 )     and rs( 3 )     and rs( 4 )     and REG_OUT( 31 * 32 + I );
      
      end generate loop3;

      loop4 : for I in 0 to 31 generate

      INTERIM_RS_OUT( I ) <= RS_DETEC( 0  + 32 * I ) or
                             RS_DETEC( 1  + 32 * I ) or
                             RS_DETEC( 2  + 32 * I ) or
                             RS_DETEC( 3  + 32 * I ) or
                             RS_DETEC( 4  + 32 * I ) or
                             RS_DETEC( 5  + 32 * I ) or
                             RS_DETEC( 6  + 32 * I ) or
                             RS_DETEC( 7  + 32 * I ) or
                             RS_DETEC( 8  + 32 * I ) or
                             RS_DETEC( 9  + 32 * I ) or
                             RS_DETEC( 10 + 32 * I ) or
                             RS_DETEC( 11 + 32 * I ) or
                             RS_DETEC( 12 + 32 * I ) or
                             RS_DETEC( 13 + 32 * I ) or
                             RS_DETEC( 14 + 32 * I ) or
                             RS_DETEC( 15 + 32 * I ) or
                             RS_DETEC( 16 + 32 * I ) or
                             RS_DETEC( 17 + 32 * I ) or
                             RS_DETEC( 18 + 32 * I ) or
                             RS_DETEC( 19 + 32 * I ) or
                             RS_DETEC( 20 + 32 * I ) or
                             RS_DETEC( 21 + 32 * I ) or
                             RS_DETEC( 22 + 32 * I ) or
                             RS_DETEC( 23 + 32 * I ) or
                             RS_DETEC( 24 + 32 * I ) or
                             RS_DETEC( 25 + 32 * I ) or
                             RS_DETEC( 26 + 32 * I ) or
                             RS_DETEC( 27 + 32 * I ) or
                             RS_DETEC( 28 + 32 * I ) or
                             RS_DETEC( 29 + 32 * I ) or
                             RS_DETEC( 30 + 32 * I ) or
                             RS_DETEC( 31 + 32 * I );                                  

      end generate loop4;

      --書き込みレジスタ選択
      --例えばWRITE_REG_SELECT(0)は0番目のレジスタのイネーブル

      WRITE_REG_SELECT( 0 )  <= NOT_RD( 0 ) and NOT_RD( 1 ) and NOT_RD( 2 ) and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 1 )  <= rd( 0 )     and NOT_RD( 1 ) and NOT_RD( 2 ) and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 2 )  <= NOT_RD( 0 ) and rd( 1 )     and NOT_RD( 2 ) and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 3 )  <= rd( 0 )     and rd( 1 )     and NOT_RD( 2 ) and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 4 )  <= NOT_RD( 0 ) and NOT_RD( 1 ) and rd( 2 )     and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 5 )  <= rd( 0 )     and NOT_RD( 1 ) and rd( 2 )     and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 6 )  <= NOT_RD( 0 ) and rd( 1 )     and rd( 2 )     and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 7 )  <= rd( 0 )     and rd( 1 )     and rd( 2 )     and NOT_RD( 3 ) and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 8 )  <= NOT_RD( 0 ) and NOT_RD( 1 ) and NOT_RD( 2 ) and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 9 )  <= rd( 0 )     and NOT_RD( 1 ) and NOT_RD( 2 ) and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 10 ) <= NOT_RD( 0 ) and rd( 1 )     and NOT_RD( 2 ) and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 11 ) <= rd( 0 )     and rd( 1 )     and NOT_RD( 2 ) and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 12 ) <= NOT_RD( 0 ) and NOT_RD( 1 ) and rd( 2 )     and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 13 ) <= rd( 0 )     and NOT_RD( 1 ) and rd( 2 )     and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 14 ) <= NOT_RD( 0 ) and rd( 1 )     and rd( 2 )     and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 15 ) <= rd( 0 )     and rd( 1 )     and rd( 2 )     and rd( 3 )     and NOT_RD( 4 ) and write_enable;
      WRITE_REG_SELECT( 16 ) <= NOT_RD( 0 ) and NOT_RD( 1 ) and NOT_RD( 2 ) and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 17 ) <= rd( 0 )     and NOT_RD( 1 ) and NOT_RD( 2 ) and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 18 ) <= NOT_RD( 0 ) and rd( 1 )     and NOT_RD( 2 ) and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 19 ) <= rd( 0 )     and rd( 1 )     and NOT_RD( 2 ) and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 20 ) <= NOT_RD( 0 ) and NOT_RD( 1 ) and rd( 2 )     and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 21 ) <= rd( 0 )     and NOT_RD( 1 ) and rd( 2 )     and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 22 ) <= NOT_RD( 0 ) and rd( 1 )     and rd( 2 )     and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 23 ) <= rd( 0 )     and rd( 1 )     and rd( 2 )     and NOT_RD( 3 ) and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 24 ) <= NOT_RD( 0 ) and NOT_RD( 1 ) and NOT_RD( 2 ) and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 25 ) <= rd( 0 )     and NOT_RD( 1 ) and NOT_RD( 2 ) and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 26 ) <= NOT_RD( 0 ) and rd( 1 )     and NOT_RD( 2 ) and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 27 ) <= rd( 0 )     and rd( 1 )     and NOT_RD( 2 ) and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 28 ) <= NOT_RD( 0 ) and NOT_RD( 1 ) and rd( 2 )     and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 29 ) <= rd( 0 )     and NOT_RD( 1 ) and rd( 2 )     and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 30 ) <= NOT_RD( 0 ) and rd( 1 )     and rd( 2 )     and rd( 3 )     and rd( 4 )     and write_enable;
      WRITE_REG_SELECT( 31 ) <= rd( 0 )     and rd( 1 )     and rd( 2 )     and rd( 3 )     and rd( 4 )     and write_enable;

      --とりあえずアドレス線の比較
      loop_address_comp_rt : for I in 0 to 4 generate

        ADDRESS_CMP_RT( I ) <= not ( rt( I ) xor rd( I ) );

      end generate loop_address_comp_rt;

      
      Loop_address_comp_rs : for I in 0 to 4 generate

        ADDRESS_CMP_RS( I ) <= not ( rs( I ) xor rd( I ) );

      end generate loop_address_comp_rs;

      
      --ADDRESS_CONSISTENT_RT と ADDRESS_CONSISTENT_RS のどちらかでも １ になっていれば
      --WBステージで書き込み要求が来たデータを読出そうとしていることになる。
            ENABLE_CHECK_RT <= ADDRESS_CMP_RT( 0 ) and
                               ADDRESS_CMP_RT( 1 ) and
                               ADDRESS_CMP_RT( 2 ) and
                               ADDRESS_CMP_RT( 3 ) and
                               ADDRESS_CMP_RT( 4 );
      
            ENABLE_CHECK_RS <= ADDRESS_CMP_RS( 0 ) and
                               ADDRESS_CMP_RS( 1 ) and
                               ADDRESS_CMP_RS( 2 ) and
                               ADDRESS_CMP_RS( 3 ) and
                               ADDRESS_CMP_RS( 4 );

      --更にこれでは書き込み要求がないときにゴミのアドレスと一致してしまうかもしれないので
      --万一のために write_enable の確認もする。

      --レジスタアドレス０の指定した場合で かつ WBステージでレジスタ０にゴミの値を捨てようとした場合に
      --ゴミを拾ってしまうので、「レジスタアドレスが０でない」という条件も追加する。
      REG_ADDR_ZERO_RT <= NOT_RT( 4 ) and  NOT_RT( 3 ) and  NOT_RT( 2 ) and  NOT_RT( 1 ) and  NOT_RT( 0 );
      NOT_REG_ADDR_ZERO_RT <= not REG_ADDR_ZERO_RT;      
      REG_ADDR_ZERO_RS <= NOT_RS( 4 ) and  NOT_RS( 3 ) and  NOT_RS( 2 ) and  NOT_RS( 1 ) and  NOT_RS( 0 );
      NOT_REG_ADDR_ZERO_RS <= not REG_ADDR_ZERO_RS;

      ADDRESS_CONSISTENT_RT <= ENABLE_CHECK_RT and NOT_REG_ADDR_ZERO_RT and write_enable and '0';
      ADDRESS_CONSISTENT_RS <= ENABLE_CHECK_RS and NOT_REG_ADDR_ZERO_RS and write_enable and '0';

      --レジスタに記録されているデータを通す場合に反転信号をつくる。
      NOT_AC_RT <= not ADDRESS_CONSISTENT_RT;
      NOT_AC_RS <= not ADDRESS_CONSISTENT_RS;


      --出口(rt_out)の直前でWBを感知してwrite_dataかレジスタのアウトプットを出力するか判断する。
      loop5 : for I in 0 to 31 generate
      
        SELECT_RT_WB_OR_ID( I ) <= ADDRESS_CONSISTENT_RT and write_data( I );

      end generate loop5;


      loop6 : for I in 32 to 63 generate
      
        SELECT_RT_WB_OR_ID( I ) <= NOT_AC_RT and INTERIM_RT_OUT( I - 32 );

      end generate loop6;


      loop7 : for I in 0 to 31 generate
      
        rt_out( I ) <= SELECT_RT_WB_OR_ID( I ) or SELECT_RT_WB_OR_ID( I + 32 );

      end generate loop7;


      
      --出口(rs_out)の直前でWBを感知してwrite_dataかレジスタのアウトプットを出力するか判断する。
      loop8 : for I in 0 to 31 generate
      
        SELECT_RS_WB_OR_ID( I ) <= ADDRESS_CONSISTENT_RS and write_data( I );

      end generate loop8;


      loop9 : for I in 32 to 63 generate
      
        SELECT_RS_WB_OR_ID( I ) <= NOT_AC_RS and INTERIM_RS_OUT( I - 32 );

      end generate loop9;


      loop10 : for I in 0 to 31 generate
      
        rs_out( I ) <= SELECT_RS_WB_OR_ID( I ) or SELECT_RS_WB_OR_ID( I + 32 );

      end generate loop10;

      
end RTL;