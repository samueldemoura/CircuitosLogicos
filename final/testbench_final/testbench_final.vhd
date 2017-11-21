library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use STD.TEXTIO.ALL ;

entity testbench_final is
	-- no inputs or outputs
end;

architecture sim of testbench_final is
component final
	port(clk: in STD_LOGIC;
		 a:	in STD_LOGIC_VECTOR(3 downto 0);
		 sel0, sel1: in STD_LOGIC;
		 s:	buffer STD_LOGIC_VECTOR(3 downto 0);
		 cout: out STD_LOGIC);
end component;

signal clk, clk2: STD_LOGIC;
signal a, s, sexpected: STD_LOGIC_VECTOR(3 downto 0);
signal sel0, sel1, cout, coutexpected: STD_LOGIC;

constant MEMSIZE: integer := 100;
type tvarray is array (MEMSIZE downto 0) of STD_LOGIC_VECTOR (11 downto 0);
signal testvectors: tvarray;
shared variable vectornum, errors: integer;
begin
-- instantiate device under test
dut: final port map (clk2, a, sel0, sel1, s, cout);
-- generate clockt
process begin
	clk <= '1'; wait for 13 ns;  
	clk <= '0'; wait for 1 ns;
end process;
-- at start of test, load vectors
-- and pulse reset
process is
file tv: TEXT;
variable i, j: integer;
variable L, IGNORE: line;
variable ch: character;
begin
	-- read file of test vectors
	i := 0;
	FILE_OPEN (tv, "./example_clk.tv", READ_MODE);
	while not endfile(tv) loop
		readline (tv, L);
		for j in 11 downto 0 loop
			read (L, ch);
			if (ch = '-') then
				readline(tv, IGNORE);
			end if;
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
		a <= testvectors (vectornum) (10 downto 7);
		sel0 <= testvectors (vectornum) (6);
		sel1 <= testvectors (vectornum) (5);
		sexpected <= testvectors (vectornum)(4 downto 1);
		coutexpected <= testvectors (vectornum) (0);
		clk2 <= testvectors (vectornum) (11);
	end if;
end process;
-- check results on falling edge of clk
process (clk) begin
	if (clk'event and clk = '0')then
		for k in 0 to 3 loop
			assert s(k)= sexpected(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado sesp ="& STD_LOGIC'image(sexpected(k))&"Valor Obtido: s("&integer'image(k)&") ="& STD_LOGIC'image(s(k));
			
			if (s /= sexpected) then
				errors := errors + 1;
			end if;
		end loop;
		
		assert cout = coutexpected
			report "Cout deru erro. Esperado = " & STD_LOGIC'image(coutexpected) & ", valor obtido = " & STD_LOGIC'image(cout);
		
		if (cout /= coutexpected) then
			errors := errors +1;
		end if;
		
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
