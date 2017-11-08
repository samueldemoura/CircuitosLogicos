library IEEE; use IEEE.STD_LOGIC_1164.all;

entity flopr_struct is
	port (clk,
		  reset: in STD_LOGIC;
		  d:  in STD_LOGIC_VECTOR (3 downto 0);
		  q:  out STD_LOGIC_VECTOR (3 downto 0));
end;

architecture asynchronous of flopr_struct is
component flopr_1bit
	port (clk,reset, d: in STD_LOGIC;
		q:  out STD_LOGIC);
end component;
begin
	acc0: flopr_1bit port map (clk, reset, d(0), q(0)); 
	acc1: flopr_1bit port map (clk, reset, d(1), q(1));
	acc2: flopr_1bit port map (clk, reset, d(2), q(2));
	acc3: flopr_1bit port map (clk, reset, d(3), q(3));
end;