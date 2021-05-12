library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;
Use std.env.stop;


Entity Tb_ArithUnit is
Generic ( N : natural := 64 );
End Entity Tb_ArithUnit;

Architecture behavioural of Tb_ArithUnit is
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;

	-- DUT inputs
	Signal Clock, Reset, Enable : std_logic := '0';
	Signal A, B : std_logic_vector( N-1 downto 0 );
	Signal NotA, ExtWord : std_logic;
	Signal OpCode : std_logic_vector(1 downto 0);
	
	-- DUT outputs
	Signal Ylower, Yupper : std_logic_vector( N-1 downto 0 );
	Signal Cout, Ovfl, Zero, AltB, AltBu : std_logic;
	Signal Ready : std_logic;
	
	-- Testbench correct values to compare ArithUnit output with
	Signal Tb_Ylower, Tb_Yupper : std_logic_vector( N-1 downto 0 );
	Signal Tb_Cout, Tb_Ovfl, Tb_Zero, Tb_AltB, Tb_AltBu : std_logic;

-- use a component for the DUT. Use the same Entityname and Port Spec
-- use default binding rules.
	Component ArithUnit is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 ); -- operands
		--AddY : out std_logic_vector( N-1 downto 0 ); -- output: AddY comes directly from Adder, not defined 
		--Y : out std_logic_vector( N-1 downto 0 ); -- output: Y is post sign-ext MUX
		
		-- on add, Y lower == post sign-ext Mux, Yupper == output directly from Adder
		-- on mul, lower and upper products produced
		-- on div, Ylower == Ylower & Yupper == Yupper
		Ylower, Yupper : out std_logic_vector(N-1 downto 0);
		-- Control signals
		NotA, ExtWord : in std_logic := '0';
		--AddnSub : in std_logic := '0';
		Clock, Enable, Reset : in std_logic;
		-- **************** probably need more bits to define mul and div operations (product/Ylower/Yupper > 64 bits)
		OpCode : in std_logic_vector(1 downto 0); -- 00 = add, 01 == sub, 10 == mul, 11 == div ****** probably need to make this more bits since have multiple mul and div instructions
		-- Status signals
		Cout, Ovfl, Zero, AltB, AltBu : out std_logic;
		Ready : out std_logic);
	End Component;

	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	--Reset <= '0', '1' after ResetPeriod;

DUT: component ArithUnit generic map( N => N )
		port map ( A=>A, B=>B, Ylower=>Ylower, Yupper=>Yupper, NotA=>NotA, ExtWord=>ExtWord, Clock=>Clock, Enable=>Enable, Reset=>Reset, 
					OpCode=>OpCode, Cout=>Cout, Ovfl=>Ovfl, Zero=>Zero, AltB=>AltB, AltBu=>AltBu, Ready=>Ready);
-- *****************************************************************************
-- Now the main process for generating stimulii and response.	
-- *****************************************************************************
STIM:	Process is	
	Begin
		--Wait until Reset = '1';

		-- 3 * 2 == 6
		A <= x"0000000000000003";
		B <= x"0000000000000002";
		NotA <= '0';
		ExtWord <= '0';
		OpCode <= "10"; -- MUL
		Tb_Ylower <= x"0000000000000006";
		Tb_Yupper <= x"0000000000000000";
		Tb_Cout <= '0';
		Tb_Ovfl <= '0';
		Tb_Zero <= '0';
		Tb_AltB <= '0';
		Tb_AltBu <= '0';

		Wait for 2 ns;

		Reset <= '1';
		Wait for 2 ns;
		Reset <= '0';
		
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';

		Wait until Ready = '1';
		--Enable <= '0';
		--Wait for 2 ns; 

		If Ylower /= Tb_Ylower then		
			assert Ylower = Tb_Ylower
				Report
				"Ylower = " & to_hstring(Ylower) & CR &
				"Tb_Ylower = " & to_hstring(Tb_Ylower)
				Severity error;
		End If;

		If Yupper /= Tb_Yupper then		
			assert Yupper = Tb_Yupper
				Report
				"Yupper = " & to_hstring(Yupper) & CR &
				"Tb_Yupper = " & to_hstring(Tb_Yupper)
				Severity error;
		End If;
		
		If Cout /= Tb_Cout then		
			assert Cout = Tb_Cout
				Report
				"Cout = " & to_string(Cout) & CR &
				"Tb_Cout = " & to_string(Tb_Cout)
				Severity error;
		End If;
		
		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Cout
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;
		
		If Zero /= Tb_Zero then		
			assert Zero = Tb_Zero
				Report
				"Zero = " & to_string(Zero) & CR &
				"Tb_Zero = " & to_string(Tb_Zero)
				Severity error;
		End If;

		If AltB /= Tb_AltB then		
			assert AltB = Tb_AltB
				Report
				"AltB = " & to_string(AltB) & CR &
				"Tb_AltB = " & to_string(Tb_AltB)
				Severity error;
		End If;
		
		If AltBu /= Tb_AltBu then		
			assert AltBu = Tb_AltBu
				Report
				"AltBu = " & to_string(AltBu) & CR &
				"Tb_AltBu = " & to_string(Tb_AltBu)
				Severity error;
		End If;
		
		-- break up time btwn ops
		wait for 10 ns;
		
		-- 100 + 150 == 250
		A <= x"0000000000000064";
		B <= x"0000000000000096";
		NotA <= '0';
		ExtWord <= '0';
		OpCode <= "00"; -- ADD
		-- Since no sign ext upper/lower should be the same
		Tb_Ylower <= x"00000000000000FA";
		Tb_Yupper <= x"00000000000000FA";
		Tb_Cout <= '0';
		Tb_Ovfl <= '0';
		Tb_Zero <= '0';
		Tb_AltB <= '0';
		Tb_AltBu <= '1';

		Wait for 2 ns;		
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';
		Wait until Ready = '1';
		--Enable <= '0';
		--Wait for 2 ns; 

		If Ylower /= Tb_Ylower then		
			assert Ylower = Tb_Ylower
				Report
				"Ylower = " & to_hstring(Ylower) & CR &
				"Tb_Ylower = " & to_hstring(Tb_Ylower)
				Severity error;
		End If;

		If Yupper /= Tb_Yupper then		
			assert Yupper = Tb_Yupper
				Report
				"Yupper = " & to_hstring(Yupper) & CR &
				"Tb_Yupper = " & to_hstring(Tb_Yupper)
				Severity error;
		End If;
		
		If Cout /= Tb_Cout then		
			assert Cout = Tb_Cout
				Report
				"Cout = " & to_string(Cout) & CR &
				"Tb_Cout = " & to_string(Tb_Cout)
				Severity error;
		End If;
		
		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Cout
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;
		
		If Zero /= Tb_Zero then		
			assert Zero = Tb_Zero
				Report
				"Zero = " & to_string(Zero) & CR &
				"Tb_Zero = " & to_string(Tb_Zero)
				Severity error;
		End If;

		If AltB /= Tb_AltB then		
			assert AltB = Tb_AltB
				Report
				"AltB = " & to_string(AltB) & CR &
				"Tb_AltB = " & to_string(Tb_AltB)
				Severity error;
		End If;
		
		If AltBu /= Tb_AltBu then		
			assert AltBu = Tb_AltBu
				Report
				"AltBu = " & to_string(AltBu) & CR &
				"Tb_AltBu = " & to_string(Tb_AltBu)
				Severity error;
		End If;
		
		
		-- break up time btwn ops
		wait for 10 ns;
		
		-- 15 - 7 = 8
		A <= x"000000000000000F";
		B <= x"0000000000000007";
		NotA <= '0';
		ExtWord <= '0';
		OpCode <= "01"; -- SUB
		Tb_Ylower <= x"0000000000000008";
		Tb_Yupper <= x"0000000000000008";
		Tb_Cout <= '0';
		Tb_Ovfl <= '0';
		Tb_Zero <= '0';
		Tb_AltB <= '0';
		Tb_AltBu <= '1';

		Wait for 2 ns;		
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';
		Wait until Ready = '1';
		--Enable <= '0';
		--Wait for 2 ns; 

		If Ylower /= Tb_Ylower then		
			assert Ylower = Tb_Ylower
				Report
				"Ylower = " & to_hstring(Ylower) & CR &
				"Tb_Ylower = " & to_hstring(Tb_Ylower)
				Severity error;
		End If;

		If Yupper /= Tb_Yupper then		
			assert Yupper = Tb_Yupper
				Report
				"Yupper = " & to_hstring(Yupper) & CR &
				"Tb_Yupper = " & to_hstring(Tb_Yupper)
				Severity error;
		End If;
		
		If Cout /= Tb_Cout then		
			assert Cout = Tb_Cout
				Report
				"Cout = " & to_string(Cout) & CR &
				"Tb_Cout = " & to_string(Tb_Cout)
				Severity error;
		End If;
		
		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Cout
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;
		
		If Zero /= Tb_Zero then		
			assert Zero = Tb_Zero
				Report
				"Zero = " & to_string(Zero) & CR &
				"Tb_Zero = " & to_string(Tb_Zero)
				Severity error;
		End If;

		If AltB /= Tb_AltB then		
			assert AltB = Tb_AltB
				Report
				"AltB = " & to_string(AltB) & CR &
				"Tb_AltB = " & to_string(Tb_AltB)
				Severity error;
		End If;
		
		If AltBu /= Tb_AltBu then		
			assert AltBu = Tb_AltBu
				Report
				"AltBu = " & to_string(AltBu) & CR &
				"Tb_AltBu = " & to_string(Tb_AltBu)
				Severity error;
		End If;
		
		
		
		-- break up time btwn ops
		wait for 10 ns;
		
		-- 100 div 11 = 9 R 10
		A <= x"0000000000000064";
		B <= x"000000000000000B";
		NotA <= '0';
		ExtWord <= '0';
		OpCode <= "11"; -- DIV
		Tb_Ylower <= x"0000000000000009"; -- quotient = 9
		Tb_Yupper <= x"0000000000000001"; -- remainder should be 1
		Tb_Cout <= '0';
		Tb_Ovfl <= '0';
		Tb_Zero <= '0';
		Tb_AltB <= '0';
		Tb_AltBu <= '0';

		Wait for 2 ns;		
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';
		Wait until Ready = '1';
		--Enable <= '0';
		--Wait for 2 ns; 

		If Ylower /= Tb_Ylower then		
			assert Ylower = Tb_Ylower
				Report
				"Ylower = " & to_hstring(Ylower) & CR &
				"Tb_Ylower = " & to_hstring(Tb_Ylower)
				Severity error;
		End If;

		If Yupper /= Tb_Yupper then		
			assert Yupper = Tb_Yupper
				Report
				"Yupper = " & to_hstring(Yupper) & CR &
				"Tb_Yupper = " & to_hstring(Tb_Yupper)
				Severity error;
		End If;
		
		If Cout /= Tb_Cout then		
			assert Cout = Tb_Cout
				Report
				"Cout = " & to_string(Cout) & CR &
				"Tb_Cout = " & to_string(Tb_Cout)
				Severity error;
		End If;
		
		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Cout
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;
		
		If Zero /= Tb_Zero then		
			assert Zero = Tb_Zero
				Report
				"Zero = " & to_string(Zero) & CR &
				"Tb_Zero = " & to_string(Tb_Zero)
				Severity error;
		End If;

		If AltB /= Tb_AltB then		
			assert AltB = Tb_AltB
				Report
				"AltB = " & to_string(AltB) & CR &
				"Tb_AltB = " & to_string(Tb_AltB)
				Severity error;
		End If;
		
		If AltBu /= Tb_AltBu then		
			assert AltBu = Tb_AltBu
				Report
				"AltBu = " & to_string(AltBu) & CR &
				"Tb_AltBu = " & to_string(Tb_AltBu)
				Severity error;
		End If;

		wait for 20 ns;
		Report "Simulation Completed";
		stop;
	End Process STIM;
		
End Architecture behavioural;

