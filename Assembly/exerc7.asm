.data
x: .word 1
y: .word 3
z: .word 3

.text

lw $s0, x
lw $s1, y
lw $s2, z
li $t1, 0

slt  $t0, $s1, $zero	#If $s1 less than zero then $t0 == 1
beq $t0, 1, end		#Branch to verify the above statement
ble $s1, $t1, end	#branch if Y less than zero

loop:
mul $s0, $s0, $s2	#x = x * z
add $t1, $t1, 1		#i++
blt $t1,$s1,loop	#Return to loop if i less than y

end:
sw $s0, x		#Store the value 