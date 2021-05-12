quit -sim
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
#vcom -work work -refresh -force_refresh

vcom -work work -2008 -explicit -stats=none ../SourceCode/Adder.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/Multiplier.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/Divider.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/ArithUnit.vhd

vcom -work work -2008 -explicit -stats=none Tb_ArithUnit.vhd

#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.Tb_ArithUnit -t 100ps
do WaveArithUnit.do
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 2000 ns
wave zoom full