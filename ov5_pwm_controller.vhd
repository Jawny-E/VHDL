library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity exercise5 is
	--Henta frå oppgåva
	--Deler på 1000 seinare for å konvertere til ns
	generic(
		F_CLK : natural := 50;-- MHz
		T_CLK_PWM : natural := 60; --ns
		BITS : integer := 3
	);
	--Porter prosjektet trenger
	port(
		clk, rstn : in std_logic;
		duty : in std_logic_vector(BITS-1 downto 0);
		pwm_out : out std_logic
	);
end entity exercise5;



architecture RTL of exercise5 is

	constant M : natural := (F_CLK*T_CLK_PWM/1_000); --Forhald mellom klokke-original og klokke-pwm
	signal clk_pwm : std_logic; --Signal generert etter klokkedivisjon
	signal counterM : natural range 0 to M; --Counter til klokkedivisjon
	signal counterPWM : natural range 0 to (2**BITS - 2); --Counter for PWM

	
	begin
	
	--Denne prosessen er klokkedivisjon og gir 
	--singalet clk_pwm som resultat
	process(clk, rstn) is
	begin
		if rstn = '0' then
			counterM <= 0;
			clk_pwm <= '0';	
		elsif rising_edge(clk) then
			if counterM = M-1 then
				counterM <= 0;
				clk_pwm <= not clk_pwm;
			else
				counterM <= counterM + 1;
			end if;
		end if;
	end process;
	
	--Denne prosessen handterar pwm-kontroll
	--gitt signalet clk_pwm
	process(clk_pwm) is
	begin
		if rising_edge(clk_pwm)then
			if counterPWM = 2**BITS - 2 then
				counterPWM <= 0;
				pwm_out <= '0';
			else
				counterPWM <= counterPWM + 1;
				if counterPWM > to_integer(unsigned(duty)) then
					pwm_out <= '1';
				else 
					pwm_out <= '0';
				end if;
			end if;
		end if;
	end process;
	
end architecture;
