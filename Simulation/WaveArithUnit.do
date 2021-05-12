onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Testbench IO Signals}
add wave -noupdate /Tb_ArithUnit/Clock
add wave -noupdate /Tb_ArithUnit/Reset
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/A
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/B
add wave -noupdate /Tb_ArithUnit/NotA
add wave -noupdate /Tb_ArithUnit/ExtWord
add wave -noupdate /Tb_ArithUnit/Enable
add wave -noupdate -height 25 /Tb_ArithUnit/OpCode
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/Yupper
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/Ylower
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/Tb_Yupper
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/Tb_Ylower
add wave -noupdate /Tb_ArithUnit/Cout
add wave -noupdate /Tb_ArithUnit/Ovfl
add wave -noupdate /Tb_ArithUnit/Zero
add wave -noupdate /Tb_ArithUnit/AltB
add wave -noupdate /Tb_ArithUnit/AltBu
add wave -noupdate /Tb_ArithUnit/Ready
add wave -noupdate -divider -height 25 {ArithUnit Internal Signals}
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/Ain
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/Bin
add wave -noupdate /Tb_ArithUnit/DUT/AddnSub
add wave -noupdate /Tb_ArithUnit/DUT/AddEnable
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/AdderOut
add wave -noupdate /Tb_ArithUnit/DUT/AddReady
add wave -noupdate /Tb_ArithUnit/DUT/Addcarryout
add wave -noupdate /Tb_ArithUnit/DUT/Addoverflow
add wave -noupdate /Tb_ArithUnit/DUT/MulEnable
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/Product_upper
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/Product_lower
add wave -noupdate /Tb_ArithUnit/DUT/MulReady
add wave -noupdate /Tb_ArithUnit/DUT/MulOvfl
add wave -noupdate /Tb_ArithUnit/DUT/DivEnable
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/Quotient
add wave -noupdate -height 25 -radix hexadecimal /Tb_ArithUnit/DUT/Remainder
add wave -noupdate /Tb_ArithUnit/DUT/DivReady
