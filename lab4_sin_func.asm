.data
n: .asciiz "\n"
msg: .asciiz "Enter your degree: "
pi: .double 3.142
half: .double 180
one: .double 1

.text

main:
	#Display msg to te user
	li $v0, 4
	la $a0, msg
	syscall
	
	#Get the double from the user
	li $v0, 7
	syscall
	
	jal my_sin
	
	#Display the user's input 
	li $v0, 3
	add.d $f12, $f2, $f10
	syscall

	li $v0, 10               	# exit program
	syscall
	
my_sin: 
	ldc1 $f4, pi
	ldc1 $f6, half
	
	mul.d $f8, $f4, $f0 		# pi * x
	div.d $f0, $f8, $f6		# pi * x / 180
	
	li $t0, 10			# n = 10
	li $t1, 0			# k = 0
	
	loop1:
		add $sp, $sp, -4
		sw $ra, 0($sp)
	
		beq $t1, $t0, exit_loop1		# while (k != n)
		sll $t2, $t1, 1 		# 2k
		addi $t2, $t2, 1		# power = 2k + 1
		
		jal pow_series	
		
		li  $t3, 2
		div $t1, $t3 
		mfhi $t4
		
		bne $t4, $zero, else
		add.d $f20, $f20, $f2
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $t1, $t1, 1
		j loop1
		
		else: 
			sub.d $f20, $f20, $f2
		
			lw $ra, 0($sp)
			addi $sp, $sp, 4
		
			addi $t1, $t1, 1
			j loop1
	
	exit_loop1:
		mov.d $f2, $f20
		jr $ra	

pow_series: 				# pow_series(x, power)
	ldc1 $f18, one			# s = 1
	add $a0, $t2, $zero
	loop2: 
		beq $a0, $zero exit_loop2
		mtc1 $a0, $f12
		cvt.d.w $f12, $f12		# int f => double f
	
		div.d $f16, $f0, $f12		# x / f
		mul.d $f18, $f18, $f16		# s = s * (x / f)
	
		addi $a0, $a0, -1		# f-- (int)
	
		j loop2
	
	exit_loop2:
		mov.d $f2, $f18
		jr $ra
