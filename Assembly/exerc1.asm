.data
x: .word 30
y: .word 10
z: .word 20

.text 
lw $s0, x
lw $s1, y
lw $s2, z

add $t0, $s0, 300	# t0 = x + 300
sub $t0, $t0, $s1	# t0 = t0 - y
add $t0 $t0, 27		# t0 = t0 + 37
add $t0, $t0, $s2	# t0 = t0 + z
add $t0, $t0, $s0 	# t0 = t0 + x
sw $t0, x		# x = t0
