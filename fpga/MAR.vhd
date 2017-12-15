library ieee; 
 use ieee.std_logic_1164.all; 
 use IEEE.std_logic_unsigned.all; 
 
 
 entity MAR is  
     port( 
	clk, lat: in std_logic;
        busC : in std_logic_vector(15 downto 0); 
        M_ad16: out std_logic_vector(15 downto 0);
	M_ad8: out std_logic_vector(7 downto 0)
     ); 
 end MAR;
 
 
architecture BEHAVIOR of MAR is
	 signal rst:std_logic_vector(15 downto 0);
	begin
	M_ad16 <= rst;
	M_ad8 <= rst(7 downto 0);
process(clk)begin


	if (clk'event and (clk = '1') and (lat ='1'))  then 
       		rst <= busC; 

	else 
		null;
	end if;
end process;
end BEHAVIOR;


