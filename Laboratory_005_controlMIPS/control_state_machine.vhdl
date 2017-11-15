library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity controlStateMachine is
  port (
		clk: in	std_logic;
		reset: in std_logic;
		opcode: in std_logic_vector(5 downto 0);

		-- OUTPUTS:
		PCWrite: out std_logic;
		RegDst: out std_logic;
		Jump: out std_logic;
		Branch: out std_logic;
		MemRead: out std_logic;
		MemtoReg: out std_logic;
		ALUOp: out std_logic_vector(1 downto 0);
		MemWrite: out std_logic;
		ALUSrc: out std_logic;
		RegWrite: out std_logic
			
	);
end entity ; -- controlStateMachine

architecture arch of controlStateMachine is

	type mipsControl is (s0, s1, s2, s3, s4, s5, s6, s7, s8);

	signal state : mipsControl;

begin
	process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			
			case state is
				when s0=>
					state <= s1;

				when s1=>
					case opcode is
						when "000010" => -- JUMP
							state <= s4;
						when "000100" => -- BEQ
							state <= s7;
						when "000000" => -- R-Type
							state <= s6;
						when "100011" | "101011" => -- LW or SW
							state <= s2;
						------------
						when "001000" => -- ADDI instruction
							state <= s8;
						when others =>
							null;
					end case;
					
				when s2=>
					case opcode  is
						when "100011" => -- LW
							state <= s3; 
						when "101011" => -- SW
							state <= s5;
						when others =>
							null;
					end case;
					
				when s3=>
					state <= s0; -- BACK TO s0

				when s4=>
					state <= s0; -- BACK TO s0

				when s5=>
					state <= s0; -- BACK TO s0

				when s6=>
					state <= s0; -- BACK TO s0

				when s7=>
					state <= s0; -- BACK TO s0

				when s8=>
					state <= s0; -- BACK TO s0
			
				when others =>
					null;

			end case;
			
		end if;
	end process;

	process (state)
	begin
		case state is
			when s0=>
				PCWrite <= '0';
				RegDst <= '0';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				Branch <= '0';
				ALUOp <= "00";
				Jump <= '0';
				
			when s1=>
				ALUSrc <= '0';
				ALUOp <= "00";

			when s2=>
				ALUSrc <= '1';
				ALUOp <= "00"; -- Redundant but explicit

			when s3=>
				MemtoReg <= '1';
				RegWrite <= '1';
				MemRead <= '1';
				PCWrite <= '1';

			when s4=>
				Jump <= '1';
				PCWrite <= '1';

			when s5=>
				MemWrite <= '1';
				PCWrite <= '1';

			when s6=>
				RegDst <= '1';
				RegWrite <= '1';
				ALUOp <= "10";
				PCWrite <= '1';

			when s7=>
				Branch <= '1';
				ALUOp <= "01";
				PCWrite <= '1';

			when s8=>
				RegDst <= '0';
				RegWrite <= '1';
				ALUSrc <= '1';
				ALUOp <= "00";
				PCWrite <= '1';
			
			when others =>
				null;
		end case;
	end process;

end architecture; -- arch
