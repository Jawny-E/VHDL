--Importerar og brukar bibliotek
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Setter opp portene til prosjektet
entity exercise1 is
	port(
		a			: in std_logic_vector(3 downto 0);
		b			: in std_logic_vector(3 downto 0);
		op_code	: in std_logic_vector(3 downto 0);
		result	: out std_logic_vector(3 downto 0)
	);
end exercise1;

--Setter opp akritekturen 
architecture test of exercise1 is
	begin
	--Bruker select for å bestemme funksjonaliteten til programmet
	with op_code select
		result <=(not a) when"0000",
					(not b) when "0001",
					(a and b) when "0010",
					(a or b) when "0011",
					(a nand b) when "0100",
					(a nor b) when "0101",
					(a xor b) when "0110",
					(a xnor b) when "0111",
					a when "1000",
					b when "1001",
					std_logic_vector(signed(a) + 1) when "1010",
					std_logic_vector(signed(b) + 1) when "1011",
					std_logic_vector(signed(a) - 1) when  "1100",
					std_logic_vector(signed(a) - 1) when  "1101",
					std_logic_vector(signed(a) + signed(b)) when "1110",
					"0000" when others;
end test;
