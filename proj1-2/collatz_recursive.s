# CS61C Sp14 Project 1-2
# Task A: The Collatz conjecture

.globl main
.include "collatz_common.s"

main:
	jal read_input			# Get the number we wish to try the Collatz conjecture on
	move $a0, $v0			# Set $a0 to the value read
	la $a1, collatz_recursive	# Set $a1 as ptr to the function we want to execute
	jal execute_function		# Execute the function
	li $v0, 10			# Exit
	syscall
	
# --------------------- DO NOT MODIFY ANYTHING ABOVE THIS POINT ---------------------

# Returns the stopping time of the Collatz function (the number of steps taken till the number reaches one)
# using an RECURSIVE approach. This means that if the input is 1, your function should return 0.
#
# The current value is stored in $a0, and you may assume that it is a positive number.
#
# Make sure to follow all function call conventions.
collatz_recursive:
	addi 	$sp, $sp, -24
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)
	
	add	$v0, $0, $0 #set counter
	beq 	$a0, 1, end #input is 1
	addi	$v0, $0, 1 #increment counter
	andi 	$s0, $a0, 1 #check if even or odd
	beq 	$s0, $0, even #go to even
	
odd:
	addi	$s2, $0, 3 #store 3
	mult	$s2, $a0 #3*n
	mflo	$s2 #store 3*n in $s2
	addi	$a0, $s2, 1 #reset argument to 3*n + 1
	add	$s3, $v0, $0 #store current v0
	jal 	collatz_recursive
	add	$v0, $s3, $v0 #add current v0 to recursive call v0
	j	end 
	
	
even:
	addi 	$s1, $0, 2 #store 2
	div	$a0, $a0, $s1 #divide n by 2
	add	$s4, $v0, $0 #store current v0
	jal	collatz_recursive
	add	$v0, $s4, $v0 #add current v0 to recursive call v0
	j	end
	
end:	
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw 	$s1, 8($sp)
	lw 	$s0, 4($sp)
	lw	$ra, 0($sp)
	addi 	$sp, $sp, 24
	jr 	$ra
