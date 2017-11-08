library IEEE; use IEEE.STD_LOGIC_1164.all;

entity flopr_1bit is
	port (clk,reset, d: in STD_LOGIC;
		q:  out STD_LOGIC);
end;

architecture asynchronous of flopr_1bit is
-- asynchronous reset
begin
	process (clk, reset) begin
		if reset = '1' then
			q <= '0';
		elsif clk'event and clk = '1' then
				q <= d;
		end if;
	end process;
end;