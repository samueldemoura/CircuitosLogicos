library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use STD.TEXTIO.ALL ;

entity testbench_cla16 is
	-- no inputs or outputs
end;

architecture sim of testbench_cla16 is
component cla16
	port(a, b: in  STD_LOGIC_VECTOR(15 downto 0);
		  cin: in  STD_LOGIC;
		    s: out STD_LOGIC_VECTOR(15 downto 0);
		 cout: out STD_LOGIC);
end component;

signal clk: STD_LOGIC;
signal a, b, s, sexpected: STD_LOGIC_VECTOR(15 downto 0);
signal cin, cout, coutexpected: STD_LOGIC;

constant MEMSIZE: integer := 65;
type tvarray is array (MEMSIZE downto 0) of STD_LOGIC_VECTOR (49 downto 0);
signal testvectors: tvarray;
shared variable vectornum, errors: integer;
begin
-- instantiate device under test
dut: cla16 port map (a, b, cin, s, cout);
-- generate clockt
process begin
	clk <= '1'; wait for 18 ns;  
	clk <= '0'; wait for 1 ns;
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
		for j in 49 downto 0 loop
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
		a <= testvectors (vectornum) (49 downto 34);
		b <= testvectors (vectornum) (33 downto 18);
		cin <= testvectors (vectornum) (17);
		sexpected <= testvectors (vectornum)(16 downto 1);
		coutexpected <= testvectors (vectornum) (0);
	end if;
end process;
-- check results on falling edge of clk
process (clk) begin
	if (clk'event and clk = '0')then
		for k in 0 to 15 loop
			assert s(k)= sexpected(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado sesp ="& STD_LOGIC'image(sexpected(k))&"Valor Obtido: s("&integer'image(k)&") ="& STD_LOGIC'image(s(k));
			
			if (s /= sexpected) then
				errors := errors + 1;
			end if;
		end loop;
		
		assert cout = coutexpected
			report "Cout deu erro. Esperado = " & STD_LOGIC'image(coutexpected) & ", valor obtido = " & STD_LOGIC'image(cout);
		
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
