library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sqrt is
  port(pulse    : in  std_logic;
       btn      : in  std_logic_vector(2 downto 0);
       sw       : in  std_logic_vector(9 downto 0);
       led      : out std_logic_vector(9 downto 0);
       hex0     : out std_logic_vector(7 downto 0);
       hex1     : out std_logic_vector(7 downto 0);
       hex2     : out std_logic_vector(7 downto 0);
       hex3     : out std_logic_vector(7 downto 0));
end sqrt;

architecture BEHAVIOR of sqrt is

--component clock is
--  port(pulse : out std_logic);
--end component;

component alu is
  port(func : in  std_logic_vector(3 downto 0);
       busA : in  std_logic_vector(15 downto 0);
       busB : in  std_logic_vector(15 downto 0);
       inZ  : in  std_logic;
       inS  : in  std_logic;
       inO  : in  std_logic;
       outZ : out std_logic;
       outS : out std_logic;
       outO : out std_logic;
       busC : out std_logic_vector(15 downto 0));
end component;

component bB is
  port(S_GRB    : in  std_logic_vector(15 downto 0);
       S_PR_F   : in  std_logic_vector(15 downto 0);
       S_MAR_F  : in  std_logic_vector(15 downto 0);
       S_MDR_F  : in  std_logic_vector(15 downto 0);
       addr     : in  std_logic_vector(7 downto 0);
       S_s_ctl  : in  std_logic_vector(4 downto 0);
       S_BUS_B  : out std_logic_vector(15 downto 0));
end component;

--component bC is
--  port(S_BUS_C : inout std_logic_vector(15 downto 0));
--end component;

component busA is
  port(clock    : in  std_logic;
       MDR      : in  std_logic_vector(15 downto 0);
       GR       : in  std_logic_vector(15 downto 0);
       ADDR     : in  std_logic_vector(7 downto 0);
       SI       : in  std_logic_vector(2 downto 0);
       busA_out : out std_logic_vector(15 downto 0));
end component;

component csgc is
  port(clk          : in  std_logic;
       init_phase   : in  std_logic_vector(3 downto 0);
       mlang        : in  std_logic_vector(15 downto 0);
       ba_ctl       : out std_logic_vector(2 downto 0);
       bb_ctl       : out std_logic_vector(4 downto 0);
       address      : out std_logic_vector(7 downto 0);
       gr_lat       : out std_logic;
       gra          : out std_logic_vector(3 downto 0);
       grb          : out std_logic_vector(3 downto 0);
       grc          : out std_logic_vector(3 downto 0);
       ir_lat       : out std_logic;
       fr_lat       : out std_logic;
       pr_lat       : out std_logic;
       pr_cnt       : out std_logic;
       mar_lat      : out std_logic;
       mdr_lat      : out std_logic;
       mdr_sel      : out std_logic;
       m_read       : out std_logic;
       m_write      : out std_logic;
       func         : out std_logic_vector(3 downto 0);
       phaseView    : out std_logic_vector(3 downto 0));
end component;

component fr is
  port(clk    : in  std_logic;
       latch  : in  std_logic;
       inZF   : in  std_logic;
       inSF   : in  std_logic;
       inOF   : in  std_logic;
       outZF  : out std_logic;
       outSF  : out std_logic;
       outOF  : out std_logic);
end component;

component gr is
  port(clk        : in  std_logic;
       S_GRlat    : in  std_logic;
       S_ctl_a    : in  std_logic_vector(3 downto 0);
       S_ctl_b    : in  std_logic_vector(3 downto 0);
       S_ctl_c    : in  std_logic_vector(3 downto 0);
       S_BUS_C    : in  std_logic_vector(15 downto 0);
       S_BUS_A    : out std_logic_vector(15 downto 0);
       S_BUS_B    : out std_logic_vector(15 downto 0);
       GR0_View   : out std_logic_vector(15 downto 0);
       GR1_View   : out std_logic_vector(15 downto 0);
       GR2_View   : out std_logic_vector(15 downto 0);
       GR3_View   : out std_logic_vector(15 downto 0);
       GR4_View   : out std_logic_vector(15 downto 0);
       GR5_View   : out std_logic_vector(15 downto 0);
       GR6_View   : out std_logic_vector(15 downto 0);
       GR7_View   : out std_logic_vector(15 downto 0);
       GR8_View   : out std_logic_vector(15 downto 0);
       GR9_View   : out std_logic_vector(15 downto 0);
       GR10_View  : out std_logic_vector(15 downto 0);
       GR11_View  : out std_logic_vector(15 downto 0);
       GR12_View  : out std_logic_vector(15 downto 0);
       GR13_View  : out std_logic_vector(15 downto 0);
       GR14_View  : out std_logic_vector(15 downto 0);
       GR15_View  : out std_logic_vector(15 downto 0));
end component;

component inst is
  port(clock  : in  std_logic;
       busA   : in  std_logic_vector(15 downto 0);
       latch  : in  std_logic;
       Mlang  : out std_logic_vector(15 downto 0));
end component;

component MAR is
  port(clk    : in  std_logic;
       lat    : in  std_logic;
       busC   : in  std_logic_vector(15 downto 0);
       M_ad16 : out std_logic_vector(15 downto 0);
       M_ad8  : out std_logic_vector(7 downto 0));
end component;

component mdr is
  port(clock  : in  std_logic;
       busC   : in  std_logic_vector(15 downto 0);
       latch  : in  std_logic;
       memo   : in  std_logic_vector(15 downto 0);
       sel    : in  std_logic;
       data   : out std_logic_vector(15 downto 0));
end component;

--component mem is
--  port(clk        : in  std_logic;
--       read       : in  std_logic;
--       write      : in  std_logic;
--       init_phase : in  std_logic_vector(3 downto 0);
--       input      : in  std_logic_vector(15 downto 0);
--       S_MAR_F    : in  std_logic_vector(7 downto 0);
--       S_MDR_F    : in  std_logic_vector(15 downto 0);
--       data       : out std_logic_vector(15 downto 0));
--end component;

component M9K_RAM is
  port(address	  : in std_logic_vector(7 downto 0);
		   clock		  : in std_logic;
       init_phase : in std_logic_vector(3 downto 0);
       input      : in std_logic_vector(15 downto 0);
		   data		    : in std_logic_vector(15 downto 0);
		   rden		    : in std_logic;
		   wren		    : in std_logic;
		   q		      : out std_logic_vector(15 downto 0));
end component;

component pr is
  port(clk      : in std_logic;
       S_PRlat  : in std_logic;
       S_s_inc  : in std_logic;
       S_BUS_C  : in  std_logic_vector(15 downto 0);
       S_PR_F   : out std_logic_vector(15 downto 0));
end component;

--signal pulse            : std_logic;
signal alu_fr_z         : std_logic;
signal alu_fr_s         : std_logic;
signal alu_fr_o         : std_logic;
signal busb_alu         : std_logic_vector(15 downto 0);
signal alu_busc_others  : std_logic_vector(15 downto 0);
signal busa_alu_ir      : std_logic_vector(15 downto 0);
signal csgc_busa_ctl    : std_logic_vector(2 downto 0);
signal csgc_busb_ctl    : std_logic_vector(4 downto 0);
signal csgc_busab_addr  : std_logic_vector(7 downto 0);
signal csgc_gr_lat      : std_logic;
signal csgc_gr_asel     : std_logic_vector(3 downto 0);
signal csgc_gr_bsel     : std_logic_vector(3 downto 0);
signal csgc_gr_csel     : std_logic_vector(3 downto 0);
signal csgc_ir_lat      : std_logic;
signal csgc_fr_lat      : std_logic;
signal csgc_pr_lat      : std_logic;
signal csgc_pr_cntup    : std_logic;
signal csgc_mar_lat     : std_logic;
signal csgc_mdr_lat     : std_logic;
signal csgc_mdr_sel     : std_logic;
signal csgc_mem_read    : std_logic;
signal csgc_mem_write   : std_logic;
signal csgc_alu_func    : std_logic_vector(3 downto 0);
signal phaseView        : std_logic_vector(3 downto 0);
signal fr_alu_z         : std_logic;
signal fr_alu_s         : std_logic;
signal fr_alu_o         : std_logic;
signal gr_busa          : std_logic_vector(15 downto 0);
signal gr_busb          : std_logic_vector(15 downto 0);
signal GR0_View         : std_logic_vector(15 downto 0);
signal GR1_View         : std_logic_vector(15 downto 0);
signal GR2_View         : std_logic_vector(15 downto 0);
signal GR3_View         : std_logic_vector(15 downto 0);
signal GR4_View         : std_logic_vector(15 downto 0);
signal GR5_View         : std_logic_vector(15 downto 0);
signal GR6_View         : std_logic_vector(15 downto 0);
signal GR7_View         : std_logic_vector(15 downto 0);
signal GR8_View         : std_logic_vector(15 downto 0);
signal GR9_View         : std_logic_vector(15 downto 0);
signal GR10_View        : std_logic_vector(15 downto 0);
signal GR11_View        : std_logic_vector(15 downto 0);
signal GR12_View        : std_logic_vector(15 downto 0);
signal GR13_View        : std_logic_vector(15 downto 0);
signal GR14_View        : std_logic_vector(15 downto 0);
signal GR15_View        : std_logic_vector(15 downto 0);
signal ir_csgc          : std_logic_vector(15 downto 0);
signal mar_busb         : std_logic_vector(15 downto 0);
signal mar_mem          : std_logic_vector(7 downto 0);
signal mdr_busab_mem    : std_logic_vector(15 downto 0);
signal mem_mdr          : std_logic_vector(15 downto 0);
signal pr_busb          : std_logic_vector(15 downto 0);
signal init_phase       : std_logic_vector(3 downto 0);
signal input            : std_logic_vector(15 downto 0);

function LedDec(num : std_logic_vector(3 downto 0))
return std_logic_vector is
begin
  case num is
    when X"0" 	=> return "11000000";
    when X"1" 	=> return "11111001";
    when X"2" 	=> return "10100100";
    when X"3" 	=> return "10110000";
    when X"4" 	=> return "10011001";
    when X"5" 	=> return "10010010";
    when X"6" 	=> return "10000010";
    when X"7" 	=> return "11111000";
    when X"8" 	=> return "10000000";
    when X"9" 	=> return "10011000";
    when X"a" 	=> return "10001000";
    when X"b" 	=> return "10000011";
    when X"c" 	=> return "10100111";
    when X"d" 	=> return "10100001";
    when X"e" 	=> return "10000110";
    when X"f" 	=> return "10001110";
    when others	=> return "11111111";
  end case;
end function;

begin
  led(2 downto 0)   <=    not btn(2 downto 0);
  led(6 downto 3)   <=    init_phase;

--  clock_a : clock port map(pulse => pulse);

  alu_a : alu port map(func => csgc_alu_func,
                       busA => busa_alu_ir,
                       busB => busb_alu,
                       inZ  => fr_alu_z,
                       inS  => fr_alu_s,
                       inO  => fr_alu_o,
                       outZ => alu_fr_z,
                       outS => alu_fr_s,
                       outO => alu_fr_o,
                       busC => alu_busc_others);

  bB_a : bB port map(S_GRB   => gr_busb,
                     S_PR_F  => pr_busb,
                     S_MAR_F => mar_busb,
                     S_MDR_F => mdr_busab_mem,
                     addr    => csgc_busab_addr,
                     S_s_ctl => csgc_busb_ctl,
                     S_BUS_B => busb_alu);

--bC_a : bC port map(S_BUS_C => alu_busc_others);

  busA_a : busA port map(clock    => pulse,
                         MDR      => mdr_busab_mem,
                         GR       => gr_busa,
                         ADDR     => csgc_busab_addr,
                         SI       => csgc_busa_ctl,
                         busA_out => busa_alu_ir);

  csgc_a : csgc port map(clk        => pulse,
                         init_phase => init_phase,
                         mlang      => ir_csgc,
                         ba_ctl     => csgc_busa_ctl,
                         bb_ctl     => csgc_busb_ctl,
                         address    => csgc_busab_addr,
                         gr_lat     => csgc_gr_lat,
                         gra        => csgc_gr_asel,
                         grb        => csgc_gr_bsel,
                         grc        => csgc_gr_csel,
                         ir_lat     => csgc_ir_lat,
                         fr_lat     => csgc_fr_lat,
                         pr_lat     => csgc_pr_lat,
                         pr_cnt     => csgc_pr_cntup,
                         mar_lat    => csgc_mar_lat,
                         mdr_lat    => csgc_mdr_lat,
                         mdr_sel    => csgc_mdr_sel,
                         m_read     => csgc_mem_read,
                         m_write    => csgc_mem_write,
                         func       => csgc_alu_func,
                         phaseView  => phaseView);

  fr_a : fr port map(clk   => pulse,
                     latch => csgc_fr_lat,
                     inZF  => alu_fr_z,
                     inSF  => alu_fr_s,
                     inOF  => alu_fr_o,
                     outZF => fr_alu_z,
                     outSF => fr_alu_s,
                     outOF => fr_alu_o);

  gr_a : gr port map(clk        => pulse,
                     S_GRlat    => csgc_gr_lat,
                     S_ctl_a    => csgc_gr_asel,
                     S_ctl_b    => csgc_gr_bsel,
                     S_ctl_c    => csgc_gr_csel,
                     S_BUS_C    => alu_busc_others,
                     S_BUS_A    => gr_busa,
                     S_BUS_B    => gr_busb,
                     GR0_View   => GR0_View,
                     GR1_View   => GR1_View,
                     GR2_View   => GR2_View,
                     GR3_View   => GR3_View,
                     GR4_View   => GR4_View,
                     GR5_View   => GR5_View,
                     GR6_View   => GR6_View,
                     GR7_View   => GR7_View,
                     GR8_View   => GR8_View,
                     GR9_View   => GR9_View,
                     GR10_View  => GR10_View,
                     GR11_View  => GR11_View,
                     GR12_View  => GR12_View,
                     GR13_View  => GR13_View,
                     GR14_View  => GR14_View,
                     GR15_View  => GR15_View);

  inst_a : inst port map(clock => pulse,
                         busA  => busa_alu_ir,
                         latch => csgc_ir_lat,
                         Mlang => ir_csgc);

  MAR_a : MAR port map(clk    => pulse,
                       lat    => csgc_mar_lat,
                       busC   => alu_busc_others,
                       M_ad16 => mar_busb,
                       M_ad8  => mar_mem);

  mdr_a : mdr port map(clock => pulse,
                       busC  => alu_busc_others,
                       latch => csgc_mdr_lat,
                       memo  => mem_mdr,
                       sel   => csgc_mdr_sel,
                       data  => mdr_busab_mem);

--  mem_a : mem port map(clk        => pulse,
--                       read       => csgc_mem_read,
--                       write      => csgc_mem_write,
--                       init_phase => init_phase,
--                       input      => input,
--                       S_MAR_F    => mar_mem,
--                       S_MDR_F    => mdr_busab_mem,
--                       data       => mem_mdr);

	M9K_RAM_inst : M9K_RAM port map(address	    => mar_mem,
																	clock	      => pulse,
																	init_phase  => init_phase,
																	input       => input,
																	data	      => mdr_busab_mem,
																	rden	      => csgc_mem_read,
																	wren	      => csgc_mem_write,
																	q	          => mem_mdr);

  pr_a : pr port map(clk     => pulse,
                     S_PRlat => csgc_pr_lat,
                     S_s_inc => csgc_pr_cntup,
                     S_BUS_C => alu_busc_others,
                     S_PR_F  => pr_busb);


  process(pulse)
  variable GR_View : std_logic_vector(15 downto 0);
  begin
    if pulse'event and pulse = '1' then
      if btn(0) = '0' then
        input(7 downto 0) <= sw(7 downto 0);
        init_phase <= X"1";
      end if;
      if btn(1) = '0' then
        input(15 downto 8) <= sw(7 downto 0);
        init_phase <= X"1";
      end if;
      if btn(2) = '0' then
        if (init_phase = X"1") then
          init_phase <= X"2";
        end if;
      end if;
      if init_phase >= X"2" then
        if init_phase = X"f" then
          init_phase <= X"0";
        end if;
        init_phase <= init_phase + 1;
      end if;
      if ir_csgc(15 downto 12) = X"f" then
        case ir_csgc(11 downto 8) is
          when X"0" => GR_View := GR0_View;
          when X"1" => GR_View := GR1_View;
          when X"2" => GR_View := GR2_View;
          when X"3" => GR_View := GR3_View;
          when X"4" => GR_View := GR4_View;
          when X"5" => GR_View := GR5_View;
          when X"6" => GR_View := GR6_View;
          when X"7" => GR_View := GR7_View;
          when X"8" => GR_View := GR8_View;
          when X"9" => GR_View := GR9_View;
          when X"a" => GR_View := GR10_View;
          when X"b" => GR_View := GR11_View;
          when X"c" => GR_View := GR12_View;
          when X"d" => GR_View := GR13_View;
          when X"e" => GR_View := GR14_View;
          when X"f" => GR_View := GR15_View;
          when others => null;
        end case;
        case ir_csgc(3 downto 0) is
          when X"0" => hex0 <= LedDec(GR_View(3 downto 0));
          when X"1" => hex1 <= LedDec(GR_View(3 downto 0));
          when X"2" => hex2 <= LedDec(GR_View(3 downto 0));
          when X"3" => hex3 <= LedDec(GR_View(3 downto 0));
          when others => null;
        end case;
        hex2(7) <= '0';
      elsif init_phase = X"1" then
        hex0 <= LedDec(input(3 downto 0));
        hex1 <= LedDec(input(7 downto 4));
        hex2 <= LedDec(input(11 downto 8));
        hex3 <= LedDec(input(15 downto 12));
        hex0(7) <= '0';
      end if;
    end if;
  end process;
end BEHAVIOR;
