library IEEE; use IEEE.STD_LOGIC_1164.all;

entity flopr is
	port (clk,
		  reset: in STD_LOGIC;
		  d:  in STD_LOGIC_VECTOR (3 downto 0);
		  q:  out STD_LOGIC_VECTOR (3 downto 0));
end;

architecture asynchronous of flopr is
-- asynchronous reset
begin
	process (clk, reset) begin
		if reset = '1' then
			q <= "0000";
		elsif clk'event and clk = '1' then
				q <= d;
		end if;
	end process;
end;