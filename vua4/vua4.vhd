library IEEE; use IEEE.STD_LOGIC_1164.all;

entity vua4 is
	port (p, g: in  STD_LOGIC_VECTOR(3 downto 0);
		     c: buffer STD_LOGIC_VECTOR(4 downto 0));
end;

architecture synth of vua4 is
begin
	c(1) <= g(0) or (c(0) and p(0));
	c(2) <= g(1) or (g(0) and p(1)) or (c(0) and p(0) and p(1));
	c(3) <= g(2) or (g(1) and p(2)) or (g(0) and p(1) and p(2)) or (c(0) and p(0) and p(1) and p(2));
	c(4) <= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or (g(0) and p(1) and p(2) and p(3)) or (c(0) and p(0) and p(1) and p(2) and p(3));
end;
