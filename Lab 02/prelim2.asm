.data
message1: .asciiz "\nEnter the number of register you want to check: "
message2: .asciiz "\nNo. of times the register is used: "
message3: .asciiz "\nTerminating program!"
 
.text
Main:
	for:
		#Prompt to ask the no of register to check
		la $a0, message1
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $v0, $zero,  5
		syscall
		#Check if input is less than zero
		blt $v0, 0, endMain
		#Check if input is greater than 31
		bgt $v0, 31, endMain
		addi $s0, $v0, 0    #register storing the no of register to check
		#Calling the subprogram
		addi $a0, $s0, 0
		jal RegisterCount_start
		addi $s1, $v0, 0     #register storing the no of occurance
		#Prompt to display the no of occurances
		la $a0, message2
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $a0, $s1, 0
		addi $v0, $zero,  1
		syscall
		j for
	endMain:
		#Prompt to end program
		la $a0, message3
		addi $v0, $zero, 4
		syscall
		#Ending program
		addi $v0, $zero, 10
		syscall
		
RegisterCount_start:
	#storing registers on stack
	addi $sp $sp, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	#Put the start and end of subprogram in register
	la $s0, RegisterCount_start 
	la $s1, RegisterCount_end
	addi $v0, $zero, 0   #counter
	next:
		bgt $s0, $s1, done
		lw $s2, 0($s0)
		#extracting opcode 
		srl $s3, $s2, 26
		andi $s3, $s3, 0x3F
	J_type:
		#Branch if op code == 2 (j has no registers)
		beq $s3, 2, end
		#Branch if op code == 3 (jal has no registers)
		beq $s3, 3, end
	rs:
		#extracting rs
		srl $s4, $s2, 21
		andi $s4, $s4, 0x1F
		#Branch to check next reg if rs and reg not equal
		bne $s4, $a0, rt
		addi $v0, $v0, 1
	rt:
		#extracting rt
		srl $s4, $s2, 16
		andi $s4, $s4, 0x1F
		#Branch to check next reg if rt and reg not equal
		bne $s4, $a0, rd
		addi $v0, $v0, 1
	rd:
		#Branch if opcode != 0
		bne $s3, $zero, end
		#extracting rd
		srl $s4, $s2, 11
		andi $s4, $s4, 0x1F
		#Branch to end if rd and reg not equal
		bne $s4, $a0, end
		addi $v0, $v0, 1
	end:
		addi $s0, $s0, 4      
		j	next
	done:
		#freeing stack
		lw $s4, 0($sp)
		lw $s3, 4($sp)
		lw $s2, 8($sp)
		lw $s1, 12($sp)
		lw $s0, 16($sp)
		addi $sp, $sp, 20
		#retun back to caller function
		jr 	$ra
RegisterCount_end:
