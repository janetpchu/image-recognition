
##### sparse2dense function code #####
.text
# sparse2dense will have 2 arguments: $a0 = address of sparse matrix data, $a1 = address of dense matrix, $a2 = matrix width
# Recall that sparse matrix representation uses the following format:
# Row r<y> {int row#, Elem *node, Row *nextrow}
# Elem e<y><x> {int col#, int value, Elem *nextelem}
sparse2dense:
				# $a1 = address of dense matrix
				# $a2 = matrix width
	addi  	$sp, $sp, -28
    	sw    	$ra, 0($sp)
    	sw    	$s0, 4($sp)	#row pointer
    	sw    	$s1, 8($sp)	#column counter
    	sw    	$s2, 12($sp)	#current element pointer
    	sw	$a0, 16($sp)
    	sw	$a1, 20($sp)
    	sw	$s3, 24($sp)
    	
    	addu	$s1, $0, $0	#initialize column counter to 0
    	addu	$s0, $a0, $0	#copy sparse matrix address into $s0
    	lw	$s2, 4($s0) 	#load element address into $s2
    	addu	$s3, $0, $0	#row counter
    	
    	
loop:
	beq	$s0, $0, ending	#check if row is NULL
	lw	$t1, 0($s0)	#load row number
	bne	$t1, $s3, emptyrow
	beq	$s1, $a2, nextrow
	beq	$s2, $0, fillrow	#check if elem address is 0
	lw	$t0, 0($s2)	#load column number of element
	beq	$t0, $s1, set
	sw	$0, 0($a1) 	#set value to 0
	addiu	$s1, $s1, 1	#increment column counter
	addiu	$a1, $a1, 4	#move dense matrix pointer over 1 int
	j	loop
	
set:
	lw	$t0, 4($s2)	#load elem value into $t0
	sw	$t0, 0($a1)	#store value in dense matrix
	addiu	$s1, $s1, 1	#increment column counter
	addiu	$a1, $a1, 4	#move dense matrix pointer over 1 int 
	lw	$s2, 8($s2)	#store next element in $s2
	j	loop
	
fillrow:
	beq	$s1, $a2, nextrow
	sw	$0, 0($a1)
	addiu	$s1, $s1, 1
	addiu	$a1, $a1, 4
	j	fillrow
	
emptyrow:	
	beq	$s1, $a2, addrow
	sw	$0, 0($a1)
	addiu	$s1, $s1, 1
	addiu	$a1, $a1, 4
	j	emptyrow
	
addrow:
	addi	$s3, $s3, 1
	add	$s1, $0, $0
	j	loop

nextrow:
	lw	$s0, 8($s0)
	beq	$s0, $0, ending
	lw	$s2, 4($s0)
	addu	$s1, $0, $0
	addi	$s3, $s3, 1
	j	loop
	
	
	
	
ending:	

	lw	$s3, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$s2, 12($sp)
	lw 	$s1, 8($sp)
	lw 	$s0, 4($sp)
	lw	$ra, 0($sp)
	addu 	$sp, $sp, 28
	jr 	$ra
