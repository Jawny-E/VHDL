library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity exercise5 is
	generic(
		F_CLK : integer := 50_000_000;
		T_CLK_PWM : integer := 120;
		BITS : integer := 3
	);
	port(
		clk, rstn : in std_logic;
		duty : in std_logic_vector(BITS-1 downto 0);
		pwm_out : out std_logic
	);
end entity exercise5;



architecture RTL of exercise5 is
	constant M : natural := integer(F_CLK*T_CLK_PWM);
	signal counter : natural range 0 to F_CLK-1;
	begin
	
	process(clk, rstn) is
	
	begin
		if rstn = '0' then
			counter <= 0;
			pwm_out <= '0';
		elsif rising_edge(clk) then
			if counter = M-1 then
				counter <= 0;
				pwm_out <= '1';
			else
				counter <= counter + 1;
				if counter < to_integer(unsigned(duty)) then
					pwm_out <= '1';
				else
					pwm_out <= '0';
				end if;
			end if;
		end if;
	end process;
	
end architecture;
