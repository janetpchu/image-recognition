##### Variables #####
.data
# Header for dense matrix
head:		.asciiz	"  -----0----------1----------2----------3----------4----------5----------6----------7----------8----------9-----\n"

##### print_dense function code #####
.text
# print_dense will have 3 arguments: $a0 = address of dense matrix, $a1 = matrix width, $a2 = matrix height
print_dense:

    	addu  	$sp, $sp, -24
    	sw    	$ra, 0($sp)
    	sw    	$s0, 4($sp)	#row counter
    	sw    	$s1, 8($sp)	#column counter
    	sw    	$s2, 12($sp)	#height
    	sw    	$s3, 16($sp)	#width
    	sw    	$s4, 20($sp)	#matrix pointer
	
	addu 	$s4, $a0, $0 	#copy address to dense matrix into $s4
	
	la	$a0, head	# load header
	jal 	print_str
	
	addu	$s0, $0, $0	#start row counter at 0
	addu 	$s1, $0, $0	#start col counter at 0
	
	addu	$a0, $s0, $0	#print first row index
	jal	print_int
	jal	print_space
	addi	$s0, $s0, 1	#increment row counter
	
Row:	
	lw	$a0, 0($s4)	#load matrix
	jal	print_intx 	
	jal	print_space
	addi	$s4, $s4, 4 	#increment address
	addi	$s1, $s1, 1	#increment col counter
	beq	$s1, $a1, Column
	j	Row		#loop if still on the same row
	
Column:	
	jal	print_newline	#next line
	beq	$s0, $a2, End
	addu	$a0, $s0, $0	#print row index
	jal	print_int	
	jal	print_space
	addi	$s0, $s0, 1	#increment row counter	
	addu	$s1, $0, $0	#reset row counter
	j 	Row

End:	
	lw	$s4, 20($sp)
	lw	$s3, 16($sp)
	lw	$s2, 12($sp)
	lw 	$s1, 8($sp)
	lw 	$s0, 4($sp)
	lw	$ra, 0($sp)
	addu 	$sp, $sp, 24
	jr 	$ra
