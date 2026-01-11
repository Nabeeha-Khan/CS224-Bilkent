.data
message1: .asciiz "\nEnter the dividend: "
message2: .asciiz "\nEnter the divisor: "
message3: .asciiz "\nQuotient: "
message4: .asciiz "\nTerminating Code!"

.text
Main:
	interface:
		#Prompt to ask dividend
		la $a0, message1
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $v0, $zero,  5
		syscall
		#check if dividend is zero (end code)
		beq $v0, $zero, endInterface
		#Move divident to $s0
		addi $s0, $v0, 0
	
		#Prompt to ask divisor
		la $a0, message2
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $v0, $zero,  5
		syscall
		#check if divisor is zero (end code)
		beq $v0, $zero, endInterface
		#Move divisor to $s1
		addi $s1, $v0, 0
	
		#Calling subprogram
		addi $a0, $s0, 0
		addi $a1, $s1, 0
		addi $v0, $zero, 0    #set quotient to zero
		jal Division
		addi $s2, $v0, 0     #$s2 contains quotient
	
		#Display quotient
		la $a0, message3
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $a0, $s2, 0
		addi $v0, $zero,  1
		syscall
		
		#Repeat loop
		j interface
		
	endInterface:
		#Ending message
		la $a0, message4
		addi $v0, $zero, 4
		syscall
		#Ending program
		addi $v0, $zero, 10
		syscall
	
Division:
	beq $a1, $zero, end
	blt $a0, $a1, end
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	sub $a0, $a0, $a1
	jal Division
	addi $v0, $v0, 1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	end: 
		jr $ra
