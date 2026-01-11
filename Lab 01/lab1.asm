.data
message1: .asciiz "\nEnter a decimal number: "
message2: .asciiz "\nDecimal number in hexadecimal: "
message3: .asciiz "\nNumber in hexadecimal after exchanging: "
message4: .asciiz "\nDo you want to continue? (Enter 0 for No and 1 for Yes): "
message5: .asciiz "Terminating program!\n"

val: .word 0

.text
Main:
	for:
		#Take input value 
		la $a0, message1
		jal InputIntVal
		#Put the input value in $s0
		addi $s0, $v0, 0
		#Display input value in hex
		la $a0, message2
		jal DisplayRegVal
		#Exchange bytes
		la $s1, val    #$s1 stores address
		sw $s0, 0($s1)
		jal ExchangeRegBytes
		lw $s0, 0($s1)
		#Display exchanged value in hex
		la $a0, message3
		jal DisplayRegVal
		continue:
			#Prompt to continue
			la $a0, message4
			jal InputIntVal
			#Check if $v0 == 0
			beq $v0, $zero, end
			#Check if $v0 == 1
			beq $v0, 1, for
			#Ask again if invalid input
			j continue
	end:
		#Prompt to end program
		la $a0, message5
		li $v0, 4
		syscall
		#Ending program
		li $v0, 10
		syscall

InputIntVal:
	#Prompt to ask for decimal number ($a0 set by user before calling function)
	li $v0, 4
	syscall
	#Take decimal value
	li $v0, 5
	syscall
	#Return back to main
	jr $ra
	
DisplayRegVal:
	#Prompt to display reg value ($a0 set by user before calling function)
	li $v0, 4
	syscall
	#Display reg value in hex
	addi $a0, $s0, 0
	li $v0, 34
	syscall
	#Return back to main
	jr $ra

ExchangeRegBytes:
	#Taking 1st byte and storing in temp reg
	lb $t0, 0($s1)
	#Taking 2nd byte and storing in another temp reg
	lb $t1, 1($s1)
	#Exchanging 1st and 2nd bytes
	sb $t0, 1($s1)
	sb $t1, 0($s1)
	#Taking 3rd byte and storing in temp reg
	lb $t0, 2($s1)
	#Taking 4th byte and storing in another temp reg
	lb $t1, 3($s1)
	#Exchanging 3rd and 4th bytes
	sb $t0, 3($s1)
	sb $t1, 2($s1)
	#Return back to main
	jr $ra
