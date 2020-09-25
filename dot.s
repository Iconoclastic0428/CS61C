.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
	addi sp sp -12
    sw ra 0(sp)
    sw s1 4(sp)
    sw s0 8(sp)
    # Prologue
	add s0 x0 a0
    add s1 x0 a1
    add t0 x0 a2
    li t1 0
    li t2 0
    li t3 4
    li t4 4
    mul t3 t3 a3
    mul t4 t4 a4

loop_start:
	lw s3 0(s0)
    lw s4 0(s1)
	mul s3 s3 s4
	add t2 t2 s3
    addi t1 t1 1
	add s0 s0 t3
    add s1 s1 t4
	bne t1 t0 loop_start

loop_end:
	mv a0 t2

    # Epilogue
	lw s0 8(sp)
    lw s1 4(sp)
    lw ra 0(sp)
    addi sp sp 12
