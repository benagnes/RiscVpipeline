library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 64 bit signed divider
Entity Divider is
Generic ( N : natural := 64 );
Port ( Dividend, Divisor : in std_logic_vector( N-1 downto 0 ); -- operands
	Quotient, Remainder : out std_logic_vector( N-1 downto 0 ); -- output
	-- Control signals
	Clock, Reset, Enable : in std_logic;
	-- Status signals
	Ready : out std_logic);
End Entity Divider;

Architecture rtl of Divider is -- TO-DO: refine divider to only have 64 bit ALU and Divisor, Remainder becomes 129 bits like Mul
	-- internal signals
	signal Remainder_Reg : std_logic_vector(N*2 -1 downto 0); -- 64*2
	signal Divisor_Reg : std_logic_vector(N*2 -1 downto 0);
	signal Quotient_Reg : std_logic_vector(N-1 downto 0);
	
	--signal Remainder_Reg : std_logic_vector(N*2 downto 0); -- 129 bits
	signal Counter : integer range 0 to 131; -- 130 + 1 cycles to finish operations -> 65 reps of algorithm + 1 to start
begin
	-- asynchronous reset
	process(Clock, Reset, Enable)
	begin
		if(Reset = '1') then
			-- reset internal signals
			Remainder_Reg <= (others => '0');
			Divisor_Reg <= (others => '0');
			Quotient_Reg <= (others => '0');
			
			Counter <= 0;
			Ready <= '0';
		elsif (rising_edge(Clock)) then
		
			if (Enable = '1') then
				if (Counter = 0) then
					Divisor_Reg <= Divisor & (63 downto 0 => '0'); --(others => '0');
					Remainder_Reg <= (N*2 -1 downto 64 => '0') & Dividend; -- (others => '0');
					Quotient_Reg <= (others => '0');
					Counter <= Counter + 1;
				elsif (Counter = 131) then -- 129 or 131???
					Counter <= 0;
					Ready <= '1';
					if (Dividend(N-1) /= Divisor(N-1)) then -- if operand signs different need to negate quotient
						Quotient <= '1' & Quotient_Reg(N-2 downto 0);
					else
						Quotient <= Quotient_Reg;
					end if;
					Remainder <= Remainder_Reg(N-1 downto 0); -- only take lower half of remainder?????
				elsif ((Counter mod 2) = 0) then -- on even clock cycle: shift quotient and restore remainder if < 0
					-- test remainder
					if (Remainder_Reg(N*2 -1) = '1') then -- remainder < 0 since dealing w/ signed numbers
					--if (signed(Remainder_Reg) < 0) then
						-- restore original remainder and shift quotient left setting LSB = '0'
						Remainder_Reg <= std_logic_vector(unsigned(Remainder_Reg) + unsigned(Divisor_Reg)); -- unsigned or signed???
						Quotient_Reg <= Quotient_Reg(N-2 downto 0) & '0'; --std_logic_vector(shift_left(unsigned(Quotient_Reg),1));
					else -- Remainder >= 0
						-- shift quotient left, setting LSB = '1'
						Quotient_Reg <= Quotient_Reg(N-2 downto 0) & '1';  -- std_logic_vector(shift_left(signed(Quotient_Reg),1));
					end if;
					-- shift divisor reg right 1 bit
					Divisor_Reg <= std_logic_vector(shift_right(unsigned(Divisor_Reg),1));
					
					Counter <= Counter + 1;
				else -- Remainder = Remainder - Divisor
					Remainder_Reg <= std_logic_vector(unsigned(Remainder_Reg) - unsigned(Divisor_Reg)); -- unsigned or signed???
					
					Counter <= Counter + 1;
				end if;
			else
				Ready <= '0';
			end if;
		end if;
	end process;
end rtl;