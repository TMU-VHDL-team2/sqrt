library ieee; 
use ieee.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
entity inst is  
     port( 
         clock : in std_logic; 
         busA  : in std_logic_vector(15 downto 0); 
         latch : in std_logic;  
         Mlang : out std_logic_vector(15 downto 0)
     ); 
end inst;

architecture BEHAVIOR of inst is

signal data : std_logic_vector(15 downto 0);

begin 
    Mlang <= data;

    process(clock) begin
        if(clock'event and clock = '1')then
            if(latch = '1')then
                data <= busA;
            else
                null;
            end if;
        else
            null;
        end if;
    end process;
end BEHAVIOR; 
