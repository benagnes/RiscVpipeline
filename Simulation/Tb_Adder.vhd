library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;
Use std.env.stop;


Entity Tb_Adder is
Generic ( N : natural := 64 );
End Entity Tb_Adder;

Architecture behavioural of Tb_Adder is
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;

	Signal Clock, Resetn : std_logic := '0';
	Signal A, B, Y, TbY : std_logic_vector( N-1 downto 0 );
	Signal Cin, Cout, Ovfl : std_logic;
	Signal TbCout, TbOvfl : std_logic;
	Signal Enable, Ready : std_logic := '0';

-- use a component for the DUT. Use the same Entityname and Port Spec
-- use default binding rules.
	component Adder is
	Generic ( N : natural := 64 );
	Port ( A, B : in std_logic_vector( N-1 downto 0 ); -- operands
		Y : out std_logic_vector( N-1 downto 0 ); -- output sum
		Cin : in std_logic;
		-- Control signals
		Clock, Reset, Enable : in std_logic;
		-- Status signals
		Ready, Cout, Ovfl : out std_logic );
	End component;
	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	--Resetn <= '0', '1' after ResetPeriod;

DUT: component Adder generic map( N => N )
		port map ( A=>A, B=>B, Y=>Y, Cin=>Cin, Clock=>Clock, Reset=>Resetn, Enable=>Enable, Ready=>Ready, Cout=>Cout, Ovfl=>Ovfl );
-- *****************************************************************************
-- Now the main process for generating stimulii and response
-- *****************************************************************************
STIM:	Process is	
	Begin
		-- async reset
		Resetn <= '0';
		Enable <= '0';
		Wait for 4 ns;

		Resetn <= '1';
		Wait for 4 ns;

		Resetn <= '0';

		-- simple add
		A <= x"0000000000000003";
		B <= x"0000000000000003";
		Cin <= '0';
		Enable <= '1';
		TbY <= x"0000000000000006";
		TbCout <= '0';
		TbOvfl <= '0';
		Wait for ClockPeriod;
		
		Wait until Ready <= '1';
		Enable <= '0';
		wait for ClockPeriod;

		If Y /= TbY then		
			assert Y = TbY
				Report
				"  Y = " & to_hstring(Y) & CR &
				"TbY = " & to_hstring(TbY)
				Severity error;
		End If;

		If Cout /= TbCout then		
			assert Cout = TbCout
				Report
				"  Cout = " & to_string(Cout) & CR &
				"TbCout = " & to_string(TbCout)
				Severity error;
		End If;

		If Ovfl /= TbOvfl then		
			assert Ovfl = TbOvfl
				Report
				"  Ovfl = " & to_string(Ovfl) & CR &
				"TbOvfl = " & to_string(TbOvfl)
				Severity error;
		End If;
		
		wait for ClockPeriod;
		

		-- simple next case
		A <= x"000000000000000F";
		B <= x"000000000000000F";
		Cin <= '0';
		Enable <= '1';
		TbY <= x"000000000000001E";
		TbCout <= '0';
		TbOvfl <= '0';
		wait for ClockPeriod;

		Wait until Ready <= '1';
		Enable <= '0';

		If Y /= TbY then		
			assert Y = TbY
				Report
				"  Y = " & to_hstring(Y) & CR &
				"TbY = " & to_hstring(TbY)
				Severity error;
		End If;

		If Cout /= TbCout then		
			assert Cout = TbCout
				Report
				"  Cout = " & to_string(Cout) & CR &
				"TbCout = " & to_string(TbCout)
				Severity error;
		End If;

		If Ovfl /= TbOvfl then		
			assert Ovfl = TbOvfl
				Report
				"  Ovfl = " & to_string(Ovfl) & CR &
				"TbOvfl = " & to_string(TbOvfl)
				Severity error;
		End If;

		wait for ClockPeriod;


		A <= x"8888888888888888";
		B <= x"8888888888888888";
		Cin <= '1';
		Enable <= '1';
		TbY <= x"1111111111111111";
		TbCout <= '1';
		TbOvfl <= '1';
		wait for ClockPeriod;

		Wait until Ready <= '1';
		Enable <= '0';

		If Y /= TbY then		
			assert Y = TbY
				Report
				"  Y = " & to_hstring(Y) & CR &
				"TbY = " & to_hstring(TbY)
				Severity error;
		End If;

		If Cout /= TbCout then		
			assert Cout = TbCout
				Report
				"  Cout = " & to_string(Cout) & CR &
				"TbCout = " & to_string(TbCout)
				Severity error;
		End If;

		If Ovfl /= TbOvfl then		
			assert Ovfl = TbOvfl
				Report
				"  Ovfl = " & to_string(Ovfl) & CR &
				"TbOvfl = " & to_string(TbOvfl)
				Severity error;
		End If;

		wait for ClockPeriod;

		A <= x"FFFFFFFFFFFFFFFF";
		B <= x"FFFFFFFFFFFFFFFF";
		Cin <= '1';
		Enable <= '1';
		TbY <= x"FFFFFFFFFFFFFFFF";
		TbCout <= '1';
		TbOvfl <= '0';
		wait for ClockPeriod;

		Wait until Ready <= '1';
		Enable <= '0';

		If Y /= TbY then		
			assert Y = TbY
				Report
				"  Y = " & to_hstring(Y) & CR &
				"TbY = " & to_hstring(TbY)
				Severity error;
		End If;

		If Cout /= TbCout then		
			assert Cout = TbCout
				Report
				"  Cout = " & to_string(Cout) & CR &
				"TbCout = " & to_string(TbCout)
				Severity error;
		End If;

		If Ovfl /= TbOvfl then		
			assert Ovfl = TbOvfl
				Report
				"  Ovfl = " & to_string(Ovfl) & CR &
				"TbOvfl = " & to_string(TbOvfl)
				Severity error;
		End If;

		wait for ClockPeriod;

		Report "Simulation Completed";
		stop;
	End Process STIM;
		
End Architecture behavioural;


