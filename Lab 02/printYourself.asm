	.text
# Write a program that prints its instructions in hex form:
# Display instructions in hex from next to done: [next, done]
# MARS settings: Self Modifying code option must be turned on:
# Mark Settings/Self-modifying code
start:
	la	$t0, start
	la	$t1, done
	
next:	
	bgt	$t0, $t1, done
# Load the instruction pointed by $t0 to $$a0
	lw	$a0, 0($t0)	
	li	$v0, 34		# Print contents of $a in hex
	syscall	
	
# Print new line
	la	$a0, newLine
	li	$v0, 4
	syscall
	
# Advance program pointer.
	addi	$t0, $t0, 4

	j	next
done:	
	addi	$v0, $zero, 10
	syscall
	
	.data
newLine:
	.asciiz	"\n"
	

