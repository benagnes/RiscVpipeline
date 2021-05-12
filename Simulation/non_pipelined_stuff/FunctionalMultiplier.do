quit -sim
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/Full_Adder.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/Carry_Skip_Block.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/Adder_Skip.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/Multiplier.vhd

vcom -work work -2008 -explicit -stats=none TB_Multiplier.vhd

#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.TB_Multiplier -t 100ps
transcript off
do waveMultiplier.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 1500 ns
wave zoom full