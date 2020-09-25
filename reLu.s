.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
	addi sp sp -12
    sw ra 8(sp)
    sw s1 4(sp)
    sw s0 0(sp)
    
    add s0 x0 a0
    add s1 x0 a1

loop_start:
    lw t1 0(s0)
    bge t1 x0 loop_continue
    sw x0 0(s0)

loop_continue:
	addi s0 s0 4
    addi s1 s1 -1
	beq s1 x0 loop_end
	j loop_start
    
loop_end:
	lw s0 0(sp)
    lw s1 4(sp)
    lw ra 8(sp)
    addi sp sp 12

    # Epilogue

    
