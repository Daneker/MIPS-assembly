.data
n: .asciiz "\n"
msg: .asciiz "Enter your num: "
one: .double 1.0

.text
main: 	
	#Display msg to te user
	li $v0, 4
	la $a0, msg
	syscall
	
	#Get the integer from the user
	li $v0, 7
	syscall
	
	mov.d $f12, $f0
	
	jal fact
	
	#Display the result 
	li $v0, 3
        mov.d $f12, $f0
	#add.d $f12, $f0, $f10
	syscall

	li $v0, 10               	# exit program
	syscall


fact:
	addi $sp, $sp, -12
	mfc1.d $t0, $f12
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	
	l.d $f6, one
	
	c.lt.d $f12, $f6
	bc1f L1
	
	mov.d $f0, $f12 
	addi $sp, $sp, 12
	jr $ra
	
L1:
	sub.d $f12, $f12, $f6
	jal fact
	
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	mtc1.d $t0, $f12
	addi $sp, $sp, 12
	
	mul.d $f0, $f12, $f0
	jr $ra