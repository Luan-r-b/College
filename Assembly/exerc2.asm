.data 
a: .word 0
b: .word 0
c: .word 0
s: .word 0

.text
lw, $s0, a
lw, $s1, b
lw, $s2, c

and $t0, $s0, $s1 	# (a & b)
nor $t1, $s0, $zero	# !a
and $t2, $t1, $s2	# !a & c
or $t3, $t0, $t2	# (a & b) | (!a & c)
sw $t3, s 		# s = (a & b) | (!a & c)
