.data
vetor: .word 0,2,8

.text
la, $s4, vetor

lw $s0, 4($s4)		# s0 = vetor[1]
lw $s1, 8($s4)		# s1 = vetor[2]

add $t0, $s0, $s1	# t0 = vetor[1] + vetpr[2]

sw $t0, ($s4)		# vetor[0] = t0
