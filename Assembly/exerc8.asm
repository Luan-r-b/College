.data
vetor: .word 0,1,2,3,4,5,6,7,8,9,10

.text
la $a0, vetor
li $a1, 11
move $t0, $zero		# t0 = 0

loop:
sll $t1, $t0, 2		# t1 *= 4
add $t2, $a0, $t1	# Addres adds t1 to its index
sw $zero, 0($t2)	# Addres in t2 is zeroed
addi $t0, $t0, 1	# t0 ++
slt $t3, $t0, $a1	# if t0 < a1(lenght of vector) then t3 = 1
bne $t3, $zero, loop	# if t0 != 0, go to loop

#Esta função zera o valor de um vetor
#This function zeroes the values of an array
