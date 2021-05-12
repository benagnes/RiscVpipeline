library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Clocked Adder. Completes 64 bit add in 17 cycles
Entity Adder is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 ); -- operands
	Y : out std_logic_vector( N-1 downto 0 ); -- output sum
	Cin : in std_logic;
	-- Control signals
	Clock, Reset, Enable : in std_logic;
	-- Status signals
	Ready, Cout, Ovfl : out std_logic );
End Entity Adder;

Architecture rtl of Adder is

	-- counter to count cycles
	signal Counter : integer range 0 to 17; -- 1 clock cycle to initialize values, 16 clock cycles to compute result (16 iterations of carry-skip block)
	-- registers to hold sum and carry bits while propogated
	signal Sum_Reg : std_logic_vector(N-1 downto 0);
	signal partial_Sum : std_logic_vector(4 downto 0);
	
	signal c1,c2,c3,c4 : std_logic; -- for calculating overflow
begin

	process (Clock, Reset, Enable)
	begin
		if (Reset = '1') then
			Ready <= '0'; -- reset ready
			Counter <= 0; -- reset counter
			Sum_Reg <= (others => '0');
			
			c1 <= '0';
			c2 <= '0';
			c3 <= '0';
			c4 <= '0';
		elsif (rising_edge(Clock)) then
			if (Enable = '1') then -- enable must be high for the entire calculation
				case (Counter) is
					when 0 =>
						partial_Sum <= ('0' & A(3 downto 0)) + ('0' & B(3 downto 0)) + Cin;
						Ready <= '0';
						Counter <= Counter + 1;
					when 1 =>
						Sum_Reg <= Sum_Reg(N-1 downto 4) & partial_Sum(3 downto 0);
						partial_Sum <= ('0' & A(7 downto 4)) + ('0' & B(7 downto 4)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 2 =>
						Sum_Reg <= Sum_Reg(N-1 downto 8) & partial_Sum(3 downto 0) & Sum_Reg(3 downto 0);
						partial_Sum <= ('0' & A(11 downto 8)) + ('0' & B(11 downto 8)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 3 =>
						Sum_Reg <= Sum_Reg(N-1 downto 12) & partial_Sum(3 downto 0) & Sum_Reg(7 downto 0);
						partial_Sum <= ('0' & A(15 downto 12)) + ('0' & B(15 downto 12)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 4 =>
						Sum_Reg <= Sum_Reg(N-1 downto 16) & partial_Sum(3 downto 0) & Sum_Reg(11 downto 0);
						partial_Sum <= ('0' & A(19 downto 16)) + ('0' & B(19 downto 16)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 5 =>
						Sum_Reg <= Sum_Reg(N-1 downto 20) & partial_Sum(3 downto 0) & Sum_Reg(15 downto 0);
						partial_Sum <= ('0' & A(23 downto 20)) + ('0' & B(23 downto 20)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 6 =>
						Sum_Reg <= Sum_Reg(N-1 downto 24) & partial_Sum(3 downto 0) & Sum_Reg(19 downto 0);
						partial_Sum <= ('0' & A(27 downto 24)) + ('0' & B(27 downto 24)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 7 =>
						Sum_Reg <= Sum_Reg(N-1 downto 28) & partial_Sum(3 downto 0) & Sum_Reg(23 downto 0);
						partial_Sum <= ('0' & A(31 downto 28)) + ('0' & B(31 downto 28)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 8 =>
						Sum_Reg <= Sum_Reg(N-1 downto 32) & partial_Sum(3 downto 0) & Sum_Reg(27 downto 0);
						partial_Sum <= ('0' & A(35 downto 32)) + ('0' & B(35 downto 32)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 9 =>
						Sum_Reg <= Sum_Reg(N-1 downto 36) & partial_Sum(3 downto 0) & Sum_Reg(31 downto 0);
						partial_Sum <= ('0' & A(39 downto 36)) + ('0' & B(39 downto 36)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 10 =>
						Sum_Reg <= Sum_Reg(N-1 downto 40) & partial_Sum(3 downto 0) & Sum_Reg(35 downto 0);
						partial_Sum <= ('0' & A(43 downto 40)) + ('0' & B(43 downto 40)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 11 =>
						Sum_Reg <= Sum_Reg(N-1 downto 44) & partial_Sum(3 downto 0) & Sum_Reg(39 downto 0);
						partial_Sum <= ('0' & A(47 downto 44)) + ('0' & B(47 downto 44)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 12 =>
						Sum_Reg <= Sum_Reg(N-1 downto 48) & partial_Sum(3 downto 0) & Sum_Reg(43 downto 0);
						partial_Sum <= ('0' & A(51 downto 48)) + ('0' & B(51 downto 48)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 13 =>
						Sum_Reg <= Sum_Reg(N-1 downto 52) & partial_Sum(3 downto 0) & Sum_Reg(47 downto 0);
						partial_Sum <= ('0' & A(55 downto 52)) + ('0' & B(55 downto 52)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 14 =>
						Sum_Reg <= Sum_Reg(N-1 downto 56) & partial_Sum(3 downto 0) & Sum_Reg(51 downto 0);
						partial_Sum <= ('0' & A(59 downto 56)) + ('0' & B(59 downto 56)) + partial_Sum(4);
						Counter <= Counter + 1;
					when 15 => -- critical case where overflow must be calculated
						Sum_Reg <= Sum_Reg(N-1 downto 60) & partial_Sum(3 downto 0) & Sum_Reg(55 downto 0);
						partial_Sum <= ('0' & A(63 downto 60)) + ('0' & B(63 downto 60)) + partial_Sum(4);
						-- calculate overflow here
						c1 <= ( A(60) and B(60) ) or ((A(60) or B(60)) and partial_Sum(4));
						c2 <= ( A(61) and B(61) ) or ((A(61) or B(61)) and c1);
						c3 <= ( A(62) and B(62) ) or ((A(62) or B(62)) and c2);
						c4 <= ( A(63) and B(63) ) or ((A(63) or B(63)) and c3);
						
						Counter <= Counter + 1;
						
					when 16 =>
						Sum_Reg <= partial_Sum(3 downto 0) & Sum_Reg(59 downto 0);
						Counter <= Counter + 1;
					when 17 =>
						Y <= Sum_Reg;
						--Cout <= partial_Sum(4);
						Cout <= c4;
						Ovfl <= c4 xor c3;
						
						Ready <= '1';
						Counter <= 0;
					when others => Ready <= '0';
				end case;
			else
				Ready <= '0';
			end if;
		end if;
	end process;
end rtl;
