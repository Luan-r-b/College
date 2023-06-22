.data
conta: .word 0,0,0,0,0,0,0,0,0

.text
la $s6, conta
li $t0, 0
li $t1, 0

loop:
li $a1, 100 	#Set the max bound.
li $v0, 42	#Generates the random number 42 is system call for random int
syscall 	#'Saves' the generated number at $a0

sw $a0, ($s6)	#Saves the generated number in the array
add $s6, $s6, 4 #Adds 4 (go to the next index) in the addres
add $t1, $t1, 1	#Add 1 to T1
ble $t1, 9, loop#Check if should repeat the loop

main:

lw, $s1, -12($s6)#Loading conta[7] in s1
lw, $s2, -28($s6)#Loading conta[3] in s2

add $t0, $s1, $s2#Adding s1 and s2 in t0
srl $s0, $t0, 1	 #Doing the average of to numbers by taking the sum and dividing by 2
