library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

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
signal shift_ov : std_logic;

-- Main --
begin
    busC <= ans;

    -- Calculate Process --
    process(func, busA, busB) begin
        case func is
            when "0000" =>            -- select busA (not only HALT) --
                ans <= busA;
            when "0001" =>            -- select busB (not only LD1) --
                ans <= busB;
            when "0101" =>            -- ADD --
                ans <= busA + busB;
            when "0110" =>            -- SUB --
                ans <= busA - busB;
            when "0111" =>            -- SL --
                if(busB = "0000000000010000") then
                    shift_ov <= busA(0); ans <= "0000000000000000";
                elsif(busB > "0000000000010000") then
                    shift_ov <= '0'; ans <= "0000000000000000";
                else
                    case busB(3 downto 0) is
                        when "0000" => shift_ov <= '0'; ans <= busA;
                        when "0001" => shift_ov <= busA(15); ans <= busA(14 downto 0) & '0';
                        when "0010" => shift_ov <= busA(14); ans <= busA(13 downto 0) & "00";
                        when "0011" => shift_ov <= busA(13); ans <= busA(12 downto 0) & "000";
                        when "0100" => shift_ov <= busA(12); ans <= busA(11 downto 0) & "0000";
                        when "0101" => shift_ov <= busA(11); ans <= busA(10 downto 0) & "00000";
                        when "0110" => shift_ov <= busA(10); ans <= busA( 9 downto 0) & "000000";
                        when "0111" => shift_ov <= busA( 9); ans <= busA( 8 downto 0) & "0000000";
                        when "1000" => shift_ov <= busA( 8); ans <= busA( 7 downto 0) & "00000000";
                        when "1001" => shift_ov <= busA( 7); ans <= busA( 6 downto 0) & "000000000";
                        when "1010" => shift_ov <= busA( 6); ans <= busA( 5 downto 0) & "0000000000";
                        when "1011" => shift_ov <= busA( 5); ans <= busA( 4 downto 0) & "00000000000";
                        when "1100" => shift_ov <= busA( 4); ans <= busA( 3 downto 0) & "000000000000";
                        when "1101" => shift_ov <= busA( 3); ans <= busA( 2 downto 0) & "0000000000000";
                        when "1110" => shift_ov <= busA( 2); ans <= busA( 1 downto 0) & "00000000000000";
                        when "1111" => shift_ov <= busA( 1); ans <= busA(0) & "000000000000000";
                        when others => shift_ov <= '0'; ans <= busA;
                    end case;
                end if;
            when "1000" =>            -- SR --
                if(busB = "0000000000010000") then
                    shift_ov <= busA(15); ans <= "0000000000000000";
                elsif(busB > "0000000000010000") then
                    shift_ov <= '0'; ans <= "0000000000000000";
                else
                    case busB(3 downto 0) is
                        when "0000" => shift_ov <= '0'; ans <= busA;
                        when "0001" => shift_ov <= busA( 0); ans <= '0' & busA(15 downto 1);
                        when "0010" => shift_ov <= busA( 1); ans <= "00" & busA(15 downto 2);
                        when "0011" => shift_ov <= busA( 2); ans <= "000" & busA(15 downto 3);
                        when "0100" => shift_ov <= busA( 3); ans <= "0000" & busA(15 downto 4);
                        when "0101" => shift_ov <= busA( 4); ans <= "00000" & busA(15 downto 5);
                        when "0110" => shift_ov <= busA( 5); ans <= "000000" & busA(15 downto 6);
                        when "0111" => shift_ov <= busA( 6); ans <= "0000000" & busA(15 downto 7);
                        when "1000" => shift_ov <= busA( 7); ans <= "00000000" & busA(15 downto 8);
                        when "1001" => shift_ov <= busA( 8); ans <= "000000000" & busA(15 downto 9);
                        when "1010" => shift_ov <= busA( 9); ans <= "0000000000" & busA(15 downto 10);
                        when "1011" => shift_ov <= busA(10); ans <= "00000000000" & busA(15 downto 11);
                        when "1100" => shift_ov <= busA(11); ans <= "000000000000" & busA(15 downto 12);
                        when "1101" => shift_ov <= busA(12); ans <= "0000000000000" & busA(15 downto 13);
                        when "1110" => shift_ov <= busA(13); ans <= "00000000000000" & busA(15 downto 14);
                        when "1111" => shift_ov <= busA(14); ans <= "000000000000000" & busA(15);
                        when others => shift_ov <= '0'; ans <= busA;
                    end case;
                end if;
            when "1001" =>            -- NAND --
                ans <= busA nand busB;
            when "1010" =>            -- JMP --
                ans <= busA;  --------------------------- effective address
            when "1011" =>            -- JZE --
                if(inZ = '1') then
                    ans <= busA;  ----------------------- effective address
                else
                    ans <= busB + "0000000000000001";  -- program register
                end if;
            when "1100" =>            -- JMI --
                if(inS = '1') then
                    ans <= busA;  ----------------------- effective address
                else
                    ans <= busB + "0000000000000001";  -- program register
                end if;
            when "1101" =>            -- JOV --
                if(inO = '1') then
                    ans <= busA;  ----------------------- effective address
                else
                    ans <= busB + "0000000000000001";  -- program register
                end if;
            when "1110" =>            -- RJMP --
                ans <= busA;  --------------------------- general register
            when "1111" =>            -- DISP --
                ans <= "000000000000" & busA(3 downto 0);
            when others =>
                ans <= "XXXXXXXXXXXXXXXX";
        end case;
    end process;

    -- GetTop Process --
    process(busA, busB, ans) begin
        atop <= busA(15);
        btop <= busB(15);
        ftop <= ans(15);
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
            when "0110" =>
                if(((not atop and (btop or ftop)) or (btop and ftop)) = '1') then
                    outO <= '1';
                else
                    outO <= '0';
                end if;
            when "0111" =>
                outO <= shift_ov;
            when "1000" =>
                outO <= shift_ov;
            when others =>
                outO <= '0';
        end case;
        outS <= ftop;
    end process;

end BEHAVIOR;
