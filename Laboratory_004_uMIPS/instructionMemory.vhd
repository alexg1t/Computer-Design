--------------------------------------------------------------------------------
-- 							COMPUTER DESIGN
-- 	Laboratory number: 4
--	Authors: Alexander Ortega & Bregy Malpartida

--	Description of code:
--	This code is a simple implementation of a little async memory used  
--	instruction memory on a MIPS processor
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use ieee.math_real.all;                 -- for the ceiling and log constant calculation functions


entity instruction_memory is
	port (
		address: in std_logic_vector(3 downto 0);
		data: out std_logic_vector(31 downto 0)
	);
end instruction_memory;

architecture instruction_memory_arc of instruction_memory is
	type instrMem is array(0 to 15) of STD_LOGIC_VECTOR (31 downto 0);
	signal memory: mem_array := (
		"00000000010000010001100000100000", -- add $3, $1, $2
		"00000001000011001000000000100010", -- sub $8, $6, $4
		"00000001000000110110000000100100", -- and $12, $3, $8
		"10001101100001110000000000000001", -- lw $7, 1($12)
	);

begin
	
  	process (address)
		begin
		  data <= memory(to_integer(unsigned(address)))
	end process;
end instruction_memory_arc;