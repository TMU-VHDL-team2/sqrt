library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity mem is
  port(clk, read, write : in std_logic;
       init_phase : in std_logic_vector(3 downto 0);
       input   : in std_logic_vector(15 downto 0);
       S_MAR_F : in std_logic_vector(7 downto 0);
       S_MDR_F : in std_logic_vector(15 downto 0);
       data : out std_logic_vector(15 downto 0));
end mem;

architecture BEHAVIOR of mem is

subtype RAM_WORD is std_logic_vector(15 downto 0);
type RAM_TYPE is array (0 to 255) of RAM_WORD;
impure function init_ram_file(RAM_FILE_NAME : in string) return RAM_TYPE is
file RAM_FILE : TEXT is in RAM_FILE_NAME;
variable RAM_FILE_LINE : line;
variable RAM_DIN : RAM_TYPE;
begin
  for I in RAM_TYPE'range loop
    readline(RAM_FILE, RAM_FILE_LINE);
    hread(RAM_FILE_LINE, RAM_DIN(I));
  end loop;
  return RAM_DIN;
end function;

signal RAM_DATA : RAM_TYPE := init_ram_file("mem_fpga.txt");
signal addr : std_logic_vector(7 downto 0);
signal a : std_logic_vector(7 downto 0);
signal d : std_logic_vector(15 downto 0);
signal w : std_logic;

begin
  a <= X"00" when (init_phase = X"1") else S_MAR_F;
  d <= input when (init_phase = X"1") else S_MDR_F;
  w <= '1'   when (init_phase = X"1") else write;
  data <= RAM_DATA(conv_integer(addr));

  process(clk) begin
    if clk'event and clk = '1' then
      if w = '1' then
        RAM_DATA(conv_integer(a)) <= d;
      elsif read = '1' then
        addr <= a;
      else
        null;
      end if;
    end if;
  end process;

end BEHAVIOR;
