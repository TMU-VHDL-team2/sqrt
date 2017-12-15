library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bB is
  port(S_GRB, S_PR_F, S_MAR_F, S_MDR_F : in std_logic_vector(15 downto 0);
       addr     : in std_logic_vector(7 downto 0);
       S_s_ctl  : in std_logic_vector(4 downto 0);
       S_BUS_B  : out std_logic_vector(15 downto 0));
end bB;

architecture BEHAVIOR of bB is
begin
  S_BUS_B <= S_GRB   when S_s_ctl = "10000"
    else     S_PR_F  when S_s_ctl = "01000"
    else     S_MAR_F when S_s_ctl = "00100"
    else     S_MDR_F when S_s_ctl = "00010"
    else     "00000000" & addr when S_s_ctl = "00001"
    else     "XXXXXXXXXXXXXXXX";
end BEHAVIOR;
