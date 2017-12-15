library ieee;
use ieee.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 

---SI=[MDR,GR,ADDRESS]

entity busA is  
    port(          
	    clock: in std_logic;
	    MDR  : in std_logic_vector(15 downto 0);
	    GR   : in std_logic_vector(15 downto 0);
	    ADDR : in std_logic_vector( 7 downto 0);
	    SI   : in std_logic_vector( 2 downto 0);
	    busA_out : out std_logic_vector(15 downto 0)
	);
end busA; 

---architecture

architecture BEHAVIOR of busA is
begin
	busA_out <=  MDR               when SI = "001"
            else GR                when SI = "010"
            else "00000000" & ADDR when SI = "100"
            else "XXXXXXXXXXXXXXXX";
end BEHAVIOR;
