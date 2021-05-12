library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;
Use std.env.stop;


Entity TB_Multiplier is
Generic ( N : natural := 64 );
End Entity TB_Multiplier;

Architecture behavioural of TB_Multiplier is
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;

	Signal Clock, Resetn, Enable : std_logic := '0';
	Signal A, B, Product_upper, Product_lower, Tb_Product_upper, Tb_Product_lower : std_logic_vector( N-1 downto 0 );
	Signal Ready, Ovfl : std_logic;
	Signal Tb_Ovfl : std_logic;

-- use a component for the DUT. Use the same Entityname and Port Spec
-- use default binding rules.
	component Multiplier is
	Generic ( N : natural := 64 );
	Port ( Multiplier, Multiplicand : in std_logic_vector( N-1 downto 0 ); -- operands
		Product_upper, Product_lower : out std_logic_vector( N-1 downto 0 ); -- output
		-- Control signals
		Clock, Reset, Enable : in std_logic;
		-- Status signals
		Ready : out std_logic;
		Ovfl : out std_logic );
	End component;
	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	--Resetn <= '0', '1' after ResetPeriod;

DUT: component Multiplier generic map( N => N )
		port map ( Multiplier=>A, Multiplicand=>B, Product_upper=>Product_upper, Product_lower=>Product_lower, 
				Clock=>Clock, Reset=>Resetn, Enable=>Enable, Ready=>Ready, Ovfl=>Ovfl );
-- *****************************************************************************
-- Now the main process for generating stimulii and response.	
-- *****************************************************************************
STIM:	Process is	
	Begin
		--Wait until Resetn = '1';

		A <= x"0000000000000003";
		B <= x"0000000000000001";
		Tb_Product_upper <= x"0000000000000000";
		Tb_Product_lower <= x"0000000000000003";
		Tb_Ovfl <= '0';
		Wait for 2 ns;

		Resetn <= '1';
		Wait for 2 ns;
		Resetn <= '0';
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';

		Wait until Ready = '1';

		If Product_upper /= Tb_Product_upper then		
			assert Product_upper = Tb_Product_upper
				Report
				"Product_upper = " & to_hstring(Product_upper) & CR &
				"Tb_Product_upper = " & to_hstring(Tb_Product_upper)
				Severity error;
		End If;

		If Product_lower /= Tb_Product_lower then		
			assert Product_lower = Tb_Product_lower
				Report
				"Product_lower = " & to_hstring(Product_lower) & CR &
				"Tb_Product_lower = " & to_hstring(Tb_Product_lower)
				Severity error;
		End If;

		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Ovfl
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;

		-- test 9*3 == 27
		A <= x"0000000000000009";
		B <= x"0000000000000003";
		Tb_Product_upper <= x"0000000000000000";
		Tb_Product_lower <= x"000000000000001B";
		Tb_Ovfl <= '0';
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';
		wait for 2 ns;

		Wait until Ready = '1';

		If Product_upper /= Tb_Product_upper then		
			assert Product_upper = Tb_Product_upper
				Report
				"Product_upper = " & to_hstring(Product_upper) & CR &
				"Tb_Product_upper = " & to_hstring(Tb_Product_upper)
				Severity error;
		End If;

		If Product_lower /= Tb_Product_lower then		
			assert Product_lower = Tb_Product_lower
				Report
				"Product_lower = " & to_hstring(Product_lower) & CR &
				"Tb_Product_lower = " & to_hstring(Tb_Product_lower)
				Severity error;
		End If;

		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Ovfl
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;

		-- test 9*9 == 81
		A <= x"0000000000000009";
		B <= x"0000000000000009";
		Tb_Product_upper <= x"0000000000000000";
		Tb_Product_lower <= x"0000000000000051";
		Tb_Ovfl <= '0';
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';
		wait for 2 ns;

		Wait until Ready = '1';

		If Product_upper /= Tb_Product_upper then		
			assert Product_upper = Tb_Product_upper
				Report
				"Product_upper = " & to_hstring(Product_upper) & CR &
				"Tb_Product_upper = " & to_hstring(Tb_Product_upper)
				Severity error;
		End If;

		If Product_lower /= Tb_Product_lower then		
			assert Product_lower = Tb_Product_lower
				Report
				"Product_lower = " & to_hstring(Product_lower) & CR &
				"Tb_Product_lower = " & to_hstring(Tb_Product_lower)
				Severity error;
		End If;

		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Ovfl
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;

		-- test 12*12 = 144
		A <= x"000000000000000C";
		B <= x"000000000000000C";
		Tb_Product_upper <= x"0000000000000000";
		Tb_Product_lower <= x"0000000000000090";
		Tb_Ovfl <= '0';
		Enable <= '1';
		Wait for 2 ns;
		Enable <= '0';
		wait for 2 ns;

		Wait until Ready = '1';

		If Product_upper /= Tb_Product_upper then		
			assert Product_upper = Tb_Product_upper
				Report
				"Product_upper = " & to_hstring(Product_upper) & CR &
				"Tb_Product_upper = " & to_hstring(Tb_Product_upper)
				Severity error;
		End If;

		If Product_lower /= Tb_Product_lower then		
			assert Product_lower = Tb_Product_lower
				Report
				"Product_lower = " & to_hstring(Product_lower) & CR &
				"Tb_Product_lower = " & to_hstring(Tb_Product_lower)
				Severity error;
		End If;

		If Ovfl /= Tb_Ovfl then		
			assert Ovfl = Tb_Ovfl
				Report
				"Ovfl = " & to_string(Ovfl) & CR &
				"Tb_Ovfl = " & to_string(Tb_Ovfl)
				Severity error;
		End If;

		wait for 40 ns;
		Report "Simulation Completed";
		stop;
	End Process STIM;
		
End Architecture behavioural;

