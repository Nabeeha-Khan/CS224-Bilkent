.data
message1: .asciiz "\nEnter the matrix size: "
message2: .asciiz "\nRow major summation: "

.text
main:
	#Prompt to ask for matrix size (repeated until we get N > 0)
	matrixSize: 
		addi $v0, $zero, 4
		la $a0, message1
		syscall
	#Using syscall to allocate memory for matrix
	matrixAllocation:
		addi $s0, $zero, 150  #size of matrix
		mul $s1, $s0, $s0  #no of elements
		sll $a0, $s1, 2
		addi $v0, $zero, 9
		syscall
		addi $s2, $v0, 0  #beginning address of array
	#Initializing values in array
	matrixInitialization: 
		addi $a0, $s2, 0
		addi $a1, $s1, 0
		addi $a2, $zero, 0   #i = 0
		for: 
			slt $at, $a2, $a1
			beq $at, $zero, end
			addi $a2, $a2, 1
			sw $a2, 0($a0)
			addi $a0, $a0, 4
			j for
		end:
		
	#Calling row major summation function
	addi $a0, $s2, 0  #base address
	addi $a1, $s0, 0  #$s0 = N
	jal rowSummation
	
	#End program
	addi $v0, $zero, 10
	syscall
	
rowSummation:
	addi $t0, $a0, 0    #base address
	addi $t1, $a1, 0    #$t1 = N
	addi $t2, $zero, 0   #$t2 = i
	addi $t4, $zero, 0   #$t4 = sum
	addi $t5, $a0, 0   #current address
	for1:
		slt $at, $t2, $t1
		beq $at, $zero, end1
		addi $t3, $zero, 0   #$t3 = j
		forInner:
			slt $at, $t3, $t1
			beq $at, $zero, endInner
			lw $t6, 0($t5)
			add $t4, $t4, $t6
			addi $t3, $t3, 1
			sll $t6, $t1, 2
			add $t5, $t5, $t6
			j forInner
		endInner:
			addi $t2, $t2, 1
			sll $t5, $t2, 2
			add $t5, $t5, $t0
			j for1
	end1:
		#Printing result
		addi $v0, $zero, 4
		la $a0, message2
		syscall
		addi $v0, $zero, 1
		addi $a0, $t4, 0
		syscall
	#return to caller function
	jr $ra
