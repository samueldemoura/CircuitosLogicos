library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use STD.TEXTIO.ALL ;

entity testbench_seven_seg_decoder is
	-- no inputs or outputs
end;

architecture sim of testbench_seven_seg_decoder is
	component seven_seg_decoder
		port (data:     in  STD_LOGIC_VECTOR(3 downto 0);
			  segments: out STD_LOGIC_VECTOR(6 downto 0));
	end component;

signal clk: STD_LOGIC;
signal data: STD_LOGIC_VECTOR(3 downto 0);
signal segments, segmentsexpected: STD_LOGIC_VECTOR(6 downto 0);
constant MEMSIZE: integer := 16;
type tvarray is array (MEMSIZE downto 0) of STD_LOGIC_VECTOR (10 downto 0);
signal testvectors: tvarray;
shared variable vectornum, errors: integer;
begin
-- instantiate device under test
dut: seven_seg_decoder port map(data, segments);
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
		for j in 10 downto 0 loop
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
			--if (ch = 'Z') then
			--	testvectors (i) (j) <= 'Z';
			--end if;
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
		data <= testvectors (vectornum) (10 downto 7);
		segmentsexpected <= testvectors (vectornum)(6 downto 0);
	end if;
end process;
-- check results on falling edge of clk
process (clk) begin
	if (clk'event and clk = '0')then
		for k in 0 to 3 loop
			assert segments(k)= segmentsexpected(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado qesp ="& STD_LOGIC'image(segmentsexpected(k))&"Valor Obtido: q("&integer'image(k)&") ="& STD_LOGIC'image(segments(k));
			
			if (segments /= segmentsexpected) then
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
