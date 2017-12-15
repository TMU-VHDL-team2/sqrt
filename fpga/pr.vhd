library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pr is
  port(clk, S_PRlat, S_s_inc : in std_logic;
       S_BUS_C : in std_logic_vector(15 downto 0);
       S_PR_F : out std_logic_vector(15 downto 0));
end pr;

architecture BEHAVIOR of pr is

signal rst : std_logic_vector(15 downto 0) := "0000000010000000";

begin
  S_PR_F <= rst;
  process(clk) begin
    if clk'event and clk = '1' then
      if S_PRlat = '1' then
        rst <= S_BUS_C;
      elsif S_s_inc = '1' then
        rst <= rst + 1;
      else
        null;
      end if;
    end if;
  end process;
end BEHAVIOR;
