.data
array: .space 1024
repCount: .word 4 

.text

# block number - 1
# block size - 32
# memory access count = 2048
# hit count - 2040
# miss count - 8

main:
	jal myMemoryUpdate

	li $v0 10
	syscall
	
myMemoryUpdate:
	la $a0, array	#arrayAddress
	li $a1, 1024	#arraySize
	li $a2, 4	#repCount
	li $a3, 8	#loopsize
	
	add $s2, $zero, $zero
	add $s3, $zero, $zero
	loop1:
		add $s1, $zero, $zero
		loop2:	
			add $s0, $zero, $s3
			loop3:		
 				add $t1, $s0, $a0
 				lw $t2, 0($t1)
 				add $t2, $t2, 16843009
 				sw  $t2, 0($t1)
 				addi $s0, $s0, 4
 				blt $s0, $a3, loop3
			addi $s1, $s1, 1
			bne $s1, $a2, loop2
	addi $s2, $s2, 1
	addi $s3, $s3, 8
	addi $a3, $a3, 8
	div $t0, $a1, 8
	bne $s2, $t0, loop1
	
	exit_loop:  
		jr $ra