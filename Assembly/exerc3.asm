.data
a: .word 1
b: .word 2
c: .word 3
d: .word 4

.text
lw, $s0, a
lw, $s1, b
lw, $s2, c 
lw, $s3, d

add $t0, $s0, $s1	# a + b
add $t0, $t0, $s2	# a + b + c
add $t0, $t0, $s3	# a + b + c + d

sll $v0, $t0, 4		# valor = 4*(a + b + c + d)