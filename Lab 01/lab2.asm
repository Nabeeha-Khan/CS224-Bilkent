.data
message1: .asciiz "Array: "
message2: .asciiz "\nArray after reversing: "
space: .asciiz " "

array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90
arrSize: .word 9

.text
Main:
	la $s0, array
	lw $s1, arrSize
	
	#Printing message for printing array
	la $a0, message1
	li $v0, 4
	syscall
	#Calling subprogram for printing array
	addi $a0, $s0, 0    #passing array address to $a0
	addi $a1, $s1, 0    #passing array size to $a1
	jal PrintArray
	
	#Calling subprogram to reverse array
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	jal ReverseArray
	
	#Printing message for printing reversed array
	la $a0, message2
	li $v0, 4
	syscall
	#Calling subprogram for printing array
	addi $a0, $s0, 0    #passing array address to $a0
	addi $a1, $s1, 0    #passing array size to $a1
	jal PrintArray
	
	#Terminating program
	li $v0, 10
	syscall
	
PrintArray:
	addi $t0, $a0, 0   #base address
	addi $t1, $zero, 0    #i=0 (for looping)
	for1:
		beq $t1, $a1, end1    #check if i == arraySize 
		#To print integer value in array
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		#To print space between two integer value
		la $a0, space
		li $v0, 4
		syscall
		#Incrementing address and i
		addi $t0, $t0, 4
		addi $t1, $t1, 1
		j for1
	end1:
		jr $ra
	
ReverseArray:
	addi $t0, $zero, 0   #i = 0
	addi $t1, $a0, 0    #base address of 1st element
	addi $t2, $s1, -1    #index of last element
	sll $t2, $t2, 2   
	add $t2, $t2, $a0    #base address of last element
	sra $a1, $a1, 1   #size / 2
	for:
		bge $t0, $a1, end 
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t3, 0($t2)
		sw $t4, 0($t1)
		addi $t0, $t0, 1
		addi $t1, $t1, 4
		addi $t2, $t2, -4
		j for
	end:
		jr $ra

