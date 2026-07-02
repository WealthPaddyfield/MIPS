library IEEE;
use IEEE.std_logic_1164.all;


entity REG_EN_TTBIT is

  --32-bitデータ入力
  --en＝イネーブル（書き込み許可）信号線
  --clk_in = クロック入力
  --保持データおよび出力信号線
  Port( data_in : in std_logic_vector( 31 downto 0 ) ;
        en_in   : in std_logic ;
        clk_in  : in std_logic ;
        
        q       : out std_logic_vector( 31 downto 0 ));

end REG_EN_TTBIT;

architecture RTL of REG_EN_TTBIT is

  begin

    process( clk_in )
    begin

      --クロックに変化が起きて かつ クロックがが立ち上がり 
      if ( clk_in'event and  clk_in = '1' ) then

        --かつ イネーブルが１の時に。。。
        if ( en_in = '1' ) then

          --データを出力に反映する。
          q <= data_in;
 
        end if;

      end if;
        
   end process;

end  RTL;  
