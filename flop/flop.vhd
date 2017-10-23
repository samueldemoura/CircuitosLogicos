library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity flop is
	port(clk: in STD_LOGIC;
		 d:   in STD_LOGIC_VECTOR(3 downto 0);
		 q:   out STD_LOGIC_VECTOR(3 downto 0));
end;

architecture synth of flop is
begin
	process(clk) begin
		if clk'event and clk = '1' then
			q <= d;
		end if;
	end process;
end;
