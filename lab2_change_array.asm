.data
arr: .word 21 20 51 83 20 20
length: .word 6
x: .word 20
y: .word 5
nl: .asciiz "  "
msg1: .asciiz "berfore: "
msg2: .asciiz "\nafter: "

.text
main: 
	la $s7, arr

	lw $a1, length
	lw $a2, x
	lw $a3, y
	addi $s1, $zero, 0

	li $v0, 4 # print_string syscall code = 4
	la $a0, msg1
	syscall
	
	jal printArr 
	jal replace
	
	li $v0, 4 # print_string syscall code = 4
	la $a0, msg2
	syscall
	
	jal printArr 
	
	li $v0, 10 # exit
	syscall
	
printArr:
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $s1, $zero, 0 
		
	print_loop: 
		sll $t1, $s1, 2     # temp reg $t6 = i*4
		add $t1, $t1, $s7   # $t6 address of arr[i]
		lw $t0, 0($t1)      # temp reg $t7 = arr[i]
	
		beq $s1, $a1, Exit_printArr  	
		li $v0, 1           # printing code
		move $a0, $t0
		syscall
	
		li $v0,4 # print_string syscall code = 4
		la $a0, nl
		syscall
	
		addi $s1, $s1, 1
		j print_loop
		
Exit_printArr: 
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	jr $ra	
	
replace:
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	addi $s0, $zero, 0 
	
	replace_loop:
		sll $t2, $s0, 2     # temp reg $t6 = i*4
		add $t2, $t2, $s7   # $t6 address of arr[i]
		lw $t3, 0($t2)      # temp reg $t7 = arr[i]
	
		beq $s0, $a1, Exit_replace  # if i = length, go to Exit
		addi $s0, $s0, 1    # i++
		bne $t3, $a2, Else
			
		sw $a3, 0($t2)      # arr[i] = y
		j replace_loop

	Else: 
		j replace_loop


Exit_replace:   
	addi $sp, $sp, 8
	lw $s0, 4($sp)
	jr $ra



