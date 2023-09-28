library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exercise 3 is
  port(
    clk : in std_logic;
    rst : in std_logic;
    data: in std_logic;
    seq_found : out std_logic;
  );
end entity exercise3;

architecture fsm of exercie3 is
  type state_type is (A, B, C, D, E)
  signal state: state_type;

  begin
  process(clk, rst)
      begin
      if rst then
          state <= A;
      elsif(rising_edge(clk))then
          case state is
              when A =>
                  if data then
                      state <= B;
                  else
                      state <= A;
                  end if;
              when B =>
                  if data then
                      state <= B;
                  else
                      state <= C;
                  end if;
              when C =>
                  if data then
                      state <= D;
                  else
                      state <= A;
                  end if;
              when D =>
                  if data then
                      state <= E;
                  else
                      state <= C;
                  end if;
              when E =>
                  if data then
                      state <= B;
                  else
                      state <= C;
                  end if;
              end case;
      end if;
  end process;

  process(all)
        begin
            case state is
                when E =>
                    seq_found <= '1';
                when others =>
                    seq_found <= '0';
  end process;
end architecture;
