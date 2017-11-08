library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity final is
	port(clk: in STD_LOGIC;
		 a:	in STD_LOGIC_VECTOR(3 downto 0);
		 sel0, sel1: in STD_LOGIC;
		 s:	buffer STD_LOGIC_VECTOR(3 downto 0);
		 cout: out STD_LOGIC);
end;

architecture synth of final is
component mux2_tristate
	port(d0, d1: in  STD_LOGIC_VECTOR(3 downto 0);
		 s:		 in  STD_LOGIC;
		 y:		 out STD_LOGIC_VECTOR(3 downto 0));
end component;

component inverter_4bit
	port(a: in  STD_LOGIC_VECTOR(3 downto 0);
		 y:	out STD_LOGIC_VECTOR(3 downto 0));
end component;

component cla4
	port(a, b: in  STD_LOGIC_VECTOR(3 downto 0);
		  cin: in  STD_LOGIC;
		    s: out STD_LOGIC_VECTOR(3 downto 0);
		 cout: out STD_LOGIC;
 p_out, g_out: out STD_LOGIC);
end component;

component flopr_struct
	port (clk,
		  reset: in STD_LOGIC;
		  d:  in STD_LOGIC_VECTOR (3 downto 0);
		  q:  out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal notA, somador_y, acc_y, mux0_y: STD_LOGIC_VECTOR(3 downto 0);
signal ignore, ignore2: STD_LOGIC;

begin
	inv: inverter_4bit port map(a, notA);
	mux0: mux2_tristate port map(a, notA, sel0, mux0_y);
	mux1: mux2_tristate port map(mux0_y, somador_y, sel1, s);
	somador: cla4 port map(mux0_y, acc_y, sel0, somador_y, cout, ignore, ignore);
	acc: flopr_struct port map(clk, ignore2, s, acc_y);
	--s <= mux1_y;
end;
