.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp sp -16
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)

	mv s0 a0	
	mv s1 a1
    mv s2 a2

	add a1 s0 x0
    addi a2 x0 0
    jal ra fopen
    li t0 -1
    beq a1 t0 eof_exit_error
    
    # read rows
	mv s0 a0
    mv a1 s0
    mv a2 s1
    li a3 4
    jal ra fread
    li t0 4
    bne a0 t0 eof_exit_error
    lw t0 0(a2) # num of rows

	# read cols
    mv a1 s0
    mv a2 s2
    li a3 4
    jal ra fread
    li t0 4
    bne a0 t0 eof_exit_error
    lw t1 0(a2)
    
    # malloc
    mul a0 t0 t1
    slli a0 a0 2
    jal ra malloc
    beq a0 x0 eof_exit_error
    
    # read matrix
    mv a1 s0
    mv a2 a0
    mul a3 t0 t1
    slli a3 a3 2
    jal ra fread
    mul t2 t0 t1
    addi t2 t2 8
    bne a0 t2 eof_exit_error
    
    mv a1 s0
    jal ra fclose
    bne a0 x0 eof_exit_error
    
    mv a0 a2
    mv s0 t1
    mv s1 t2
    

    # Epilogue
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 4
    
    ret

eof_exit_error:
	li a1 1
    jal exit2
