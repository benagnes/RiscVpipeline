library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

Entity ArithUnit is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 ); -- operands
	--AddY : out std_logic_vector( N-1 downto 0 ); -- output: AddY comes directly from Adder, not defined 
	--Y : out std_logic_vector( N-1 downto 0 ); -- output: Y is post sign-ext MUX
	
	-- on add, Y lower == post sign-ext Mux, Yupper == output directly from Adder
	-- on mul, lower and upper products produced
	-- on div, Ylower == quotient & Yupper == remainder
	Ylower, Yupper : out std_logic_vector(N-1 downto 0);
	-- Control signals
	NotA, ExtWord : in std_logic := '0';
	--AddnSub : in std_logic := '0';
	Clock, Enable, Reset : in std_logic;
	-- **************** probably need more bits to define mul and div operations (product/quotient/remainder > 64 bits)
	OpCode : in std_logic_vector(1 downto 0); -- 00 = add, 01 == sub, 10 == mul, 11 == div
	-- Status signals
	Cout, Ovfl, Zero, AltB, AltBu : out std_logic;
	Ready : out std_logic);
End Entity ArithUnit;

Architecture rtl of ArithUnit is
	-- components
	Component Adder is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 ); -- operands
		Y : out std_logic_vector( N-1 downto 0 ); -- output sum
		Cin : in std_logic;
		-- Control signals
		Clock, Reset, Enable : in std_logic;
		-- Status signals
		Ready, Cout, Ovfl : out std_logic );
	End Component;
	
	Component Multiplier is
	Generic ( N : natural := 64 );
	Port ( Multiplier, Multiplicand : in std_logic_vector( N-1 downto 0 ); -- operands
		Product_upper, Product_lower : out std_logic_vector( N-1 downto 0 ); -- output
		-- Control signals
		Clock, Reset, Enable : in std_logic;
		-- Status signals
		Ready : out std_logic;
		Ovfl : out std_logic );
	End Component;
	
	Component Divider is
	Generic ( N : natural := 64 );
	Port ( Dividend, Divisor : in std_logic_vector( N-1 downto 0 ); -- operands
		Quotient, Remainder : out std_logic_vector( N-1 downto 0 ); -- output
		-- Control signals
		Clock, Reset, Enable : in std_logic;
		-- Status signals
		Ready : out std_logic);
	End Component;

-- internal signals for Adder
	signal Ain,Bin,AdderOut : std_logic_vector(N-1 downto 0);
	signal AddnSub : std_logic;
	signal AddEnable, AddReady, Addcarryout, Addoverflow : std_logic;
-- internal signals for Multiplier
	signal Product_upper, Product_lower : std_logic_vector(N-1 downto 0);
	signal MulEnable, MulReady, MulOvfl : std_logic;
-- internal signals for Divider
	signal Quotient, Remainder : std_logic_vector(N-1 downto 0);
	signal DivEnable, DivReady : std_logic;

begin
	myAdder: Adder port map (Ain, Bin, AdderOut, AddnSub, Clock, Reset, AddEnable, AddReady, Addcarryout, Addoverflow);
	--Adder64: Carry_Skip_Adder port map (Ain,Bin,AdderOut,OpCode(0),carryout,overflow); -- instantiate Adder
	myMultiplier : Multiplier port map (Ain, Bin, Product_upper, Product_lower, Clock, Reset, MulEnable, MulReady, MulOvfl);
	
	myDivider : Divider port map(Ain, Bin, Quotient, Remainder, Clock, Reset, DivEnable, DivReady);
	
	--AddY <= AdderOut; -- adder output
	
	-- Adder status signal calculations
	--Zero <= nor_reduce(AdderOut);
	--Cout <= Addcarryout;
	--Ovfl <= Addoverflow;
	--AltBu <= not(Addcarryout);
	--AltB <= Addoverflow xor AdderOut(N-1);

	-- MUXes
	--with NotA select Ain <= A when '0', not(A) when others; -- 2:1 operand inversion MUX for input A
	
	--with AddnSub select Bin <= B when '0', not(B) when others; -- 2:1 operand inversion MUX for input B

	--with ExtWord select Y <= -- 2:1 sign-extension MUX
	--	(63 downto 32 => AdderOut(31)) & AdderOut(31 downto 0) when '1', AdderOut when others;

 -- controls when Adder/Mul/Div is used and when signals are written out
	process(Clock, Enable, Reset, OpCode, AddReady, MulReady, DivReady)
	begin
		if (Reset = '1') then
			Ain <= (others => '0');
			Bin <= (others => '0');
			AddnSub <= '0';

			-- Reset Enable and Busy signals
			AddEnable <= '0';
			MulEnable <= '0';
			DivEnable <= '0';

		elsif (rising_edge(Clock)) then
			-- need enable to go high for one cycle to trigger an operation
			-- OpCode decoder and Invert inputs case, triggered by Arithmetic Unit enable
			if (Enable = '1') then
				case (OpCode) is -- if the unit required is not already busy we can go ahead. if busy it won't do anything
					when "00" => -- Add: Y = A + B
						if (AddEnable = '0') then
							Bin <= B;
							AddnSub <= '0';
							AddEnable <= '1';
							Ready <= '0';
						end if;
					when "01" => -- Subtract: Y = A - B, need to invert B
						if (AddEnable = '0') then
							Bin <= not(B);
							AddnSub <= '1';
							AddEnable <= '1';
							Ready <= '0';
						end if;
					when "10" => -- Multiplier
						if (MulEnable = '0') then
							Bin <= B;
							MulEnable <= '1';
							Ready <= '0';
						end if;
					when "11" => -- Divide
						if (DivEnable <= '0') then
							Bin <= B;
							DivEnable <= '1';
							Ready <= '0';
						end if;
					when others => -- if signal unknown/unstable, do nothing
						Ready <= '0';
				end case;
			
				if (NotA = '1') then -- option to invert input A
					Ain <= not(A);
				else
					Ain <= A;
				end if;
			-- compute outputs
			elsif (AddReady = '1') then -- Adder takes first priority
				if (ExtWord = '1') then
					Ylower <= (63 downto 32 => AdderOut(31)) & AdderOut(31 downto 0);
				else
					Ylower <= AdderOut;
				end if;
				--AddY <= AdderOut; -- raw Adder output
				Yupper <= AdderOut;
				
				-- status signal calculations
				Zero <= nor_reduce(AdderOut);
				Cout <= Addcarryout;
				Ovfl <= Addoverflow;
				AltBu <= not(Addcarryout);
				AltB <= Addoverflow xor AdderOut(N-1);
				
				-- disable adder, output ready
				AddEnable <= '0';
				Ready <= '1';
			elsif (MulReady = '1') then -- Multiplier outputs
				-- TODO: need to figure out what to do with upper product
				Ylower <= Product_lower;
				Yupper <= Product_upper;
				
				Ovfl <= MulOvfl;
				-- these signals don't matter for Mul and Div
				--AddY <= (others => '0');
				Zero <= '0';
				Cout <= '0';
				AltBu <= '0';
				AltB <= '0';
				
				-- disable Mul, output ready
				MulEnable <= '0';
				Ready <= '1';
				
			elsif (DivReady = '1') then -- Divider outputs
				-- TODO: need to figure out what to do with Remainder
				Ylower <= Quotient;
				Yupper <= Remainder;
				
				-- Should figure out how to calculate over/underflow for Divider? Carry-out might matter too?
				Ovfl <= '0';
				Cout <= '0';
				-- Don't matter for Divider
				--AddY <= (others => '0');
				Zero <= '0';
				AltBu <= '0';
				AltB <= '0';
				
				-- disable Div, output ready
				DivEnable <= '0';
				Ready <= '1';
			end if;
		end if;
	end process;
end rtl;

