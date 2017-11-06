library IEEE; use IEEE.STD_LOGIC_1164.all;

entity vua4 is
	port (p, g: in  STD_LOGIC_VECTOR(3 downto 0);
		   cin: in  STD_LOGIC;
		     c: buffer STD_LOGIC_VECTOR(3 downto 0);
			cout, p_out, g_out: out STD_LOGIC);
end;

architecture synth of vua4 is
begin
	c(0) <= cin;
	c(1) <= g(0) or (c(0) and p(0));
	c(2) <= g(1) or (g(0) and p(1)) or (c(0) and p(0) and p(1));
	c(3) <= g(2) or (g(1) and p(2)) or (g(0) and p(1) and p(2)) or (c(0) and p(0) and p(1) and p(2));
	
	cout <= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3)) or (c(0) and p(0) and p(1) and p(2) and p(3));
	p_out <= p(0) and p(1) and p(2) and p(3);
	g_out <= g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and g(0))))));
end;
