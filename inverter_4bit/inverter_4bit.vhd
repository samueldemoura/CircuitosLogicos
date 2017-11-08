library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity inverter_4bit is
	port(a: in  STD_LOGIC_VECTOR(3 downto 0);
		 y:	out STD_LOGIC_VECTOR(3 downto 0));
end;

architecture synth of inverter_4bit is
component inverter
	port(a: in  STD_LOGIC;
		 y:	out STD_LOGIC);
end component;
	
begin
	b0: inverter port map(a(0), y(0));
	b1: inverter port map(a(1), y(1));
	b2: inverter port map(a(2), y(2));
	b3: inverter port map(a(3), y(3));
end;