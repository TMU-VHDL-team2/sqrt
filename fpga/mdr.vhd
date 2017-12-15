library ieee; 
use ieee.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
 
 
entity mdr is  
     port( 
         clock : in std_logic; 
         busC  : in std_logic_vector(15 downto 0); 
         latch : in std_logic;  
         memo  : in std_logic_vector(15 downto 0);
         sel   : in std_logic;  
         data  : out std_logic_vector(15 downto 0)
     ); 
end mdr;

architecture BEHAVIOR of mdr is
 



begin 

process(clock) begin
      if(clock'event and clock = '1')then
          if(latch = '1')then
              if(sel = '0')then
                data <= busC;
              elsif(sel = '1')then
                data <= memo;
              else
                null;
              end if;
           else
             null;
           end if;
        else
          null;
        end if;
      end process;

end BEHAVIOR; 
