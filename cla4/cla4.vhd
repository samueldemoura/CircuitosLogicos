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
		     c: buffer STD_LOGIC_VECTOR(4 downto 0));
end component;

signal p, g: STD_LOGIC_VECTOR(3 downto 0);
signal c: STD_LOGIC_VECTOR(4 downto 0);

begin
	p(0) <= a(0) xor b(0);
	g(0) <= a(0) and b(0);
	p(1) <= a(1) xor b(1);
	g(1) <= a(1) and b(1);
	p(2) <= a(2) xor b(2);
	g(2) <= a(2) and b(2);
	p(3) <= a(3) xor b(3);
	g(3) <= a(3) and b(3);
	
	carry: vua4 port map (p, g, cin, c);
	
	s(0) <= p(0) xor c(0);
	s(1) <= p(1) xor c(1);
	s(2) <= p(2) xor c(2);
	s(3) <= p(3) xor c(3);
	
	cout <= c(4);
	p_out <= p(3); -- index is 3 or 0?
	g_out <= g(3);
end;
