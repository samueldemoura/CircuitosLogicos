library IEEE; use IEEE.STD_LOGIC_1164.all;

entity cla16 is
	port(a, b: in  STD_LOGIC_VECTOR(15 downto 0);
		  cin: in  STD_LOGIC;
		    s: out STD_LOGIC_VECTOR(15 downto 0);
		 cout: out STD_LOGIC);
end;

architecture synth of cla16 is
component cla4 is
	port(a, b: in  STD_LOGIC_VECTOR(3 downto 0);
		  cin: in  STD_LOGIC;
		    s: out STD_LOGIC_VECTOR(3 downto 0);
		 cout: out STD_LOGIC;
 p_out, g_out: out STD_LOGIC);
end component;

signal p, g: STD_LOGIC_VECTOR(3 downto 0);
signal c: STD_LOGIC_VECTOR(3 downto 0);
signal pLCU, gLCU, ignore: STD_LOGIC;

begin
	--errado c(0) <= g(0) or (p(0) and cin);
	c(1) <= g(1) or (g(0) and p(1)) or (cin and p(0) and p(1));
	c(2) <= g(2) or (g(1) and p(2)) or (g(0) and p(1) and p(2)) or (cin and p(0) and p(1) and p(2));
	c(3) <= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3)) or (cin and p(0) and p(1) and p(2) and p(3));

	cla4_1: cla4 port map (a(3  downto  0), b(3  downto  0),  cin, s(3  downto  0), ignore, p(0), g(0));
	cla4_2: cla4 port map (a(7  downto  4), b(7  downto  4), c(0), s(7  downto  4), ignore, p(1), g(1));
	cla4_3: cla4 port map (a(11 downto  8), b(11 downto  8), c(1), s(11 downto  8), ignore, p(2), g(2));
	cla4_4: cla4 port map (a(15 downto 12), b(15 downto 12), c(2), s(15 downto 12), ignore, p(3), g(3));

	c(0) <= g(0) or (p(0) and cin);

	pLCU <= (p(0) and p(1) and p(2) and p(3));
	gLCU <= (g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3)));
	--cout <= c(3);
	cout <= gLCU or (cin and pLCU);
	--cout <= (g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3))) or (cin and (p(0) and p(1) and p(2) and p(3)));
	--cout <= (g(3) or (g(2) and p(3)) or (g(2) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3))) or (c(0) and (p(0) and p(1) and p(2) and p(3)));
end;
