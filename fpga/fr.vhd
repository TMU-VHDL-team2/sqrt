library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity fr is
    port(
        clk   : in std_logic;
        latch : in std_logic;
        inZF  : in std_logic;
        inSF  : in std_logic;
        inOF  : in std_logic;
        outZF : out std_logic;
        outSF : out std_logic;
        outOF : out std_logic
    );
end fr;

architecture BEHAVIOR of fr is

-- Definitions --
signal ZFG    : std_logic;
signal SFG    : std_logic;
signal OFG    : std_logic;

-- Main --
begin
    process(clk) begin
        if(clk'event and (clk = '1') and (latch = '1')) then
            ZFG <= inZF;
            SFG <= inSF;
            OFG <= inOF;
        else
            null;
        end if;
    end process;
    
    outZF <= ZFG;
    outSF <= SFG;
    outOF <= OFG;
    
end BEHAVIOR;

