library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use STD.TEXTIO.ALL ;

entity testbench_mux4_structural_alt is
	-- no inputs or outputs
end;

architecture sim of testbench_mux4_structural_alt is
	component mux4_structural_alt
		port (d0, d1, d2, d3: in STD_LOGIC_VECTOR(3 downto 0);
			  s: in STD_LOGIC_VECTOR(1 downto 0);
			  y: out STD_LOGIC_VECTOR(3 downto 0));
	end component;

signal clk: STD_LOGIC;
signal d0, d1, d2, d3, y: STD_LOGIC_VECTOR(3 downto 0);
signal s: STD_LOGIC_VECTOR(1 downto 0);
signal yexpected: STD_LOGIC_VECTOR(3 downto 0);
constant MEMSIZE: integer := 8;
type tvarray is array (MEMSIZE downto 0) of STD_LOGIC_VECTOR (21 downto 0);
signal testvectors: tvarray;
shared variable vectornum, errors: integer;
begin
-- instantiate device under test
dut: mux4_structural_alt port map (d0, d1, d2, d3, s, y);
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
		for j in 21 downto 0 loop
			read (L, ch);
			if (ch = '_') then
				read (L, ch);
			end if;
			if (ch = '0') then
				testvectors (i) (j) <= '0';
			else
				testvectors (i) (j) <= '1';
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
		d0 <= testvectors (vectornum) (21 downto 18); -------------------
		d1 <= testvectors (vectornum) (17 downto 14);
		d2 <= testvectors (vectornum) (13 downto 10); --after 1 ns;
		d3 <= testvectors (vectornum) (9 downto 6); --after 1 ns; -----------------
		s <= testvectors (vectornum) (5 downto 4); --after 1 ns; 
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
		if (is_x (testvectors(vectornum))) then
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
