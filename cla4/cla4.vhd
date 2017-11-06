library IEEE; use IEEE.STD_LOGIC_1164.all;

entity cla4 is
	port(a, b: in  STD_LOGIC_VECTOR(3 downto 0);
		  cin: in  STD_LOGIC;
		    s: out STD_LOGIC_VECTOR(3 downto 0);
		 cout: out STD_LOGIC;
 p_out, g_out: out STD_LOGIC);
end;

architecture synth of cla4 is
component vua4 is
	port (p, g: in  STD_LOGIC_VECTOR(3 downto 0);
		   cin: in  STD_LOGIC;
		     c: buffer STD_LOGIC_VECTOR(3 downto 0);
		  cout, p_out, g_out: out STD_LOGIC);
end component;

component fulladder_pg is
	port(a, b, cin: in  STD_LOGIC;
	 p, g, s, cout:	out STD_LOGIC);
end component;

signal p, g: STD_LOGIC_VECTOR(3 downto 0);
signal c: STD_LOGIC_VECTOR(3 downto 0);
signal ignore: STD_LOGIC;

begin
	carry: vua4 port map (p, g, cin, c, cout, p_out, g_out);
	s0: fulladder_pg port map(a(0), b(0), c(0), p(0), g(0), s(0), ignore);
	s1: fulladder_pg port map(a(1), b(1), c(1), p(1), g(1), s(1), ignore);
	s2: fulladder_pg port map(a(2), b(2), c(2), p(2), g(2), s(2), ignore);
	s3: fulladder_pg port map(a(3), b(3), c(3), p(3), g(3), s(3), ignore);
end;
