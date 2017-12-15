LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY tb_sqrt IS
END tb_sqrt;
ARCHITECTURE sqrt_arch OF tb_sqrt IS
-- constants
-- signals
SIGNAL btn : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL hex0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL hex1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL hex2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL hex3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL led : STD_LOGIC_VECTOR(9 DOWNTO 0);
--SIGNAL pulse : STD_LOGIC;
SIGNAL sw : STD_LOGIC_VECTOR(9 DOWNTO 0);
COMPONENT sqrt
	PORT (
	btn : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	hex0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	hex1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	hex2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	hex3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	led : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
	--pulse : IN STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : sqrt
	PORT MAP (
  -- list connections between master ports and signals
	btn => btn,
	hex0 => hex0,
	hex1 => hex1,
	hex2 => hex2,
	hex3 => hex3,
	led => led,
	--pulse => pulse,
	sw => sw
	);
init : PROCESS
-- variable declarations
BEGIN
  -- code that executes only once
WAIT;
END PROCESS init;
always : PROCESS
-- optional sensitivity list
-- (        )
-- variable declarations
BEGIN
  -- code executes for every event on sensitivity list
  -- wait for about 3 ms;

  -- ans = sqrt("c350") = X"df.9b" (preset)
  -- hex[0, 1, 2, 3] = [83, 98, 0e, a1]
  btn <= "111";
  sw <= "0000000000";
  wait for 1 ms;

  -- ans = sqrt(X"fe00") = X"fe.ff"
  -- hex[0, 1, 2, 3] = [8e, 8e, 06, 8e]
  btn <= "110";   -- set sw <= X"00", pushing btn(0)
	sw(7 downto 0) <= X"00";
  wait for 50 ns;
  btn <= "101";   -- set sw <= X"fe", pushing btn(1)
	sw(7 downto 0) <= X"fe";
  wait for 1 us;
  btn <= "011";	  -- push btn(2), and wait for finishing program
  wait for 1 ms;

  -- ans = sqrt(X"c350") = X"df.9b"
  -- hex[0, 1, 2, 3] = [83, 98, 0e, a1]
  btn <= "110";   -- set sw <= X"50", pushing btn(0)
  sw(7 downto 0) <= X"50";
  wait for 50 ns;
  btn <= "101"; -- set sw <= X"c3", pushing btn(1)
  sw(7 downto 0) <= X"c3";
  wait for 1 us;
  btn <= "011"; -- push btn(2), and wait for finishing program
  wait for 1 ms;

WAIT;
END PROCESS always;
END sqrt_arch;
