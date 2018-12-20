#Lab Section:3
#Daneker Nurgaliyeva, Sabina Zaripova
.data  
A: .space 24
B: .space 36
#C: .space 56
fin: .asciiz "file.txt"      # filename for input
buffer: .space 256
space: .asciiz " "
msg: .asciiz "C: "

.text

# Open file for reading
open_file:
	li   $v0, 13       # system call for open file
	la   $a0, fin      # input file name
	li   $a1, 0        # flag for reading
	li   $a2, 0        # mode is ignored
	syscall            # open a file 
	move $s0, $v0      # save the file descriptor 

	# reading from file just opened
	li   $v0, 14       # system call for reading from file
	move $a0, $s0      # file descriptor 
	la   $a1, buffer   # address of buffer from which to read
	li   $a2,  1024    # hardcoded buffer length
	syscall            # read from file
# Store string to 2 arrays	
store_to_arrays:
	li $t0, 0 	   # i = 0
	move $a0, $a1
	la $s0, A
	la $s1, B 
	
	loop: 
		lb $a1, ($a0) 		# first character
		addi $a0, $a0, 1 	# i++	
		lb $a2, ($a0) 		# second character
		
		addi $t1, $a1, -48
		addi $t2, $a2, -48
		
		beq $a1, 32, dec1
		beq $a2, 32, dec1
		
		beq $a1, 59, dec1
		beq $a2, 59, dec1
		
		beq $a1, 10, go_to_row2
		beq $a2, 10, go_to_row2
			
		mul $t1, $t1, 10
		add $t1, $t1, $t2
		
		j store_to_array

		dec1:
			beq $a2, 32, dec1_1
			beq $a2, 59, dec1_1
			move $t1, $t2
			dec1_1:
				addi $a0, $a0, -1
				j store_to_array
	store_to_array:	
		sll $t2, $t0, 2
		add $t2, $s0, $t2
		sw $t1, ($t2) 
		addi $t0, $t0, 1
		addi $a0, $a0, 2
		j loop
		
	go_to_row2:
		beq $a2, 0, close_file
		beq $a1, 0, close_file
		beq $a2, 10, row2
		move $t1, $t2
		row2:
			move $s0, $s1
			add $t0, $zero, $zero
			j store_to_array			
# Close file	
close_file:	
	# Close the file 
	li $v0, 16         # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	
main: 
	la $a1, A
	la $a2, B	
	size_A:
       		li $t1, 4
       		sub $t0, $a2, $a1
       		div $t0, $t0, 4
       		addi $t4, $t0, 1
       		mul $t4, $t4, $t1
       		add $t4, $t4, $a1  
       		move $t1, $t0                     
	size_B:
        	li  $t3, 1
		loop_B:
        		lw  $t2, 0($t4)
        		beq $t2, $zero, endB
        		addi $t3, $t3, 1
        		addi $t4, $t4, 4
        		j   loop_B
		endB:
 		move $t2, $t3
 	addi $sp, $sp, -8
 	sw $t0, 0($sp)
 	sw $t3, 4($sp)
	jal merge
	jal print
	lw $t0, 0($sp)
 	lw $t3, 4($sp)
	addi $sp,$sp,8
	li $v0, 10
	syscall	
		
merge:
	# allocating C on heap
	add $a3, $t1, $t2
	li $v0, 9
	add $a0, $a3, $zero
	syscall
	# storing C to $s0
	move $s0, $v0
	move $s7, $v0
	
	merge1:
	beq $t0, $zero, sec
	beq $t3, $zero, first
	lw $t7, 0($a1)
	lw $t8, 0($a2)
	bgt $t7, $t8, case1
    	sw $t7, 0($s0) 
    	addi $s0, $s0, 4
    	addi $a1, $a1, 4
    	addi $t0, $t0, -1
    	j merge1
	case1: 
		sw $t8, 0($s0) 
       		addi $s0, $s0, 4
       		addi $a2, $a2, 4
       		addi $t3, $t3, -1
       		j merge1
	sec:  
		lw $t8, 0($a2)
     		sw $t8, 0($s0)
     		addi $s0, $s0, 4
     		addi $a2, $a2, 4
     		addi $t3, $t3, -1
     		beq  $t3, $zero, term
       		j merge1
	first: 
		lw $t7, 0($a1)
     		sw $t7, 0($s0)
     		addi $s0, $s0, 4
     		addi $a1, $a1, 4
     		addi $t0, $t0, -1
     		beq  $t0, $zero, term
       		j merge1
	term: 
		move $v0, $s0
 		jr $ra
	
print:
	li $v0, 4 # print_string syscall code = 4
	la $a0, msg
	syscall
		
	add $t0, $t1, $t2
	mul $t0, $t0, 4
	add $t0, $t0, $s7
	
	li $t1, 0
	add $t1, $s7, $t1
	print_loop:
		beq $t1, $t0, exit_print
		lw $t2, ($t1)
		li $v0, 1           # printing code
		move $a0, $t2
		syscall
		
		li $v0, 4 # print_string syscall code = 4
		la $a0, space
		syscall
		
		addi $t1, $t1, 4
		j print_loop	
	exit_print:
		jr $ra