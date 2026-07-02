library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use STD.TEXTIO.all;
use IEEE.std_logic_textio.all;

entity ROM32 is
  	generic (C_MEM_BANK		: std_logic := '0';		-- Memory Bank
		 C_MEM_INIT_FILE	: string  := "program.rom");	-- HEX File name  
	port(	CLK	: in	std_logic;
		CS	: in	std_logic;
		RD	: in	std_logic;
		ADR	: in	std_logic_vector(17 downto 0);
		ODATA	: out	std_logic_vector(31 downto 0) );
end ROM32;

architecture ROM32_RTL of ROM32 is

constant	c_ADDR_SIZE	:integer := 262144;	-- addr 16bit = 65536 
constant	c_CHAR_WIDTH	:integer := 8;
constant	c_NUM_INST	:integer := 12;

subtype RAMWORD is integer;
type RAMARRY is array(0 to 262143) of RAMWORD;

signal RAMDATA		: RAMARRY;
signal address		: integer range 0 to c_ADDR_SIZE-1;
signal read_str		: STRING(8 downto 1);
signal tmp_read_data    : std_logic_vector(31 downto 0);

begin

	process
		variable hexline		: line;
		variable mem_vector		: STRING(c_CHAR_WIDTH downto 1);
	        FILE	 meminitfile            : TEXT is C_MEM_INIT_FILE;	
		variable tmp_dat0		: integer;
		variable tmp_dat1		: integer;
		variable tmp_dat2		: integer;
		variable tmp_dat3		: integer;
		variable tmp_dat4		: integer;
		variable tmp_dat5		: integer;
		variable tmp_dat6		: integer;
		variable tmp_dat7		: integer;
	begin
			----------------------------------------------
			-- Memory init read
			----------------------------------------------
			for i_adr in 0 to 15 loop
				if( C_MEM_BANK = '0')then
					report "load";
					readline(meminitfile, hexline);
					read(hexline,mem_vector);
					read_str	<= mem_vector;

					case (mem_vector(1)) is
						when	'0'	=>	tmp_dat0	:= 		0;
						when	'1'	=>	tmp_dat0	:= 		1;
						when	'2'	=>	tmp_dat0	:= 		2;
						when	'3'	=>	tmp_dat0	:= 		3;
						when	'4'	=>	tmp_dat0	:= 		4;
						when	'5'	=>	tmp_dat0	:= 		5;
						when	'6'	=>	tmp_dat0	:= 		6;
						when	'7'	=>	tmp_dat0	:= 		7;
						when	'8'	=>	tmp_dat0	:= 		8;
						when	'9'	=>	tmp_dat0	:= 		9;
						when	'a'	=>	tmp_dat0	:= 		10;
						when	'b'	=>	tmp_dat0	:= 		11;
						when	'c'	=>	tmp_dat0	:= 		12;
						when	'd'	=>	tmp_dat0	:= 		13;
						when	'e'	=>	tmp_dat0	:= 		14;
						when	'f'	=>	tmp_dat0	:= 		15;
						when	'A'	=>	tmp_dat0	:= 		10;
						when	'B'	=>	tmp_dat0	:= 		11;
						when	'C'	=>	tmp_dat0	:= 		12;
						when	'D'	=>	tmp_dat0	:= 		13;
						when	'E'	=>	tmp_dat0	:= 		14;
						when	'F'	=>	tmp_dat0	:= 		15;
						when others	=>	tmp_dat0	:= 		0;
					end case;

					case (mem_vector(2)) is
						when	'0'	=>	tmp_dat1	:= 		0;
						when	'1'	=>	tmp_dat1	:= 		1;
						when	'2'	=>	tmp_dat1	:= 		2;
						when	'3'	=>	tmp_dat1	:= 		3;
						when	'4'	=>	tmp_dat1	:= 		4;
						when	'5'	=>	tmp_dat1	:= 		5;
						when	'6'	=>	tmp_dat1	:= 		6;
						when	'7'	=>	tmp_dat1	:= 		7;
						when	'8'	=>	tmp_dat1	:= 		8;
						when	'9'	=>	tmp_dat1	:= 		9;
						when	'a'	=>	tmp_dat1	:= 		10;
						when	'b'	=>	tmp_dat1	:= 		11;
						when	'c'	=>	tmp_dat1	:= 		12;
						when	'd'	=>	tmp_dat1	:= 		13;
						when	'e'	=>	tmp_dat1	:= 		14;
						when	'f'	=>	tmp_dat1	:= 		15;
						when	'A'	=>	tmp_dat1	:= 		10;
						when	'B'	=>	tmp_dat1	:= 		11;
						when	'C'	=>	tmp_dat1	:= 		12;
						when	'D'	=>	tmp_dat1	:= 		13;
						when	'E'	=>	tmp_dat1	:= 		14;
						when	'F'	=>	tmp_dat1	:= 		15;
						when others	=>	tmp_dat1	:= 		0;
					end case;

					case (mem_vector(3)) is
						when	'0'	=>	tmp_dat2	:= 		0;
						when	'1'	=>	tmp_dat2	:= 		1;
						when	'2'	=>	tmp_dat2	:= 		2;
						when	'3'	=>	tmp_dat2	:= 		3;
						when	'4'	=>	tmp_dat2	:= 		4;
						when	'5'	=>	tmp_dat2 	:= 		5;
						when	'6'	=>	tmp_dat2	:= 		6;
						when	'7'	=>	tmp_dat2	:= 		7;
						when	'8'	=>	tmp_dat2	:= 		8;
						when	'9'	=>	tmp_dat2	:= 		9;
						when	'a'	=>	tmp_dat2	:= 		10;
						when	'b'	=>	tmp_dat2	:= 		11;
						when	'c'	=>	tmp_dat2	:= 		12;
						when	'd'	=>	tmp_dat2	:= 		13;
						when	'e'	=>	tmp_dat2	:= 		14;
						when	'f'	=>	tmp_dat2	:= 		15;
						when	'A'	=>	tmp_dat2	:= 		10;
						when	'B'	=>	tmp_dat2	:= 		11;
						when	'C'	=>	tmp_dat2	:= 		12;
						when	'D'	=>	tmp_dat2	:= 		13;
						when	'E'	=>	tmp_dat2	:= 		14;
						when	'F'	=>	tmp_dat2	:= 		15;
						when others	=>	tmp_dat2	:= 		0;
					end case;

					case (mem_vector(4)) is
						when	'0'	=>	tmp_dat3	:= 		0;
						when	'1'	=>	tmp_dat3	:= 		1;
						when	'2'	=>	tmp_dat3	:= 		2;
						when	'3'	=>	tmp_dat3	:= 		3;
						when	'4'	=>	tmp_dat3	:= 		4;
						when	'5'	=>	tmp_dat3	:= 		5;
						when	'6'	=>	tmp_dat3	:= 		6;
						when	'7'	=>	tmp_dat3	:= 		7;
						when	'8'	=>	tmp_dat3	:= 		8;
						when	'9'	=>	tmp_dat3	:= 		9;
						when	'a'	=>	tmp_dat3	:= 		10;
						when	'b'	=>	tmp_dat3	:= 		11;
						when	'c'	=>	tmp_dat3	:= 		12;
						when	'd'	=>	tmp_dat3	:= 		13;
						when	'e'	=>	tmp_dat3	:= 		14;
						when	'f'	=>	tmp_dat3	:= 		15;
						when	'A'	=>	tmp_dat3	:= 		10;
						when	'B'	=>	tmp_dat3	:= 		11;
						when	'C'	=>	tmp_dat3	:= 		12;
						when	'D'	=>	tmp_dat3	:= 		13;
						when	'E'	=>	tmp_dat3	:= 		14;
						when	'F'	=>	tmp_dat3	:= 		15;
						when others	=>	tmp_dat3	:= 		0;
					end case;

					case (mem_vector(5)) is
						when	'0'	=>	tmp_dat4	:= 		0;
						when	'1'	=>	tmp_dat4	:= 		1;
						when	'2'	=>	tmp_dat4	:= 		2;
						when	'3'	=>	tmp_dat4	:= 		3;
						when	'4'	=>	tmp_dat4	:= 		4;
						when	'5'	=>	tmp_dat4	:= 		5;
						when	'6'	=>	tmp_dat4	:= 		6;
						when	'7'	=>	tmp_dat4	:= 		7;
						when	'8'	=>	tmp_dat4	:= 		8;
						when	'9'	=>	tmp_dat4	:= 		9;
						when	'a'	=>	tmp_dat4	:= 		10;
						when	'b'	=>	tmp_dat4	:= 		11;
						when	'c'	=>	tmp_dat4	:= 		12;
						when	'd'	=>	tmp_dat4	:= 		13;
						when	'e'	=>	tmp_dat4	:= 		14;
						when	'f'	=>	tmp_dat4	:= 		15;
						when	'A'	=>	tmp_dat4	:= 		10;
						when	'B'	=>	tmp_dat4	:= 		11;
						when	'C'	=>	tmp_dat4	:= 		12;
						when	'D'	=>	tmp_dat4	:= 		13;
						when	'E'	=>	tmp_dat4	:= 		14;
						when	'F'	=>	tmp_dat4	:= 		15;
						when others	=>	tmp_dat4	:= 		0;
					end case;

					case (mem_vector(6)) is
						when	'0'	=>	tmp_dat5	:= 		0;
						when	'1'	=>	tmp_dat5	:= 		1;
						when	'2'	=>	tmp_dat5	:= 		2;
						when	'3'	=>	tmp_dat5	:= 		3;
						when	'4'	=>	tmp_dat5	:= 		4;
						when	'5'	=>	tmp_dat5	:= 		5;
						when	'6'	=>	tmp_dat5	:= 		6;
						when	'7'	=>	tmp_dat5	:= 		7;
						when	'8'	=>	tmp_dat5	:= 		8;
						when	'9'	=>	tmp_dat5	:= 		9;
						when	'a'	=>	tmp_dat5	:= 		10;
						when	'b'	=>	tmp_dat5	:= 		11;
						when	'c'	=>	tmp_dat5	:= 		12;
						when	'd'	=>	tmp_dat5	:= 		13;
						when	'e'	=>	tmp_dat5	:= 		14;
						when	'f'	=>	tmp_dat5	:= 		15;
						when	'A'	=>	tmp_dat5	:= 		10;
						when	'B'	=>	tmp_dat5	:= 		11;
						when	'C'	=>	tmp_dat5	:= 		12;
						when	'D'	=>	tmp_dat5	:= 		13;
						when	'E'	=>	tmp_dat5	:= 		14;
						when	'F'	=>	tmp_dat5	:= 		15;
						when others	=>	tmp_dat5	:= 		0;
					end case;

					case (mem_vector(7)) is
						when	'0'	=>	tmp_dat6	:= 		0;
						when	'1'	=>	tmp_dat6	:= 		1;
						when	'2'	=>	tmp_dat6	:= 		2;
						when	'3'	=>	tmp_dat6	:= 		3;
						when	'4'	=>	tmp_dat6	:= 		4;
						when	'5'	=>	tmp_dat6	:= 		5;
						when	'6'	=>	tmp_dat6	:= 		6;
						when	'7'	=>	tmp_dat6	:= 		7;
						when	'8'	=>	tmp_dat6	:= 		8;
						when	'9'	=>	tmp_dat6	:= 		9;
						when	'a'	=>	tmp_dat6	:= 		10;
						when	'b'	=>	tmp_dat6	:= 		11;
						when	'c'	=>	tmp_dat6	:= 		12;
						when	'd'	=>	tmp_dat6	:= 		13;
						when	'e'	=>	tmp_dat6	:= 		14;
						when	'f'	=>	tmp_dat6	:= 		15;
						when	'A'	=>	tmp_dat6	:= 		10;
						when	'B'	=>	tmp_dat6	:= 		11;
						when	'C'	=>	tmp_dat6	:= 		12;
						when	'D'	=>	tmp_dat6	:= 		13;
						when	'E'	=>	tmp_dat6	:= 		14;
						when	'F'	=>	tmp_dat6	:= 		15;
						when others	=>	tmp_dat6	:= 		0;
					end case;

					case (mem_vector(8)) is
						when	'0'	=>	tmp_dat7	:= 		0;
						when	'1'	=>	tmp_dat7	:= 		1;
						when	'2'	=>	tmp_dat7	:= 		2;
						when	'3'	=>	tmp_dat7	:= 		3;
						when	'4'	=>	tmp_dat7	:= 		4;
						when	'5'	=>	tmp_dat7	:= 		5;
						when	'6'	=>	tmp_dat7	:= 		6;
						when	'7'	=>	tmp_dat7	:= 		7;
						when	'8'	=>	tmp_dat7	:= 		8;
						when	'9'	=>	tmp_dat7	:= 		9;
						when	'a'	=>	tmp_dat7	:= 		10;
						when	'b'	=>	tmp_dat7	:= 		11;
						when	'c'	=>	tmp_dat7	:= 		12;
						when	'd'	=>	tmp_dat7	:= 		13;
						when	'e'	=>	tmp_dat7	:= 		14;
						when	'f'	=>	tmp_dat7	:= 		15;
						when	'A'	=>	tmp_dat7	:= 		10;
						when	'B'	=>	tmp_dat7	:= 		11;
						when	'C'	=>	tmp_dat7	:= 		12;
						when	'D'	=>	tmp_dat7	:= 		13;
						when	'E'	=>	tmp_dat7	:= 		14;
						when	'F'	=>	tmp_dat7	:= 		15;
						when others	=>	tmp_dat7	:= 		0;
					end case;

					RAMDATA(i_adr)	<= 		(tmp_dat7 * 268435456)
										  + (tmp_dat6 * 16777216)
										  + (tmp_dat5 * 1048576)
										  + (tmp_dat4 * 65536)
										  + (tmp_dat3 * 4096)
										  + (tmp_dat2 * 256)
										  + (tmp_dat1 * 16)
										  + tmp_dat0;
				else
					case (mem_vector(1)) is
						when	'0'	=>	tmp_dat0	:= 		0;
						when	'1'	=>	tmp_dat0	:= 		1;
						when	'2'	=>	tmp_dat0	:= 		2;
						when	'3'	=>	tmp_dat0	:= 		3;
						when	'4'	=>	tmp_dat0	:= 		4;
						when	'5'	=>	tmp_dat0	:= 		5;
						when	'6'	=>	tmp_dat0	:= 		6;
						when	'7'	=>	tmp_dat0	:= 		7;
						when	'8'	=>	tmp_dat0	:= 		8;
						when	'9'	=>	tmp_dat0	:= 		9;
						when	'a'	=>	tmp_dat0	:= 		10;
						when	'b'	=>	tmp_dat0	:= 		11;
						when	'c'	=>	tmp_dat0	:= 		12;
						when	'd'	=>	tmp_dat0	:= 		13;
						when	'e'	=>	tmp_dat0	:= 		14;
						when	'f'	=>	tmp_dat0	:= 		15;
						when	'A'	=>	tmp_dat0	:= 		10;
						when	'B'	=>	tmp_dat0	:= 		11;
						when	'C'	=>	tmp_dat0	:= 		12;
						when	'D'	=>	tmp_dat0	:= 		13;
						when	'E'	=>	tmp_dat0	:= 		14;
						when	'F'	=>	tmp_dat0	:= 		15;
						when others	=>	tmp_dat0	:= 		0;
					end case;

					case (mem_vector(2)) is
						when	'0'	=>	tmp_dat1	:= 		0;
						when	'1'	=>	tmp_dat1	:= 		1;
						when	'2'	=>	tmp_dat1	:= 		2;
						when	'3'	=>	tmp_dat1	:= 		3;
						when	'4'	=>	tmp_dat1	:= 		4;
						when	'5'	=>	tmp_dat1	:= 		5;
						when	'6'	=>	tmp_dat1	:= 		6;
						when	'7'	=>	tmp_dat1	:= 		7;
						when	'8'	=>	tmp_dat1	:= 		8;
						when	'9'	=>	tmp_dat1	:= 		9;
						when	'a'	=>	tmp_dat1	:= 		10;
						when	'b'	=>	tmp_dat1	:= 		11;
						when	'c'	=>	tmp_dat1	:= 		12;
						when	'd'	=>	tmp_dat1	:= 		13;
						when	'e'	=>	tmp_dat1	:= 		14;
						when	'f'	=>	tmp_dat1	:= 		15;
						when	'A'	=>	tmp_dat1	:= 		10;
						when	'B'	=>	tmp_dat1	:= 		11;
						when	'C'	=>	tmp_dat1	:= 		12;
						when	'D'	=>	tmp_dat1	:= 		13;
						when	'E'	=>	tmp_dat1	:= 		14;
						when	'F'	=>	tmp_dat1	:= 		15;
						when others	=>	tmp_dat1	:= 		0;
					end case;

					case (mem_vector(3)) is
						when	'0'	=>	tmp_dat2	:= 		0;
						when	'1'	=>	tmp_dat2	:= 		1;
						when	'2'	=>	tmp_dat2	:= 		2;
						when	'3'	=>	tmp_dat2	:= 		3;
						when	'4'	=>	tmp_dat2	:= 		4;
						when	'5'	=>	tmp_dat2 	:= 		5;
						when	'6'	=>	tmp_dat2	:= 		6;
						when	'7'	=>	tmp_dat2	:= 		7;
						when	'8'	=>	tmp_dat2	:= 		8;
						when	'9'	=>	tmp_dat2	:= 		9;
						when	'a'	=>	tmp_dat2	:= 		10;
						when	'b'	=>	tmp_dat2	:= 		11;
						when	'c'	=>	tmp_dat2	:= 		12;
						when	'd'	=>	tmp_dat2	:= 		13;
						when	'e'	=>	tmp_dat2	:= 		14;
						when	'f'	=>	tmp_dat2	:= 		15;
						when	'A'	=>	tmp_dat2	:= 		10;
						when	'B'	=>	tmp_dat2	:= 		11;
						when	'C'	=>	tmp_dat2	:= 		12;
						when	'D'	=>	tmp_dat2	:= 		13;
						when	'E'	=>	tmp_dat2	:= 		14;
						when	'F'	=>	tmp_dat2	:= 		15;
						when others	=>	tmp_dat2	:= 		0;
					end case;

					case (mem_vector(4)) is
						when	'0'	=>	tmp_dat3	:= 		0;
						when	'1'	=>	tmp_dat3	:= 		1;
						when	'2'	=>	tmp_dat3	:= 		2;
						when	'3'	=>	tmp_dat3	:= 		3;
						when	'4'	=>	tmp_dat3	:= 		4;
						when	'5'	=>	tmp_dat3	:= 		5;
						when	'6'	=>	tmp_dat3	:= 		6;
						when	'7'	=>	tmp_dat3	:= 		7;
						when	'8'	=>	tmp_dat3	:= 		8;
						when	'9'	=>	tmp_dat3	:= 		9;
						when	'a'	=>	tmp_dat3	:= 		10;
						when	'b'	=>	tmp_dat3	:= 		11;
						when	'c'	=>	tmp_dat3	:= 		12;
						when	'd'	=>	tmp_dat3	:= 		13;
						when	'e'	=>	tmp_dat3	:= 		14;
						when	'f'	=>	tmp_dat3	:= 		15;
						when	'A'	=>	tmp_dat3	:= 		10;
						when	'B'	=>	tmp_dat3	:= 		11;
						when	'C'	=>	tmp_dat3	:= 		12;
						when	'D'	=>	tmp_dat3	:= 		13;
						when	'E'	=>	tmp_dat3	:= 		14;
						when	'F'	=>	tmp_dat3	:= 		15;
						when others	=>	tmp_dat3	:= 		0;
					end case;

					case (mem_vector(5)) is
						when	'0'	=>	tmp_dat4	:= 		0;
						when	'1'	=>	tmp_dat4	:= 		1;
						when	'2'	=>	tmp_dat4	:= 		2;
						when	'3'	=>	tmp_dat4	:= 		3;
						when	'4'	=>	tmp_dat4	:= 		4;
						when	'5'	=>	tmp_dat4	:= 		5;
						when	'6'	=>	tmp_dat4	:= 		6;
						when	'7'	=>	tmp_dat4	:= 		7;
						when	'8'	=>	tmp_dat4	:= 		8;
						when	'9'	=>	tmp_dat4	:= 		9;
						when	'a'	=>	tmp_dat4	:= 		10;
						when	'b'	=>	tmp_dat4	:= 		11;
						when	'c'	=>	tmp_dat4	:= 		12;
						when	'd'	=>	tmp_dat4	:= 		13;
						when	'e'	=>	tmp_dat4	:= 		14;
						when	'f'	=>	tmp_dat4	:= 		15;
						when	'A'	=>	tmp_dat4	:= 		10;
						when	'B'	=>	tmp_dat4	:= 		11;
						when	'C'	=>	tmp_dat4	:= 		12;
						when	'D'	=>	tmp_dat4	:= 		13;
						when	'E'	=>	tmp_dat4	:= 		14;
						when	'F'	=>	tmp_dat4	:= 		15;
						when others	=>	tmp_dat4	:= 		0;
					end case;

					case (mem_vector(6)) is
						when	'0'	=>	tmp_dat5	:= 		0;
						when	'1'	=>	tmp_dat5	:= 		1;
						when	'2'	=>	tmp_dat5	:= 		2;
						when	'3'	=>	tmp_dat5	:= 		3;
						when	'4'	=>	tmp_dat5	:= 		4;
						when	'5'	=>	tmp_dat5	:= 		5;
						when	'6'	=>	tmp_dat5	:= 		6;
						when	'7'	=>	tmp_dat5	:= 		7;
						when	'8'	=>	tmp_dat5	:= 		8;
						when	'9'	=>	tmp_dat5	:= 		9;
						when	'a'	=>	tmp_dat5	:= 		10;
						when	'b'	=>	tmp_dat5	:= 		11;
						when	'c'	=>	tmp_dat5	:= 		12;
						when	'd'	=>	tmp_dat5	:= 		13;
						when	'e'	=>	tmp_dat5	:= 		14;
						when	'f'	=>	tmp_dat5	:= 		15;
						when	'A'	=>	tmp_dat5	:= 		10;
						when	'B'	=>	tmp_dat5	:= 		11;
						when	'C'	=>	tmp_dat5	:= 		12;
						when	'D'	=>	tmp_dat5	:= 		13;
						when	'E'	=>	tmp_dat5	:= 		14;
						when	'F'	=>	tmp_dat5	:= 		15;
						when others	=>	tmp_dat5	:= 		0;
					end case;

					case (mem_vector(7)) is
						when	'0'	=>	tmp_dat6	:= 		0;
						when	'1'	=>	tmp_dat6	:= 		1;
						when	'2'	=>	tmp_dat6	:= 		2;
						when	'3'	=>	tmp_dat6	:= 		3;
						when	'4'	=>	tmp_dat6	:= 		4;
						when	'5'	=>	tmp_dat6	:= 		5;
						when	'6'	=>	tmp_dat6	:= 		6;
						when	'7'	=>	tmp_dat6	:= 		7;
						when	'8'	=>	tmp_dat6	:= 		8;
						when	'9'	=>	tmp_dat6	:= 		9;
						when	'a'	=>	tmp_dat6	:= 		10;
						when	'b'	=>	tmp_dat6	:= 		11;
						when	'c'	=>	tmp_dat6	:= 		12;
						when	'd'	=>	tmp_dat6	:= 		13;
						when	'e'	=>	tmp_dat6	:= 		14;
						when	'f'	=>	tmp_dat6	:= 		15;
						when	'A'	=>	tmp_dat6	:= 		10;
						when	'B'	=>	tmp_dat6	:= 		11;
						when	'C'	=>	tmp_dat6	:= 		12;
						when	'D'	=>	tmp_dat6	:= 		13;
						when	'E'	=>	tmp_dat6	:= 		14;
						when	'F'	=>	tmp_dat6	:= 		15;
						when others	=>	tmp_dat6	:= 		0;
					end case;

					case (mem_vector(8)) is
						when	'0'	=>	tmp_dat7	:= 		0;
						when	'1'	=>	tmp_dat7	:= 		1;
						when	'2'	=>	tmp_dat7	:= 		2;
						when	'3'	=>	tmp_dat7	:= 		3;
						when	'4'	=>	tmp_dat7	:= 		4;
						when	'5'	=>	tmp_dat7	:= 		5;
						when	'6'	=>	tmp_dat7	:= 		6;
						when	'7'	=>	tmp_dat7	:= 		7;
						when	'8'	=>	tmp_dat7	:= 		8;
						when	'9'	=>	tmp_dat7	:= 		9;
						when	'a'	=>	tmp_dat7	:= 		10;
						when	'b'	=>	tmp_dat7	:= 		11;
						when	'c'	=>	tmp_dat7	:= 		12;
						when	'd'	=>	tmp_dat7	:= 		13;
						when	'e'	=>	tmp_dat7	:= 		14;
						when	'f'	=>	tmp_dat7	:= 		15;
						when	'A'	=>	tmp_dat7	:= 		10;
						when	'B'	=>	tmp_dat7	:= 		11;
						when	'C'	=>	tmp_dat7	:= 		12;
						when	'D'	=>	tmp_dat7	:= 		13;
						when	'E'	=>	tmp_dat7	:= 		14;
						when	'F'	=>	tmp_dat7	:= 		15;
						when others	=>	tmp_dat7	:= 		0;
					end case;

					RAMDATA(i_adr)	<= 		(tmp_dat7 * 268435456)
										  + (tmp_dat6 * 16777216)
										  + (tmp_dat5 * 1048576)
										  + (tmp_dat4 * 65536)
										  + (tmp_dat3 * 4096)
										  + (tmp_dat2 * 256)
										  + (tmp_dat1 * 16)
										  + tmp_dat0;

				end if;
			end loop;

			wait;

	 end process;

	address	<= CONV_INTEGER(ADR);

	ODATA	<= tmp_read_data when CS='1' and RD='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

	process( CLK ) begin
		if( CLK'event and CLK='0' ) then
			tmp_read_data	<=	CONV_std_logic_vector(RAMDATA(address),32);
		end if;
	end process;

end ROM32_RTL;
