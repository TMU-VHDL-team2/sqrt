library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity alu is 
    port(
        func : in std_logic_vector(3 downto 0);
        busA : in std_logic_vector(15 downto 0);
        busB : in std_logic_vector(15 downto 0);
        inZ  : in std_logic;
        inS  : in std_logic;
        inO  : in std_logic;
        outZ : out std_logic;
        outS : out std_logic;
        outO : out std_logic;
        busC : out std_logic_vector(15 downto 0)
    );
end alu;

architecture BEHAVIOR of alu is

-- Definitions --
signal ans      : std_logic_vector(15 downto 0);
signal atop     : std_logic;
signal btop     : std_logic;
signal ftop     : std_logic;

-- Main --
begin
    -- Calculate Process --
    process(func, busA, busB) begin
        case func is
            when "0101" =>            -- ADD --
                ans <= busA + busB;
            when "0110" =>            -- SUB --
                ans <= busA - busB;
            when "0111" =>            -- SL --
                case busB(3 downto 0) is
                    when "0000" => null;
                    when "0001" => ans <= busA(14 downto 0) & "0";
                    when "0010" => ans <= busA(13 downto 0) & "00";
                    when "0011" => ans <= busA(12 downto 0) & "000";
                    when "0100" => ans <= busA(11 downto 0) & "0000";
                    when "0101" => ans <= busA(10 downto 0) & "00000";
                    when "0110" => ans <= busA( 9 downto 0) & "000000";
                    when "0111" => ans <= busA( 8 downto 0) & "0000000";
                    when "1000" => ans <= busA( 7 downto 0) & "00000000";
                    when "1001" => ans <= busA( 6 downto 0) & "000000000";
                    when "1010" => ans <= busA( 5 downto 0) & "0000000000";
                    when "1011" => ans <= busA( 4 downto 0) & "00000000000";
                    when "1100" => ans <= busA( 3 downto 0) & "000000000000";
                    when "1101" => ans <= busA( 2 downto 0) & "0000000000000";
                    when "1110" => ans <= busA( 1 downto 0) & "00000000000000";
                    when "1111" => ans <= busA(0) & "000000000000000";
                    when others => null;
                end case;
            when "1000" =>            -- SR --                
                case busB(3 downto 0) is
                    when "0000" => null;
                    when "0001" => ans <= '0' & busA(15 downto 1);
                    when "0010" => ans <= '00' & busA(15 downto 2);
                    when "0011" => ans <= '000' & busA(15 downto 3);
                    when "0100" => ans <= '0000' & busA(15 downto 4);
                    when "0101" => ans <= '00000' & busA(15 downto 5);
                    when "0110" => ans <= '000000' & busA(15 downto 6);
                    when "0111" => ans <= '0000000' & busA(15 downto 7);
                    when "1000" => ans <= '00000000' & busA(15 downto 8);
                    when "1001" => ans <= '000000000' & busA(15 downto 9);
                    when "1010" => ans <= '0000000000' & busA(15 downto 10);
                    when "1011" => ans <= '00000000000' & busA(15 downto 11);
                    when "1100" => ans <= '000000000000' & busA(15 downto 12);
                    when "1101" => ans <= '0000000000000' & busA(15 downto 13);
                    when "1110" => ans <= '00000000000000' & busA(15 downto 14);
                    when "1111" => ans <= "000000000000000" & busA(15);
                    when others => null;
                end case;
            when "1001" =>            -- AND --
                ans <= busA and busB;
            when "1010" =>            -- OR --
                ans <= busA or busB;
            when "1011" =>            -- NOT --
                ans <= not busA;
            when others =>
                ans <= busA;
        end case;
    end process;

    -- Answer Process --
    process(busA, busB, ans) begin
        atop <= busA(15);
        btop <= busB(15);
        ftop <= ans(15);
        busC <= ans;
        if(ans = "0000000000000000") then
            outZ <= '1';
        else
            outZ <= '0';
        end if;
    end process;

    -- Flag Process --
    process(func, atop, btop, ftop) begin
        case func is
            when "0101" =>
                if(((atop and btop) or (atop and not ftop) or (btop and not ftop)) = '1') then
                    outO <= '1';
                else
                    outO <= '0';
                end if;
                outS <= ftop;
            when "0110" =>
                if(((atop and btop) or (atop and not ftop) or (btop and not ftop)) = '1') then
                    outO <= '0';
                else
                    outO <= '1';
                end if;
                outS <= ftop;
            when others =>
                null;
        end case;
    end process;
end BEHAVIOR;