.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
	addi sp sp -20
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)

	mv s0 a0 # file path
    mv s1 a1 # matrix
    mv s2 a2 # rows
    mv s3 a3 # cols
    
    mv a1 s0
    li a2 1
    jal ra fopen
    li t0 -1
    beq a0 t0 eof_or_error
    
    mv s0 a0
    li a0 4
    jal ra malloc
    sw s2 0(a0)
    mv a1 s0
    li a4 4
    mv a2 a0
    li a3 1
    jal ra fwrite
    bne a0 a3 eof_or_error
    
    li a0 4
    jal ra malloc
    sw s3 0(a0)
    mv a1 s0
    li a4 4
    mv a2 a0
    li a3 1
    jal ra fwrite
    bne a0 a3 eof_or_error
    
    mv a1 s0
    mv a2 s1
    mul a3 s2 s3
    li a4 4
    jal ra fwrite
    bne a0 a3 eof_or_error
    
    jal ra fclose
    bne a0 x0 eof_or_error

    # Epilogue
	lw s3 16(sp)
    lw s2 12(sp)
    lw s1 8(sp)
    lw s0 4(sp)
    lw ra 0(sp)
    addi sp sp 20

    ret
    
eof_or_error:
	li a1 1
    jal exit2
