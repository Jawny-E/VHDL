--Bibliotek og pakker
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity exercise4 is
	--Portane er angitt frå øvingsguiden
	port(
		clk: in std_logic;
		rst_n : in std_logic;
		incr_key : in std_logic;
		sw0 : in std_logic;
		sw9 : in std_logic;
		Open_led : out std_logic;
		Seg_sel : in std_logic_vector(1 downto 0);
		hex0, hex1, hex2, hex3 : out std_logic_vector(7 downto 0)
	);
end entity;
	

architecture safe of exercise4 is
	--Denne funksjonen hentar inn ein 4-bits vektor(for tallet)
	-- og gir ut igjen bit-strengen som skal brukast til å sette
	-- tallet på 7-segment display
	pure function HexCode (inp: std_logic_vector(3 downto 0)) return std_logic_vector is
		begin
		case inp is
			when "0000" => --0
				return "11000000";
			when "0001" => -- 1
				return "11111001";
			when "0010" => -- 2
				return "10100100";
			when "0011" => -- 3
				return "10110000";
			when "0100" => -- 4
				return "10011001";
			when "0101" => -- 5
				return "10010010";
			when "0110" => -- 6
				return "10000010";
			when "0111" => -- 7
				return "11111000";
			when "1000" => -- 8
				return "10000000";
			when "1001" => -- 9
				return "10010000";
			when others =>
				return "00000000";
		end case;
	end function;
	
	--Signal og konstantar brukt 
	-- curr-tala er tal som holder den nåværande verdien som er lagt inn i koden
	-- code-tale er tilsvarande korrekt passord
	signal curr0, curr1, curr2, curr3 : std_logic_vector(3 downto 0) := "0000";
	signal rst_true : std_logic := '0';
	constant code0 : std_logic_vector(3 downto 0) := "0001";
	constant code1 : std_logic_vector(3 downto 0) := "0010";
	constant code2 : std_logic_vector(3 downto 0) := "0011";
	constant code3 : std_logic_vector(3 downto 0) := "0100";
	
-- Denne logikken blei brukt for å fikse fysisk timing
-- mistenker at timingen min ikkje matcher testbenk uansett
-- Men ja, bytt ut clk med clk_div seinare der eg sjekkar for knappetrykk :)
	signal clk_div : std_logic := '0';
   signal clk_counter : integer := 0;
   constant CLOCK_DIVISION_FACTOR : integer := 5000000; 
	begin
	
	process(clk)
		begin
		if rising_edge(clk) then
            if clk_counter = CLOCK_DIVISION_FACTOR - 1 then
                clk_div <= not clk_div;
                clk_counter <= 0;
            else
                clk_counter <= clk_counter + 1;
            end if;
        end if;
	end process;

	--Skulle kanskje delt alt her inni fleire ulike prosessar
	process(all)
		begin
		--RST logikk
		--Setter curr-tala til 0, og openled som angitt i oppgåvetekst
		-- rst_true blir brukt til å styre Open_led
		-- safen er åpen etter rst fram til første knappetrykk
		if rst_n = '0' then
			rst_true <= '1';
			curr0 <= "0000";
			curr1 <= "0000";
			curr2 <= "0000";
			curr3 <= "0000";

		
		--Logikk for knappetrykk
		--Byttet ut clk med clk_div for seinare køyring :)
		--Her har vi ein switch-case basert logikk
		--switch-casen bestemmer hvilket tall som skal endrast
		--dersom tallet allerede er 9 går vi tilbake til 0
		--ellers aukar vi med 1
		elsif rising_edge(clk_div) and incr_key = '0' then
			rst_true <= '0';
			case Seg_sel is
				when "00" =>
					if curr0 = "1001" then
						curr0 <= "0000";
					else
						curr0 <= std_logic_vector(to_unsigned(to_integer(unsigned(curr0)) + 1, 4));
					end if;
				when "01" =>
					if curr1 = "1001" then
						curr1 <= "0000";
					else
						curr1 <= std_logic_vector(to_unsigned(to_integer(unsigned(curr1)) + 1, 4));
					end if;
				when "10" =>
					if curr2 = "1001" then
						curr2 <= "0000";
					else
						curr2 <= std_logic_vector(to_unsigned(to_integer(unsigned(curr2)) + 1, 4));
					end if;
				when "11" =>
					if curr3 = "1001" then
						curr3 <= "0000";
					else
						curr3 <= std_logic_vector(to_unsigned(to_integer(unsigned(curr3)) + 1, 4));
					end if;
				when others =>
					null;
			end case;
		end if;
		
		--Logikk for LED-lys
		--Lyset er alltid av dersom sw0 er 1
		--Skrus på pm sw0 = 0 og curr-tala matcher code-tala
		if sw0 = '1'then
			Open_led <= '0';
		elsif rst_true = '1' then
			Open_led <= '1';
		else
			if (curr0 = code0) and (curr1 = code1)and (curr2 = code2)and (curr3 = code3) then
				Open_led <= '1';
			else
				Open_led <= '0';
			end if;
		end if;
		
		--Logikk for display-visning
		--Dersom sw9 = 1 skal passordet visast(bruker funksjon)
		--Ellers skal brukarens tall viast
		if sw9 = '1' then
			hex0 <= HexCode(code0);
			hex1 <= HexCode(code1);
			hex2 <= HexCode(code2);
			hex3 <= HexCode(code3);
		else
			hex0 <= HexCode(curr0);
			hex1 <= HexCode(curr1);
			hex2 <= HexCode(curr2);
			hex3 <= HexCode(curr3);
		end if;
	end process;
end safe;
