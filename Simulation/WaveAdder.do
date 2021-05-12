onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Tb_Adder/Clock
add wave -noupdate /Tb_Adder/Resetn
add wave -noupdate -divider {DUT IO Signals}
add wave -noupdate -height 40 -radix hexadecimal /Tb_Adder/A
add wave -noupdate -height 40 -radix hexadecimal /Tb_Adder/B
add wave -noupdate -height 25 \
/Tb_Adder/Cin \
/Tb_Adder/Ready \
/Tb_Adder/Cout \
/Tb_Adder/Ovfl
add wave -noupdate -height 40 -radix hexadecimal /Tb_Adder/Y
add wave -noupdate -height 40 -radix hexadecimal /Tb_Adder/TbY
add wave -noupdate -divider -height 25 {Adder Control Signals}
add wave -noupdate -height 25 \
/Tb_Adder/DUT/Clock \
/Tb_Adder/DUT/Reset \
/Tb_Adder/DUT/Enable
add wave -noupdate -divider -height 25 {Adder Status Signals}
add wave -noupdate -height 25  \
/Tb_Adder/DUT/Ready \
/Tb_Adder/DUT/Cout \
/Tb_Adder/DUT/Ovfl
add wave -noupdate -divider {Adder internal Signals}
add wave -noupdate -height 25 -radix decimal Tb_Adder/DUT/Counter
add wave -noupdate -height 25 -radix hexadecimal \
/Tb_Adder/DUT/partial_Sum \
/Tb_Adder/DUT/Sum_Reg
TreeUpdate [SetDefaultTree]
quietly wave cursor active 1
configure wave -namecolwidth 160
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
