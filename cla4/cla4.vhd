library IEEE; use IEEE.STD_LOGIC_1164.all;

entity cla4 is
	port(a, b: in  STD_LOGIC_VECTOR(3 downto 0);
		  cin: in  STD_LOGIC;
		    s: out STD_LOGIC_VECTOR(3 downto 0);
		 cout: out STD_LOGIC);
end;

architecture synth of cla4 is
component fulladder is
	port(a, b, cin: in  STD_LOGIC;
		 s, cout:	out STD_LOGIC);
end component;

component vua4 is
	port (p, g: in  STD_LOGIC_VECTOR(3 downto 0);
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
	
	carry: vua4 port map (p, g, c);
	
	s(0) <= p(0) xor c(0);
	s(1) <= p(1) xor c(1);
	s(2) <= p(2) xor c(2);
	s(3) <= p(3) xor c(3);
	
	cout <= c(4);
	
	--cout <= g or (p and c(4));
	--bit0: fulladder port map (a(0), b(0), cin, s(0), cout_aux);
	--bit2: fulladder port map (a(1), b(1), cout_aux, s(1), cout_aux2);
	--bit3: fulladder port map (a(2), b(2), cout_aux2, s(2), cout_aux3);
	--bit4: fulladder port map (a(3), b(3), cout_aux3, s(3), cout);
end;
