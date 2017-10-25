library IEEE; use IEEE.STD_LOGIC_1164.all;

entity sync is
	port(clk: in  STD_LOGIC;
		 d:   in  STD_LOGIC;
		 q:   out STD_LOGIC);
end;

architecture good of sync is

signal n1: STD_LOGIC;

begin
	process(clk) begin
		if clk'event and clk = '1' then
			n1 <= d;
			q <= n1;
		end if;
	end process;
end;
