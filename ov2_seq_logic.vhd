library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ov2 is
	port(
	clk : in std_logic;
	rst : in std_logic;
	ena : in std_logic;
	cnt_sel : in std_logic;
	count: out std_logic_vector(9 downto 0)
	);
end entity;


architecture test of ov2 is
	signal cnt: std_logic_vector(9 downto 0);
begin
	process(clk, ena, rst, cnt_sel)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				cnt <= "0000000001";
			elsif ena = '1' then
				if cnt_sel = '1' then
					--lfsr
					cnt(9 downto 1) <= cnt(8 downto 0);
					cnt(0) <= cnt(9) XOR cnt(6) XOR cnt(0);
				elsif cnt_sel = '0' then
					--Binary
					cnt <= std_logic_vector(signed(cnt) + 1);
				end if;
			end if;
		end if; 
		count <= cnt;
	end process;
end architecture;
