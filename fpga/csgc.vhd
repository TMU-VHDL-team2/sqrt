library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity csgc is 
    port(
        clk         : in  std_logic;
        init_phase  : in  std_logic_vector(3 downto 0);
        mlang       : in  std_logic_vector(15 downto 0);
        ba_ctl      : out std_logic_vector(2 downto 0);
        bb_ctl      : out std_logic_vector(4 downto 0);
        address     : out std_logic_vector(7 downto 0);
        gr_lat      : out std_logic;
        gra         : out std_logic_vector(3 downto 0);
        grb         : out std_logic_vector(3 downto 0);
        grc         : out std_logic_vector(3 downto 0);
        ir_lat      : out std_logic;
        fr_lat      : out std_logic;
        pr_lat      : out std_logic;
        pr_cnt      : out std_logic;
        mar_lat     : out std_logic;
        mdr_lat     : out std_logic;
        mdr_sel     : out std_logic;
        m_read      : out std_logic;
        m_write     : out std_logic;
        func        : out std_logic_vector(3 downto 0);
	      phaseView   : out std_logic_vector(3 downto 0)
    );
end csgc;

architecture BEHAVIOR of csgc is

-- Definitions --
signal mnemo     : std_logic_vector(3 downto 0);
signal opeA      : std_logic_vector(3 downto 0);
signal opeB_addr : std_logic_vector(7 downto 0);
signal opeB_gr   : std_logic_vector(3 downto 0);
signal phase     : std_logic_vector(3 downto 0);
signal serial    : std_logic_vector(41 downto 0);

-- Main --
begin
    phaseView <= phase;
    mnemo     <= mlang(15 downto 12);
    opeA      <= mlang(11 downto 8);
    opeB_addr <= mlang( 7 downto 0);
    opeB_gr   <= mlang( 3 downto 0);

    -- Process --
    process(clk) begin
        if(clk'event and (clk = '1')) then

            -- do instruction --
            case mnemo is
            when "0000" =>     -- HALT --
                case phase is
                when "0000" =>
                    if (init_phase = X"1") then
                        phase <= "0000";
                        serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "00000" & "0000";
                    elsif (init_phase = X"2") then -- X"80"->PR
                        phase <= "1000";
                        serial  <= "000" & "00001" & "10000000" & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "0001";
                    else
                        phase <= "1000";
                        serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "00000" & "0000";
                    end if;
                when others => null;
              end case;

            when "0001" =>     -- LD1 --
                case phase is
                when "0000" =>  -- GRB->GRA, PR=PR+1
                    phase <= "1000";
                    serial  <= "010" & "00000" & "00000000" & "1" & opeB_gr & "0000" & opeA & "0001" & "00000" & "0000";
                            --  busA |   busB  |   address  |grlat|   gra  |   grb  |   grc  | i/f/pr |mem,mda/r|  func
                when others => null;
                end case;

            when "0010" =>    -- LD2 --
                case phase is
                when "0000" =>  -- address->MAR
                    phase <= "0001";
                    serial  <= "000" & "00001" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0000" & "10000" & "0001";
                when "0001" =>  -- change memory address
                    phase <= "0010";
                    serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "00010" & "0000";
                when "0010" =>  -- mem(MAR)->MDR
                    phase <= "0011";
                    serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "01110" & "0000";
                when "0011" =>  -- MDR->GRA, PR=PR+1
                    phase <= "1000";
                    serial  <= "000" & "00010" & "00000000" & "1" & "0000" & "0000" & opeA & "0001" & "00000" & "0001";
                when others => null;
                end case;

            when "0011" =>    -- LAD --
                case phase is
                when "0000" =>  -- address->GRA, PR=PR+1
                    phase <= "1000";
                    serial  <= "000" & "00001" & opeB_addr & "1" & "0000" & "0000" & opeA & "0001" & "00000" & "0001";
                when others => null;
                end case;

            when "0100" =>    -- STR --
                case phase is
                when "0000" =>  -- GRA->MDR
                    phase <= "0001";
                    serial  <= "010" & "00000" & "00000000" & "0" & opeA & "0000" & "0000" & "0000" & "01000" & "0000";
                when "0001" =>  -- address->MAR
                    phase <= "0010";
                    serial  <= "000" & "00001" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0000" & "10000" & "0001";
                when "0010" =>  -- MDR->mem(MAR), PR=PR+1
                    phase <= "1000";
                    serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0001" & "00001" & "0000";
                when others => null;
                end case;

            when "0101" =>    -- ADD --
                case phase is
                when "0000" =>  -- GRA=GRA+GRB, PR=PR+1
                    phase <= "1000";
                    serial  <= "010" & "10000" & "00000000" & "1" & opeA & opeB_gr & opeA & "0101" & "00000" & "0101";
                when others => null;
                end case;

            when "0110" =>    -- SUB --
                case phase is
                when "0000" =>  -- GRA=GRA-GRB, PR=PR+1
                    phase <= "1000";
                    serial  <= "010" & "10000" & "00000000" & "1" & opeA & opeB_gr & opeA & "0101" & "00000" & "0110";
                when others => null;
                end case;

            when "0111" =>    -- SL --
                case phase is
                when "0000" =>  -- GRA=GRA<<GRB, PR=PR+1
                    phase <= "1000";
                    serial  <= "010" & "10000" & "00000000" & "1" & opeA & opeB_gr & opeA & "0101" & "00000" & "0111";
                when others => null;
                end case;

            when "1000" =>    -- SR --
                case phase is
                when "0000" =>  -- GRA=GRA>>GRB, PR=PR+1
                    phase <= "1000";
                    serial  <= "010" & "10000" & "00000000" & "1" & opeA & opeB_gr & opeA & "0101" & "00000" & "1000";
                when others => null;
                end case;

            when "1001" =>    -- NAND --
                case phase is
                when "0000" =>  -- GRA=GRAnandGRB, PR=PR+1
                    phase <= "1000";
                    serial  <= "010" & "10000" & "00000000" & "1" & opeA & opeB_gr & opeA & "0101" & "00000" & "1001";
                when others => null;
                end case;

            when "1010" =>    -- JMP --
                if(opeA = "0000") then
                    case phase is
                    when "0000" =>  -- address->PR
                        phase <= "1000";
                        serial  <= "000" & "00001" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "0001";
                    when others => null;
                    end case;
                else
                    case phase is
                    when "0000" =>  -- PR->GRA
                        phase <= "0001";
                        serial  <= "000" & "01000" & "00000000" & "1" & "0000" & "0000" & opeA & "0000" & "00000" & "0001";
                    when "0001" =>  -- address->PR
                        phase <= "1000";
                        serial  <= "000" & "00001" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "0001";
                    when others => null;
                    end case;
                end if;

            when "1011" =>    -- JZE --
                if(opeA = "0000") then
                    case phase is
                    when "0000" =>  -- if(ZF=1) then address->PR else PR=PR+1
                        phase <= "1000";
                        serial  <= "100" & "01000" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "1011";
                    when others => null;
                    end case;
                else
                    case phase is
                    when "0000" =>  -- PR->GRA
                        phase <= "0001";
                        serial  <= "000" & "01000" & "00000000" & "1" & "0000" & "0000" & opeA & "0000" & "00000" & "0001";
                    when "0001" =>  -- if(ZF=1) then address->PR else PR=PR+1
                        phase <= "1000";
                        serial  <= "100" & "01000" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "1011";
                    when others => null;
                    end case;
                end if;

            when "1100" =>    -- JMI --
                if(opeA = "0000") then
                    case phase is
                    when "0000" =>  -- if(SF=1) then address->PR else PR=PR+1
                        phase <= "1000";
                        serial  <= "100" & "01000" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "1100";
                    when others => null;
                    end case;
                else
                    case phase is
                    when "0000" =>  -- PR->GRA
                        phase <= "0001";
                        serial  <= "000" & "01000" & "00000000" & "1" & "0000" & "0000" & opeA & "0000" & "00000" & "0001";
                    when "0001" =>  -- if(SF=1) then address->PR else PR=PR+1
                        phase <= "1000";
                        serial  <= "100" & "01000" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "1100";
                    when others => null;
                    end case;
                end if;

            when "1101" =>    -- JOV --
                if(opeA = "0000") then
                    case phase is
                    when "0000" =>  -- if(OF=1) then address->PR else PR=PR+1
                        phase <= "1000";
                        serial  <= "100" & "01000" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "1101";
                    when others => null;
                    end case;
                else
                    case phase is
                    when "0000" =>  -- PR->GRA
                        phase <= "0001";
                        serial  <= "000" & "01000" & "00000000" & "1" & "0000" & "0000" & opeA & "0000" & "00000" & "0001";
                    when "0001" =>  -- if(OF=1) then address->PR else PR=PR+1
                        phase <= "1000";
                        serial  <= "100" & "01000" & opeB_addr & "0" & "0000" & "0000" & "0000" & "0010" & "00000" & "1101";
                    when others => null;
                    end case;
                end if;

            when "1110" =>    -- RJMP --
                case phase is
                when "0000" =>  -- GRA->PR
                    phase <= "0001";
                    serial  <= "000" & "10000" & "00000000" & "0" & "0000" & opeA & "0000" & "0010" & "00000" & "0001";
                when "0001" =>  -- PR=PR+1
                    phase <= "1000";
                    serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0001" & "00000" & "0000";
                when others => null;
                end case;
            when "1111" =>    -- DISP --
                phase <= "1000";  -- PR=PR+1
                serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0001" & "00000" & "0000";
            when others =>
                phase <= "1000";
            end case;
            
            -- go next instruction --
            case phase is
            when "1000" =>  -- PR->MAR
                phase <= "1001";
                serial  <= "000" & "01000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "10000" & "0001";
            when "1001" =>  -- change memory address
                phase <= "1010";
                serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "00010" & "0000";
            when "1010" =>  -- mem(MAR)->MDR
                phase <= "1011";
                serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "01110" & "0000";
            when "1011" =>  -- MDR->IR
                phase <= "1100";
                serial  <= "001" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "1000" & "00000" & "0000";
            when "1100" =>  -- changing Mlang
                phase <= "0000";
                serial  <= "000" & "00000" & "00000000" & "0" & "0000" & "0000" & "0000" & "0000" & "00000" & "0000";
            when others => null;
            end case;

        else
            null;
        end if;
    end process;
    
    ba_ctl   <= serial(41 downto 39);
    bb_ctl   <= serial(38 downto 34);
    address  <= serial(33 downto 26);
    gr_lat   <= serial(25);
    gra      <= serial(24 downto 21);
    grb      <= serial(20 downto 17);
    grc      <= serial(16 downto 13);
    ir_lat   <= serial(12);
    fr_lat   <= serial(11);
    pr_lat   <= serial(10);
    pr_cnt   <= serial(9);
    mar_lat  <= serial(8);
    mdr_lat  <= serial(7);
    mdr_sel  <= serial(6);
    m_read   <= serial(5);
    m_write  <= serial(4);
    func     <= serial(3 downto 0);

end BEHAVIOR;
