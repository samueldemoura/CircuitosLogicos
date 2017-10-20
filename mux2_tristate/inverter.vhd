library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity inverter is
	port(a: in  STD_LOGIC;
		 y:	out STD_LOGIC);
end;

architecture synth of inverter is
begin
	y <= not a;
end;