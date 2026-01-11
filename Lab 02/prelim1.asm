.data
message1: .asciiz "Enter the key (Enter zero to quit): "
message2: .asciiz "Enter the data: "
message3: .asciiz "\nInput linked list:\n"
message4: .asciiz "\nSummary linked list:\n"
message5: .asciiz "\nNumber of nodes in summary linked list: "
beginningBracket: .asciiz "-->("
comma: .asciiz ", "
endingBracket: .asciiz ")"

.text
Main:
	#Subprogram to create input linked list
	jal createInputLinkedList
	addi $s0, $v0, 0    #head of linked list
	addi $s1, $v1, 0    #size of linked list
	
	#Subprogram to display input linked list
	la $a0, message3
	addi $v0, $zero, 4
	syscall 
	addi $a0, $s0, 0
	jal printLinkedList
	
	#Subprogram to create summary linked list
	addi $a0, $s0, 0
	jal createSummaryLinkedList
	addi $s2, $v0, 0    #head of summary linked list
	addi $s3, $v1, 0    #size of summary linked list

	#Subprogram to display summary linked list
	la $a0, message4
	addi $v0, $zero, 4
	syscall 
	addi $a0, $s2, 0
	jal printLinkedList
	
	#Printing size of summary linked list
	la $a0, message5
	addi $v0, $zero, 4
	syscall 
	addi $a0, $s3, 0
	addi $v0, $zero, 1
	syscall
	
	#Terminating program
	addi $v0, $zero, 10
	syscall

createInputLinkedList:
	#Prompt to ask for key
	la $a0, message1
	addi $v0, $zero, 4
	syscall
	#Takes key input
	addi $v0, $zero, 5
	syscall
	#Check if $v0 contains zero (terminate if it does)
	bne $v0, $zero, createHeadNote
	addi $v0, $zero, 0 
	addi $v1, $zero, 0
	jr	$ra     #return an empty linked list
	createHeadNote:
		addi	$sp, $sp, -20
		sw	$s0, 16($sp)    #no of nodes
		sw	$s1, 12($sp)   #current node
		sw	$s2, 8($sp)    #head of linked list
		sw	$s3, 4($sp)    #data value
		sw	$s4, 0($sp)    #key value
		addi $s4, $v0, 0   #add input value in key
		addi $s0, $zero, 1   #increment no of nodes to 1
		#Prompt to take data field
		la $a0, message2
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $v0, $zero, 5
		syscall
		#Move the input in value register
		addi $s3, $v0, 0
		# Create the first node: header.
		# Each node is 12 bytes: link field, key field, and then data field.
		addi	$a0, $zero,  12
		addi	$v0, $zero, 9
		syscall
		#Put the created node in list head and current node 
		addi	$s1, $v0, 0	# $s1 points to the first and last node of the linked list.
		addi	$s2, $v0, 0	# $s2 now points to the list head.
		#Add value and key in created node
		sw $s4, 4($s1)   #key
		sw $s3, 8($s1)	 #value
	addNode:
		#Prompt to ask for key
		la $a0, message1
		addi $v0, $zero, 4
		syscall
		#Takes key input
		addi $v0, $zero, 5
		syscall
		#Check if $v0 contains zero (terminate if it does)
		beq	$v0, $zero, allDone
		addi $s4, $v0, 0   #add input value in key
		addi	$s0, $s0, 1	# Increment node counter.
		#Prompt to take data field
		la $a0, message2
		addi $v0, $zero, 4
		syscall
		#Take input value
		addi $v0, $zero, 5
		syscall
		#Move the input in value register
		addi $s3, $v0, 0
		#Create another node
		addi	$a0, $zero,  12
		addi	$v0, $zero, 9
		syscall
		# Connect the this node to the lst node pointed by $s1.
		sw	$v0, 0($s1)
		# Now make $s1 pointing to the newly created node.
		addi	$s1, $v0, 0	# $s1 now points to the new node.
		#Add value and key in created node
		sw $s4, 4($s1)   #key
		sw $s3, 8($s1)	 #value
		j	addNode
	allDone:
		# Make sure that the link field of the last node cotains 0.
		# The last node is pointed by $s1.
		sw	$zero, 0($s1)
		addi	$v0, $s2, 0	# Now $v0 points to the list head ($s2).
		addi	$v1, $s0, 0     #$v1 contains the no of nodes in the list
		# Restore the register values
		lw	$s4, 0($sp)
		lw	$s3, 4($sp)
		lw	$s2, 8($sp)
		lw	$s1, 12($sp)
		lw	$s0, 16($sp)
		addi	$sp, $sp, 20
	jr	$ra
	
createSummaryLinkedList:
	bne $a0, $zero, createSummaryHeadNode
	addi $v0, $zero, 0
	addi $v1, $zero, 0
	jr	$ra    #return an empty list
	createSummaryHeadNode:
		addi	$sp, $sp, -32
		sw	$s0, 28($sp)    #no of nodes
		sw	$s1, 24($sp)   #current node
		sw	$s2, 20($sp)    #head of linked list
		sw	$s3, 16($sp)    #data value
		sw	$s4, 12($sp)    #key value
		sw 	$s5, 8($sp)    #current node of input linked list
		sw	$s6, 4($sp)    #next node of input linked list
		sw 	$s7, 0($sp)	#temp variable to store value of current node
		#move head of input linked list in $s5
		addi $s5, $a0, 0
		#incement node counter
		addi $s0, $zero, 1
		#move content in node to registers
		lw $s6, 0($s5)   #next node
		lw $s4, 4($s5)   #key
		lw $s3, 8($s5)	 #value
		# Create the first node: header.
		# Each node is 12 bytes: link field, key field, and then data field.
		addi	$a0, $zero,  12
		addi	$v0, $zero, 9
		syscall
		#Put the created node in list head and current node 
		addi	$s1, $v0, 0	# $s1 points to the first and last node of the linked list.
		addi	$s2, $v0, 0	# $s2 now points to the list head.
		#add key and value in the current node
		sw 	$s4, 4($s1)
		sw	$s3, 8($s1)
		#Move to next node
		addi 	$s5, $s6, 0
	addSummaryNode:
		beq $s5, $zero, done
		#move content in node to registers
		lw $s6, 0($s5)   #next node
		lw $s4, 4($s5)   #key
		lw $s3, 8($s5)	 #value
		#Take key of current node of new list
		lw $s7, 4($s1)
		#branch to add the value in current node of old list in current node of new list if their keys are equal
		beq $s7, $s4, addValueOfNode
		#Create another node
		addi	$a0, $zero,  12
		addi	$v0, $zero, 9
		syscall
		# Connect the this node to the lst node pointed by $s1.
		sw	$v0, 0($s1)
		#Put the created node in and current node 
		addi	$s1, $v0, 0
		#incement node counter
		addi $s0, $s0, 1
		#add key and value in the current node
		sw 	$s4, 4($s1)
		sw	$s3, 8($s1)
		#Move to next node
		addi 	$s5, $s6, 0
		j	addSummaryNode
	addValueOfNode:
		#Take value of current node of new list
		lw $s7, 8($s1)
		#add value of current node of new an old list
		add $s7, $s7, $s3
		#store the new value in cureent node of new list
		sw	$s7, 8($s1)
		#Move to next node
		addi 	$s5, $s6, 0
		j	addSummaryNode		
	done:
		# Make sure that the link field of the last node cotains 0.
		# The last node is pointed by $s1.
		sw	$zero, 0($s1)
		addi	$v0, $s2, 0	# Now $v0 points to the list head ($s2).
		addi	$v1, $s0, 0     #$v1 contains the no of nodes in the list
		# Restore the register values
		lw	$s7, 0($sp)
		lw	$s6, 4($sp)
		lw	$s5, 8($sp)
		lw	$s4, 12($sp)
		lw	$s3, 16($sp)
		lw	$s2, 20($sp)
		lw	$s1, 24($sp)
		lw	$s0, 28($sp)
		addi	$sp, $sp, 32
	jr	$ra

printLinkedList:
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)    #address of current
	sw	$s1, 12($sp)	#address of next
	sw	$s2, 8($sp)	#key of current
	sw	$s3, 4($sp)	#value of current
	sw	$s4, 0($sp) 	#node counter

	addi $s0, $a0, 0
	addi $s4, $zero, 0
	printNextNode:
		beq $s0, $zero, printedAll     #check if $s0 == null
		lw $s1, 0($s0)    #move next node address in $s1
		lw $s2, 4($s0)	  #move current key in $s2
		lw $s3, 8($s0)	  #move current value in $s3
		addi $s4, $s4, 1   #increment node counter
		
		#printing node
		la $a0, beginningBracket
		addi $v0, $zero, 4
		syscall 
		#print key
		addi $a0, $s2, 0
		addi $v0, $zero, 1
		syscall
		la $a0, comma
		addi $v0, $zero, 4
		syscall 
		#print value
		addi $a0, $s3, 0
		addi $v0, $zero, 1
		syscall
		la $a0, endingBracket
		addi $v0, $zero, 4
		syscall 
		
		addi $s0, $s1, 0  #move address of next node to current node
		j printNextNode
	printedAll:
		lw	$s4, 0($sp)
		lw	$s3, 4($sp)
		lw	$s2, 8($sp)
		lw	$s1, 12($sp)
		lw	$s0, 16($sp)
		addi	$sp, $sp, 20
		
	jr	$ra
