.data
# Sparse matrix representation
# Row r<y> {int row#, Elem *node, Row *nextrow}
# Elem e<y><x> {int col#, int value, Elem *nextelem}
r0:		.word 0, 0, r1
e00:		.word 2, 100, 0


r1:		.word 1, 0, r2
e10:		.word 1, 3, 0

r2:		.word 2, e20, r3
e20:		.word 0, 244, e21
e21:		.word 2, 567, 0

r3:		.word 3, 0, 0
e30:		.word 1, 30, e31
e31:		.word 2, 1, 0


