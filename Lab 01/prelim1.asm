.data
message1: .asciiz "Array: "
message2: .asciiz "\nSum: "
message3: .asciiz "\nMaximum: "
message4: .asciiz "\nMinimum: "
message5: .asciiz "\nEnter the array position whose frequency you want to check: "
message6: .asciiz "\nEnter a valid array position!"
message7: .asciiz "\nFrequency: "
space: .asciiz " "

array: .word 2, 4, 5, 2, 5, 0, 4, 0, 0, 4
arrSize: .word 10

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
	
	#Computing sum by calling subprogram
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	jal FindSum
	#Add sum into $t0
	addi $t0, $v0, 0  
	  
	#Print sum
	la $a0, message2
	li $v0, 4
	syscall
	addi $a0, $t0, 0
	li $v0, 1
	syscall	
	
	#Computing min and max by calling subprogram
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	jal FindMinMax
	#add min into $t1
	addi $t1, $v0, 0
	#add max into $t2
	addi $t2, $v1, 0
	
	#Printing min value
	la $a0, message3
	li $v0, 4
	syscall
	addi $a0, $t1, 0
	li $v0, 1
	syscall
	
	#Printing max value
	la $a0, message4
	li $v0, 4
	syscall
	addi $a0, $t2, 0
	li $v0, 1
	syscall
	
	loop:
		#Prompt to ask for index position
		la $a0, message5
		li $v0, 4
		syscall
		#Take integer input 
		li $v0, 5
		syscall
		bgt $v0, $zero, end   #branches if integer value is positive
		#Error message
		la $a0, message6
		li $v0, 4
		syscall
		j loop
	end:
		addi $t3, $v0, -1   #index of arr = $v0 - 1 (Since $v0 will be in form of 1st, 2nd, etc.)

	#Finding array location
	sll $t3, $t3, 2    #multiply index by 4
	add $a2, $s0, $t3    #address of arr[index]
	#Finding frequency using subprogram
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	jal CountAnEntry
	addi $t4, $v0, 0      #$t4 = freq
	
	#Pinting prompt
	la $a0, message7
	li $v0, 4
	syscall
	#Printing frequency
	addi $a0, $t4, 0
	li $v0, 1
	syscall
	
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
	
FindSum:
	addi $v0, $zero, 0   #sum = 0
	addi $t0, $zero, 0   #i = 0
	for2:
		beq $t0, $a1, end2  #check if i == arraySize
		lw $t1, 0($a0)    #load arr[i] into $t1
		add $v0, $v0, $t1   #add arr[i] into sum
		addi $t0, $t0, 1   #increment i
		addi $a0, $a0, 4   #increment base address
		j for2
	end2:
		jr $ra

FindMinMax:
	lw $v0, 0($a0)     #min = arr[0]
	lw $v1, 0($a0)	   #max = arr[0]
	addi $t0, $zero, 1   #i = 1
	for3:
		beq $t0, $a1, end3    #check if i == arraySize
		lw $t1, 0($a0)   #load arr[i] into $t1
		blt $v0, $t1, nxtBranch   #branches if min < arr[i]
		addi $v0, $t1, 0
		nxtBranch: 
			bgt $v1, $t1, nxtBranch2   #branches if max > arr[i]
			addi $v1, $t1, 0
		nxtBranch2: 
			addi $t0, $t0, 1  #increment i
			addi $a0 $a0, 4   #increment base address
			j for3
	end3:
		jr $ra

CountAnEntry:
	lw $t0, 0($a2)    #arr[pos]
	addi $t1, $zero, 0      #i = 0
	addi $v0, $zero, 0   #freq = 0
	for4: 
		beq $t1, $a1, end4   #check if i == arraySize
		lw $t2, 0($a0)    #load arr[i] into $t2
		bne $t2, $t0, nxtBranch3    #branches if arr[pos] != arr[i]
		addi $v0, $v0, 1
		nxtBranch3:
			addi $t1, $t1, 1  #increment i
			addi $a0 $a0, 4   #increment base address
			j for4
	end4:
		jr $ra
	
