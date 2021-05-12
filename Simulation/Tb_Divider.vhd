library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;
Use std.env.stop;


Entity Tb_Divider is
Generic ( N : natural := 64 );
End Entity Tb_Divider;

Architecture behavioural of Tb_Divider is
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;

	Signal Clock, Reset, Enable : std_logic := '0';
	Signal A, B, Quotient, Remainder, Tb_Quotient, Tb_Remainder : std_logic_vector( N-1 downto 0 );
	Signal Ready : std_logic;

-- use a component for the DUT. Use the same Entityname and Port Spec
-- use default binding rules.
	Component Divider is
	Generic ( N : natural := 64 );
	Port ( Dividend, Divisor : in std_logic_vector( N-1 downto 0 ); -- operands
		Quotient, Remainder : out std_logic_vector( N-1 downto 0 ); -- output
		-- Control signals
		Clock, Reset, Enable : in std_logic;
		-- Status signals
		Ready : out std_logic);
	End Component;
	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	--Reset <= '0', '1' after ResetPeriod;

DUT: component Divider generic map( N => N )
		port map ( Dividend=>A, Divisor=>B, Quotient=>Quotient, Remainder=>Remainder, 
				Clock=>Clock, Reset=>Reset, Enable=>Enable, Ready=>Ready);
-- *****************************************************************************
-- Now the main process for generating stimulii and response.	
-- *****************************************************************************
STIM:	Process is	
	Begin
		--Wait until Reset = '1';

		-- 7 divided by 3 = 2 R1
		A <= x"0000000000000006";
		B <= x"0000000000000003";
		Tb_Quotient <= x"0000000000000002";
		Tb_Remainder <= x"0000000000000000";
		Wait for 2 ns;

		Reset <= '1';
		Wait for 2 ns;
		Reset <= '0';
		
		Enable <= '1';
		Wait for 2 ns;

		Wait until Ready = '1';
		Enable <= '0';
		Wait for 2 ns; 

		If Quotient /= Tb_Quotient then		
			assert Quotient = Tb_Quotient
				Report
				"Quotient = " & to_hstring(Quotient) & CR &
				"Tb_Quotient = " & to_hstring(Tb_Quotient)
				Severity error;
		End If;

		If Remainder /= Tb_Remainder then		
			assert Remainder = Tb_Remainder
				Report
				"Remainder = " & to_hstring(Remainder) & CR &
				"Tb_Remainder = " & to_hstring(Tb_Remainder)
				Severity error;
		End If;
		
		-- 11 / 3 = 3 R2
		A <= x"000000000000000B";
		B <= x"0000000000000003";
		Tb_Quotient <= x"0000000000000003";
		Tb_Remainder <= x"0000000000000002";
		Wait for 2 ns;
		
		Enable <= '1';
		Wait for 2 ns;

		Wait until Ready = '1';
		Enable <= '0';
		Wait for 2 ns;
		
		If Quotient /= Tb_Quotient then		
			assert Quotient = Tb_Quotient
				Report
				"Quotient = " & to_hstring(Quotient) & CR &
				"Tb_Quotient = " & to_hstring(Tb_Quotient)
				Severity error;
		End If;

		If Remainder /= Tb_Remainder then		
			assert Remainder = Tb_Remainder
				Report
				"Remainder = " & to_hstring(Remainder) & CR &
				"Tb_Remainder = " & to_hstring(Tb_Remainder)
				Severity error;
		End If;
		
		-- 128 / 5 = 25 R 3
		A <= x"0000000000000080";
		B <= x"0000000000000005";
		Tb_Quotient <= x"0000000000000019";
		Tb_Remainder <= x"0000000000000003";
		Wait for 2 ns;
		
		Enable <= '1';
		Wait for 2 ns;

		Wait until Ready = '1';
		Enable <= '0';
		Wait for 2 ns;
		
		If Quotient /= Tb_Quotient then		
			assert Quotient = Tb_Quotient
				Report
				"Quotient = " & to_hstring(Quotient) & CR &
				"Tb_Quotient = " & to_hstring(Tb_Quotient)
				Severity error;
		End If;

		If Remainder /= Tb_Remainder then		
			assert Remainder = Tb_Remainder
				Report
				"Remainder = " & to_hstring(Remainder) & CR &
				"Tb_Remainder = " & to_hstring(Tb_Remainder)
				Severity error;
		End If;

		wait for 20 ns;
		Report "Simulation Completed";
		stop;
	End Process STIM;
		
End Architecture behavioural;

