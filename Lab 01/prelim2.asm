.data
message1: .asciiz "Enter array size: "
message2: .asciiz "\nEnter a valid array size!\n"
message3: .asciiz "\nEnter a positive integer: "
message4: .asciiz "\nArray: "
message5: .asciiz "\nFrequency Table: "
space: .asciiz " "

FreqTable: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
Main:
	#Calling subprogram to create array
	jal CreateInitArray
	addi $s0, $v0, 0   #base address of arr
	addi $s1, $v1, 0   #size of arr
	
	#Printing values in array
	la $a0, message4
	li $v0, 4
	syscall
	#Adding array parameters for subprogram
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	jal PrintArray
	
	#Adding FreqTable into reg
	la $s2, FreqTable   #base address of FreqTable
	li $s3, 10   #size of FreqTable
	
	#Finding Frequency using subprogram
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	addi $a2, $s2, 0
	jal FindFreq
	
	#Printing FreqTable 
	la $a0, message5
	li $v0, 4
	syscall
	#Adding FreqTable parameters for subprogram
	addi $a0, $s2, 0
	addi $a1, $s3, 0
	jal PrintArray
	
	#Terminating program
	li $v0, 10
	syscall
	
CreateInitArray:
	for:
		#prompt to ask for array size
		la $a0, message1
		li $v0, 4
		syscall
		#takes integer input
		li $v0, 5
		syscall
		#branch if size > 0
		bgt $v0, $zero, end
		#error message
		la $a0, message2
		li $v0, 4
		syscall
		j for
	end:
		addi $t0, $v0, 0    #$t0 = size of array
		
	#Calculating number of bytes
	sll $a0, $t0, 2     #$a0 = $t0 * 4 
	#Dynamic array allocation
	li $v0, 9
	syscall
	addi $t1, $v0, 0   #$t1 = base address of array
	
	addi $t2, $zero, 0   # i = 0
	addi $t3, $t1, 0   #base addr
	for1:
		beq $t2, $t0, end1
		forInner: 
			#prompt to ask for array size
			la $a0, message3
			li $v0, 4
			syscall
			#takes integer input
			li $v0, 5
			syscall
			#branch if size >= 0
			bge $v0, $zero, endInner
			j forInner
		endInner:
			sw $v0, 0($t3)   #arr[i] = $v0
		addi $t2, $t2, 1
		addi $t3, $t3, 4
		j for1	
	end1: 
		addi $v0, $t1, 0
		addi $v1, $t0, 0
		jr $ra
		
PrintArray:
	addi $t0, $a0, 0   #base address
	addi $t1, $zero, 0    #i=0 (for looping)
	for2:
		beq $t1, $a1, end2    #check if i == arraySize 
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
		j for2
	end2:
		jr $ra

FindFreq:
	addi $t0, $zero, 0   #i = 0
	for3:
		beq $t0, $a1, end3    #check if i == arraySize
		
		lw $t1, 0($a0)   #arr[i]
		beq $t1, 0, case0
		beq $t1, 1, case1
		beq $t1, 2, case2
		beq $t1, 3, case3
		beq $t1, 4, case4
		beq $t1, 5, case5
		beq $t1, 6, case6
		beq $t1, 7, case7
		beq $t1, 8, case8
		beq $t1, 9, case9
		j endSwitch
		
		case0:
			lw $t2, 0($a2)    #$t2 = FreqTable[0]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 0($a2)    #storing new value
			j endSwitch
		case1:
			lw $t2, 4($a2)    #$t2 = FreqTable[1]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 4($a2)    #storing new value
			j endSwitch
		case2:
			lw $t2, 8($a2)    #$t2 = FreqTable[2]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 8($a2)    #storing new value
			j endSwitch
		case3:
			lw $t2, 12($a2)    #$t2 = FreqTable[3]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 12($a2)    #storing new value
			j endSwitch
		case4:
			lw $t2, 16($a2)    #$t2 = FreqTable[4]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 16($a2)    #storing new value
			j endSwitch
		case5:
			lw $t2, 20($a2)    #$t2 = FreqTable[5]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 20($a2)    #storing new value
			j endSwitch
		case6:
			lw $t2, 24($a2)    #$t2 = FreqTable[6]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 24($a2)    #storing new value
			j endSwitch
		case7:
			lw $t2, 28($a2)    #$t2 = FreqTable[7]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 28($a2)    #storing new value
			j endSwitch
		case8:	
			lw $t2, 32($a2)    #$t2 = FreqTable[8]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 32($a2)    #storing new value
			j endSwitch
		case9:
			lw $t2, 36($a2)    #$t2 = FreqTable[9]
			addi $t2, $t2, 1   #incrementing freq
			sw $t2, 36($a2)    #storing new value
		endSwitch:
			#Incrementing base address and i
			addi $t0, $t0, 1
			addi $a0, $a0, 4
			j for3
	end3:
		jr $ra 
