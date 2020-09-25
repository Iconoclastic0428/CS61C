.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
	addi sp sp -12
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
	add s0 x0 a0
    add s1 x0 a1
    li t0 0
    li t1 0
    lw t3 0(a0)
    addi s0 s0 4
loop_start:
	lw t2 0(s0)
    addi t1 t1 1
	bge t2 t3 loop_continue
	mv t3 t2
	mv t0 t1

loop_continue:
	addi s0 s0 4
	beq t1 s1 loop_end
    j loop_start

loop_end:
	mv a0 t0
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 12

    # Epilogue


    ret
