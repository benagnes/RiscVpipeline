onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_Multiplier/Clock
add wave -noupdate /TB_Multiplier/Resetn
add wave -noupdate -divider {DUT Signals}
add wave -noupdate -height 30 \
sim:/tb_multiplier/DUT/Clock \
sim:/tb_multiplier/DUT/Reset \
sim:/tb_multiplier/DUT/Enable
add wave -noupdate -height 50 -radix decimal \
sim:/tb_multiplier/DUT/Multiplier \
sim:/tb_multiplier/DUT/Multiplicand \
sim:/tb_multiplier/DUT/Product \
sim:/tb_multiplier/DUT/Product_upper \
sim:/tb_multiplier/DUT/Product_lower
add wave -noupdate -height 30 \
sim:/tb_multiplier/DUT/Ready \
sim:/tb_multiplier/DUT/Ovfl
add wave -noupdate -divider {Testbench Correct Outputs}
add wave -noupdate -height 50 -radix decimal \
sim:/tb_multiplier/Tb_Product_upper \
sim:/tb_multiplier/Tb_Product_lower
add wave -noupdate -height 30 sim:/tb_multiplier/Tb_Ovfl
add wave -noupdate -height 40 -radix decimal sim:/tb_multiplier/DUT/Counter
