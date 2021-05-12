library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 64 bit signed multiplier
entity Multiplier is
Generic ( N : natural := 64 );
Port ( Multiplier, Multiplicand : in std_logic_vector( N-1 downto 0 ); -- operands
	Product_upper, Product_lower : out std_logic_vector( N-1 downto 0 ); -- output
	-- Control signals
	Clock, Reset, Enable : in std_logic;
	-- Status signals
	Ready : out std_logic;
	Ovfl : out std_logic );
End Entity Multiplier;

Architecture rtl of Multiplier is
	-- internal signals
	signal Add_Out : std_logic_vector(N-1 downto 0);
	signal add_cout, add_ovfl : std_logic;
	signal Product : std_logic_vector(N*2 downto 0); -- 64*2 + 1 bits

	signal Counter : integer range 0 to 129; 

	-- components
	--component Adder_Skip is
	--Generic ( N : natural := 64 );
	--Port ( A, B : in std_logic_vector( N-1 downto 0 ); -- operands
	--	Y : out std_logic_vector( N-1 downto 0 ); -- output
		-- Control signals
	--	Cin : in std_logic;
		-- Status signals
	--	Cout, Ovfl : out std_logic );
	--End component;

begin

	-- component instantiations
	--Adder64: Adder_Skip port map (('0' & Product((N*2 -1) downto N+1)),Multiplicand,Add_Out,Product(N),add_cout,add_ovfl); -- Product(N*2 downto N+1)

	-- asynchronous reset
	process(Clock, Reset, Enable)
	begin
		if(Reset = '1') then
			-- reset internal signals
			Product <= (others => '0');
			Counter <= 0;

			-- reset outputs
			Product_upper <= (others => '0');
			Product_lower <= (others => '0');
			Ready <= '0';
		elsif (rising_edge(Clock)) then
			-- begin multiplier logic
			if (Enable = '1') then -- enable needs to be high for at least 1 clock cycle to trigger multiplier
				--Counter <= 0;
				Ready <= '0';
			--elsif (Counter = 0) then
				Product <= (N*2 downto N => '0') & Multiplier; -- (N-1 downto 0)
				--Counter <= Counter + 1;
				Counter <= 1;
			elsif (Counter = 129) then -- done computing
				Product_upper <= Product(N*2 - 1 downto N);
				Product_lower <= Product(N-1 downto 0);
				Ovfl <= Product(N*2);
				Ready <= '1';
				Counter <= 0;
			elsif ((Counter mod 2) = 0) then -- shift product on EVEN counter cycle
				Product <= std_logic_vector(shift_right(unsigned(Product),1));
				Counter <= Counter + 1;	
			else -- add upper product and multiplicand IF Product(0) == '1' on ODD counter cycle
				if (Product(0) = '1') then
					--Product <= add_cout & Add_Out & Product(N-1 downto 0);
					Counter <= Counter + 1;
					-- need to add here, seems that using the instantiated Adder doesn't add the shifted product
					Product <= std_logic_vector(unsigned('0' & Product(127 downto 64)) + unsigned(Multiplicand)) & Product(N-1 downto 0);
				else -- shift and increment counter by 2 to skip to next Product(0) check
					Product <= std_logic_vector(shift_right(unsigned(Product),1));
					Counter <= Counter + 2; -- increment counter by 2 to get to next Multiplier check stage
				end if;
			end if;
		end if;
	end process;

end rtl;
