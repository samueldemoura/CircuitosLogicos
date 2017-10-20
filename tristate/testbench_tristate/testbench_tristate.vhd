library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use STD.TEXTIO.ALL ;

entity testbench_tristate is
	-- no inputs or outputs
end;

architecture sim of testbench_tristate is
	component tristate
		port (a: in STD_LOGIC_VECTOR(3 downto 0);
			  en: in STD_LOGIC;
			  y: out STD_LOGIC_VECTOR(3 downto 0));
	end component;

signal clk: STD_LOGIC;
signal a, y: STD_LOGIC_VECTOR(3 downto 0);
signal en: STD_LOGIC;
signal yexpected: STD_LOGIC_VECTOR(3 downto 0);
constant MEMSIZE: integer := 4;
type tvarray is array (MEMSIZE downto 0) of STD_LOGIC_VECTOR (8 downto 0);
signal testvectors: tvarray;
shared variable vectornum, errors: integer;
begin
-- instantiate device under test
dut: tristate port map (a, en, y);
-- generate clock
process begin
	clk <= '1'; wait for 15 ns;  
	clk <= '0'; wait for 10 ns;
end process;
-- at start of test, load vectors
-- and pulse reset
process is
file tv: TEXT;
variable i, j: integer;
variable L: line;
variable ch: character;
begin
	-- read file of test vectors
	i := 0;
	FILE_OPEN (tv, "./example.tv", READ_MODE);
	while not endfile(tv) loop
		readline (tv, L);
		for j in 8 downto 0 loop
			read (L, ch);
			if (ch = '_') then
				read (L, ch);
			end if;
			if (ch = '0') then
				testvectors (i) (j) <= '0';
			end if;
			if (ch = '1') then
				testvectors (i) (j) <= '1';
			end if;
			if (ch = 'Z') then
				testvectors (i) (j) <= 'Z';
			end if;
		end loop;
		i := i + 1;
	end loop;
	vectornum := 0; errors := 0;
	-- reset <= '1'; wait for 27 ns; reset <= '0';
	wait;
end process;
-- apply test vectors on rising edge of clk
process (clk) begin
	if (clk'event and clk='1') then   
		a <= testvectors (vectornum) (8 downto 5); --after 1 ns;
		en <= testvectors (vectornum)(4); --(5 downto 5); --after 1 ns;
		yexpected <= testvectors (vectornum)(3 downto 0); --after 1 ns;
	end if;
end process;
-- check results on falling edge of clk
process (clk) begin
	if (clk'event and clk = '0')then
		for k in 0 to 3 loop
			assert y(k)= yexpected(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado yesp ="& STD_LOGIC'image(yexpected(k))&"Valor Obtido: y("&integer'image(k)&") ="& STD_LOGIC'image(y(k));
			
			if (y /= yexpected) then
				errors := errors + 1;
			end if;
		end loop;
		
		vectornum := vectornum + 1;
		-- if (is_x (testvectors(vectornum))) then
		if (vectornum = MEMSIZE) then
			if (errors = 0) then
				report "Just kidding --" &
				integer'image (vectornum) &
				"tests completed successfully."
				severity failure;
			else
				report integer'image (vectornum) &
				"tests completed, errors = " &
				integer'image (errors)
				severity failure;
			end if;
		end if;
	end if;
	
end process;
end;
