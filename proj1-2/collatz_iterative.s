# CS61C Sp14 Project 1-2
# Task A: The Collatz conjecture

.globl main
.include "collatz_common.s"

main:
	jal read_input			# Get the number we wish to try the Collatz conjecture on
	move $a0, $v0			# Set $a0 to the value read
	la $a1, collatz_iterative	# Set $a1 as ptr to the function we want to execute
	jal execute_function		# Execute the function
	li $v0, 10			# Exit
	syscall
	
# --------------------- DO NOT MODIFY ANYTHING ABOVE THIS POINT ---------------------

# Returns the stopping time of the Collatz function (the number of steps taken till the number reaches one)
# using an ITERATIVE approach. This means that if the input is 1, your function should return 0.
#
# The initial value is stored in $a0, and you may assume that it is a positive number.
# 
# Make sure to follow all function call conventions.
collatz_iterative:
	# YOUR CODE HERE
	
	addiu	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	
	
	move 	$s0, $0 #counter
	move	$s2, $a0 #copy of input
	
begin:
	beq 	$s2, 1, end #equals one
	addi 	$s0, $s0, 1 #increment counter
	andi 	$s1, $s2, 1 #check if even or odd
	beq 	$s1, $0, even #go to even
odd:	
	addi 	$s4, $0, 3 #set to 3
	mult 	$s4, $s2 	#multiply by 3
	mflo 	$t0 #move 3*n to $t0
	addi 	$s2, $t0, 1 #add 3*n + 1
	j 	begin #iterate again 
	
	
even: 			#divide the number by 2
	addi 	$s3, $0, 2 #set to 2
	div 	$s2, $s2, $s3 #divide number by 2
	j 	begin #iterate again
	
end:
	addi 	$v0, $s0, 0
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
