library IEEE; use IEEE.STD_LOGIC_1164.all;

entity vua16 is
	port (p, g: in  STD_LOGIC_VECTOR(3 downto 0);
		   cin: in  STD_LOGIC;
		     c: buffer STD_LOGIC_VECTOR(3 downto 0);
		  cout: buffer STD_LOGIC);
end;

architecture synth of vua16 is
begin
	c(0) <= g(0) or (p(0) and cin);
	c(1) <= g(1) or (g(0) and p(1)) or (cin and p(0) and p(1));
	c(2) <= g(2) or (g(1) and p(2)) or (g(0) and p(1) and p(2)) or (cin and p(0) and p(1) and p(2));
	c(3) <= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3)) or (cin and p(0) and p(1) and p(2) and p(3));
	
	cout <= ((g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3))) ) or ( cin and (p(0) and p(1) and p(2) and p(3)) );
end;
