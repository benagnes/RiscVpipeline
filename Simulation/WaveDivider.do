onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Tb_Divider/Clock
add wave -noupdate /Tb_Divider/Reset
add wave -noupdate -divider {Testbench Signals and Correct Outputs}
add wave -noupdate -height 40 -radix decimal \
sim:/Tb_Divider/A \
sim:/Tb_Divider/B \
sim:/Tb_Divider/Tb_Quotient \
sim:/Tb_Divider/Tb_Remainder
add wave -noupdate -divider {DUT IO Signals}
add wave -noupdate -height 25 \
sim:/Tb_Divider/DUT/Clock \
sim:/Tb_Divider/DUT/Reset \
sim:/Tb_Divider/DUT/Enable
add wave -noupdate -height 40 -radix decimal \
sim:/Tb_Divider/DUT/Dividend \
sim:/Tb_Divider/DUT/Divisor \
sim:/Tb_Divider/DUT/Quotient \
sim:/Tb_Divider/DUT/Remainder
add wave -noupdate -divider {Divider Internal Signals}
add wave -noupdate -height 40 -radix hexadecimal \
sim:/Tb_Divider/DUT/Divisor_Reg \
sim:/Tb_Divider/DUT/Quotient_Reg \
sim:/Tb_Divider/DUT/Remainder_Reg
add wave -noupdate -height 30 sim:/Tb_Divider/DUT/Ready
add wave -noupdate -divider {Divider Counter}
add wave -noupdate -height 40 -radix decimal sim:/Tb_Divider/DUT/Counter
