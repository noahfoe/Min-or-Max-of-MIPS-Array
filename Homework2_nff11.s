# Homework 2 for Assembly Language
#
#	$a0 <-- msg OR err
#	$s0 <-- arr
#	$t0 <-- user input (1 or 2)
#	$t1 <-- min, originally set to arr[0]
#	$t2 <-- max, originally set to arr[0]
#	$t3 <-- counter for min loop
#	$t4 <-- counter for max loop
#

	.data
arr:    .word 40, 30, 50, 3, 6, 10, 56, 34, 75, 29
msg:    .asciiz "Enter 1 for minimum value in array, or 2 for maximum value: "
	.space 64
err:	.asciiz "\nError: Input must be either 1 (min) or 2 (max): " 
	.space 64

	.text
	.globl main
main:	
	# Ask user for input
	li $v0, 4	# 4 means cout
	la $a0, msg	# msg stored into $a0 
	li $a1, 64
	syscall

# do-while loop
loop:
	# Get user input
	li $v0, 5
	syscall
	move $t0, $v0	# $t0 <- user input

	# Load the array
	la $s0, arr	# $s0 <- arr
	li $s1, 10	# load num of elements in array
	lw $t1, 0($s0) 	# minumum value ($t1) = arr[0]
	lw $t2, 0($s0)	# maximum value ($t2) = arr[0]

	# Set counters for loops
	addi $t3, $0, 0	# min loop counter ($t3 <- 0)
	addi $t4, $0, 0	# max loop counter ($t4 <- 0)

	# If user input = 1, branch to min
	beq $t0, 1, MIN

	# If user input = 2, branch to max
	beq $t0, 2, MAX

	# Else, print err and jump back to main
	li $v0, 4	# 4 means cout
	la $a0, err	# err stored into $a2
	li $a1, 64
	syscall

	b loop

# find min of array
MIN:	
	addi $t3, $t3, 1	# increment counter ($t3)
	beq $t3, $s1, done_min	# branch to done if all elements examined
	add $t5, $t3, $t3	# compute 2i in $t5 = partial offset
	add $t5, $t5, $t5	# compute 4i in since integer is 4 Bytes $t5=complete offset of ith element
	add $t5, $t5, $s0	# form address of arr[i] in $t5
	lw $t6, 0($t5)		# load value arr[i] into $t6
	slt $t7, $t6, $t1	# min > arr[i]?
	beq $t7, $zero, MIN	# if not, then repeat without changing
	addi $t1, $t6, 0	# if so, arr[i] is the new max
	j MIN			# repeat until min is found

# find max of array	
MAX:
	addi $t4, $t4, 1	# increment counter ($t4)
	beq $t4, $s1, done_max	# branch to done if all elements examined
	add $t5, $t4, $t4	# compute 2i in $t5 = partial offset
	add $t5, $t5, $t5	# compute 4i in since integer is 4 Bytes $t5=complete offset of ith element
	add $t5, $t5, $s0	# form address of arr[i] in $t5
	lw $t6, 0($t5)		# load value arr[i] into $t6
	slt $t7, $t1, $t6	# max < arr[i]?
	beq $t7, $zero, MAX	# if not, then repeat without changing
	addi $t2, $t6, 0	# if so, arr[i] is the new max
	j MAX			# repeat until max is found

	
# called after max or min function
done_max:
	move $a0, $t2
	li $v0, 1	# 1 means display integer
	syscall

	# Terminate Program
    	li $v0, 10	# 10 means terminate program
    	syscall

done_min:
	move $a0, $t1
	li $v0, 1	# 1 means display integer
	syscall

	# Terminate Program
    	li $v0, 10	# 10 means terminate program
    	syscall
