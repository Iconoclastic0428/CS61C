.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks

    # Prologue
	addi sp sp -40
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    
    add s0 x0 a0 # m0, 0(s0) = *s0
    add s1 x0 a3 # m1, ...
    add s2 x0 a6 # d, ...
	add s3 x0 a2 # stride
    mul s4 a1 a2 
    mv s5 s4 # length
    addi s5 s5 -1 # length - 1
    sub s4 s4 s3 # length - stride
    li s6 0 # int a1
    li s7 0 # int a2
    li t0 0 # cur
    
outer_loop_start:
    mv t2 s7 # j
    li t6 0
	
inner_loop_start:
	lw t3 0(s0)
    lw t4 0(s1)
    mul t5 t3 t4
    add t6 t6 t5 # res[cur] += m0[i] * m1[j]
    addi t1 t1 1
    add t2 t2 s3
    beq t1 s3 inner_loop_end
	addi s0 s0 4
    li s8 4
    mul s8 s8 s3 # stride * 4
    add s1 s1 s8
    li s8 0
    j inner_loop_start

inner_loop_end:
	sw t6 0(s2)
    addi s2 s2 4
    addi s8 s3 -1
    blt s7 s8 loop_col
    blt s5 t6 loop_row
    j outer_loop_end
    loop_col: 
    	addi t0 t0 1
        addi s7 s7 1
        li s8 4
        mul s8 s8 s7
        add s1 a3 s8
        li s8 4
        mul s8 s8 s6
        add s0 a0 s8
        li t6 0
        li t1 0
        j inner_loop_start # mult(a1, a2 + 1)
    loop_row:
    	addi t0 t0 1
        li s7 0
        mv s1 a3
        add s6 s6 s3
        li s8 4
        mul s8 s8 s6
        mv s0 a0
        add s0 s0 s8
        li t1 0
        j outer_loop_start # mult(a1 + stride, 0)

outer_loop_end:
	mv a0 a6
	lw s8 36(sp)
    lw s7 32(sp)
    lw s6 28(sp)
    lw s5 24(sp)
    lw s4 20(sp)
    lw s3 16(sp)
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 40

    # Epilogue
    
    
    ret
