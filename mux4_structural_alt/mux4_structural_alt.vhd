library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux4_structural_alt is
	port(d0, d1, d2, d3: in  STD_LOGIC_VECTOR(3 downto 0);
		 s:				 in  STD_LOGIC_VECTOR(1 downto 0);
		 y:		 		 out STD_LOGIC_VECTOR(3 downto 0));
end;

architecture synth of mux4_structural_alt is
component mux2_tristate
	port(d0, d1:  in STD_LOGIC_VECTOR(3 downto 0);
		 s:		  in  STD_LOGIC;
		 y:		  out STD_LOGIC_VECTOR(3 downto 0));
end component;

signal topY, bottomY: STD_LOGIC_VECTOR(3 downto 0);

begin
	topMux:    mux2_tristate port map(d0, d1, s(0), topY);
	bottomMux: mux2_tristate port map(d2, d3, s(0), bottomY);
	finalMux:  mux2_tristate port map(topY, bottomY, s(1), y);
end;