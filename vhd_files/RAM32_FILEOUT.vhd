library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use STD.TEXTIO.all;                     --テキスト入出力用ライブラリ
use IEEE.std_logic_textio.all;          --テキスト入出力に bit vector を使うために必要。

entity RAM32_FILEOUT is
  generic (
    OUTPUT_FILE : string  := "output.ram"		-- 出力ファイル名
    );
	port(
		CLK		: in	std_logic;
		CS		: in	std_logic;  --アクセスしたいときに１にする。
		RD		: in	std_logic;  --read enable
		WE		: in	std_logic_vector(3 downto 0);  -- 0:[7:0], 1:[15:8], 2:[23:16], 3:[31:24]
		ADR		: in	std_logic_vector(17 downto 0);
		IDATA           : in	std_logic_vector(31 downto 0);
                file_out        : in    std_logic; 
		dump_adr        : in    std_logic_vector(17 downto 0);
           	ODATA           : out	std_logic_vector(31 downto 0)
	  );
end RAM32_FILEOUT;

architecture RAM32_RTL of RAM32_FILEOUT is

constant	c_ADDR_SIZE		: integer := 262144;	-- addr 16bit = 65536
constant        ADDR_BUS_WIDTH          : integer := 18;

subtype RAMWORD0 is integer;
type RAMARRY0 is array(0 to 262143) of RAMWORD0;
subtype RAMWORD1 is integer;
type RAMARRY1 is array(0 to 262143) of RAMWORD1;
subtype RAMWORD2 is integer;
type RAMARRY2 is array(0 to 262143) of RAMWORD2;
subtype RAMWORD3 is integer;
type RAMARRY3 is array(0 to 262143) of RAMWORD3;

signal RAMDATA0		: RAMARRY0;
signal RAMDATA1		: RAMARRY1;
signal RAMDATA2		: RAMARRY2;
signal RAMDATA3		: RAMARRY3;
signal address          : integer range 0 to c_ADDR_SIZE-1;
signal dump_address     : integer range 0 to c_ADDR_SIZE-1;
signal tmp_read_data    : std_logic_vector(31 downto 0);
signal dump_read_data    : std_logic_vector(31 downto 0);

signal WRITE_ADDR       : std_logic_vector( 17 downto 0 );
signal RAM_DATA         : std_logic_vector( 31 downto 0 );
signal READ_OR          : std_logic;
signal READ_ADDR        : std_logic_vector( 19 downto 0 );

begin

READ_OR <= RD or file_out;

  dump_address	<= CONV_INTEGER(dump_adr);

  dump_read_data( 7 downto  0)	<=	CONV_std_logic_vector(RAMDATA0(dump_address),8);
  dump_read_data(15 downto  8)	<=	CONV_std_logic_vector(RAMDATA1(dump_address),8);
  dump_read_data(23 downto 16)	<=	CONV_std_logic_vector(RAMDATA2(dump_address),8);
  dump_read_data(31 downto 24)	<=	CONV_std_logic_vector(RAMDATA3(dump_address),8);

  READ_ADDR <= CONV_std_logic_vector(dump_address * 4 , ADDR_BUS_WIDTH + 2);

  process(CLK)

    variable LO : line;
    file outvector : TEXT open write_mode is OUTPUT_FILE;  --ファイル変数 outvector の定義

          begin

            if( CLK'event and CLK = '1' ) then


              --昇順書出し指定時のファイル書き込み
              if ( file_out = '1' ) then
                
                --アドレスの書き込み
                hwrite( LO,READ_ADDR( 19 downto 16 ),LEFT ,1 );
                hwrite( LO,READ_ADDR( 15 downto 12 ),LEFT ,1 );
                hwrite( LO,READ_ADDR( 11 downto 8 ) ,LEFT ,1 );
                hwrite( LO,READ_ADDR( 7 downto 4 )  ,LEFT ,1 );
                hwrite( LO,READ_ADDR( 3 downto 0 )  ,LEFT ,3 );
                
                --Little Endianでのメモリ内容
                hwrite( LO,dump_read_data( 31 downto 28 ),LEFT,1 );
                hwrite( LO,dump_read_data( 27 downto 24 ),LEFT,2 );
                hwrite( LO,dump_read_data( 23 downto 20 ),LEFT,1 );
                hwrite( LO,dump_read_data( 19 downto 16 ),LEFT,2 );
                hwrite( LO,dump_read_data( 15 downto 12 ),LEFT,1 );
                hwrite( LO,dump_read_data( 11 downto 8 ),LEFT,2 );
                hwrite( LO,dump_read_data( 7 downto 4 ),LEFT,1 );
                hwrite( LO,dump_read_data( 3 downto 0 ),LEFT,2 );

                --ライン書き込み
                writeline( outvector,LO );

              end if;
            end if;

  end process;

      
-------------------------------------------------------------------------------
-- メモリ部
-------------------------------------------------------------------------------
  
	address	<= CONV_INTEGER(ADR) when file_out = '0' else CONV_INTEGER( WRITE_ADDR );

	-- Write
	process( CLK )begin
		if( CLK'event and CLK='1' ) then
			if( CS='1')then
				Report "Write for Data Memory!";
				if( WE(3)= '1')then
					RAMDATA0(address)	<=	CONV_INTEGER(IDATA(7 downto 0));
				end if;
				if( WE(2)= '1')then
					RAMDATA1(address)	<=	CONV_INTEGER(IDATA(15 downto 8));
				end if;
				if( WE(1)= '1')then
					RAMDATA2(address)	<=	CONV_INTEGER(IDATA(23 downto 16));
				end if;
				if( WE(0)= '1')then
					RAMDATA3(address)	<=      CONV_INTEGER(IDATA(31 downto 24));
				end if;
			end if;
		end if;
	end process;

	-- Read
	ODATA	<= tmp_read_data when CS='1' and READ_OR='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

	process( CLK,address ) begin
		--if( CLK'event and CLK='1' ) then 
			if (address = 0) then
				tmp_read_data <= CONV_std_logic_vector(100,32);
			elsif (address = 1) then
				tmp_read_data <= CONV_std_logic_vector(1,32);
			else
				tmp_read_data( 7 downto  0)	<=	CONV_std_logic_vector(RAMDATA0(address),8);
				tmp_read_data(15 downto  8)	<=	CONV_std_logic_vector(RAMDATA1(address),8);
				tmp_read_data(23 downto 16)	<=	CONV_std_logic_vector(RAMDATA2(address),8);
				tmp_read_data(31 downto 24)	<=	CONV_std_logic_vector(RAMDATA3(address),8);
			end if;
		--end if;
	end process;

end RAM32_RTL;
