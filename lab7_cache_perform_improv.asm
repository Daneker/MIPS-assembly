.data
array: .space 1024
.text
# number of blocks = 1
# block size = 32 => the bigger block size reduces cache misses,
# e.g. longer block size => less nummber of blocks(since cache size fixed) => less cache misses => more hit rate

# stepsize = 4 => accessing the whole word, e.g. changing 0x00000000=>0x01010101, memory access count = 512
# 256 for reading, 256 for writing  (1024/4)
# if stepsize was 2 => it would access only a halfword(2 bytes) each loop, 
# e.g. 0x00000000=>0x00000101, then 0x00000101=>0x01010101
# this would cause memory access count to be 2 times bigger

# if stepsize was 1 => it would access only 1 byte(2 bytes) each loop, e.g. 0x00000000=>0x00000001, 
# then 0x00000001=>0x00000101, then 0x00000101=>0x00010101, then 0x00010101=>0x01010101,
# this would cause memory access count to be 4 times bigger
main: 
	la $a0, array
	li $a2, 1024  #size of the array
	li $a1, 4
	
	jal myMemoryUpdate
	
	li $v0, 10               		# exit program
	syscall
	
myMemoryUpdate:
	add $s0, $zero, $zero
	beq $a1, 1, loop1
	beq $a1, 2, loop2
	beq $a1, 4, loop4
 	loop1: 
 		beq $s0, $a2, exit_loop
 		add $t1, $s0, $a0
 		lb $t2, 0($t1)
 		add $t2, $t2, $a1
 		sb $t2, 0($t1)
 		addi $s0, $s0, 1
 		j loop1
 	loop2: 
 		beq $s0, $a2, exit_loop
 		add $t1, $s0, $a0
 		lh $t2, 0($t1)
 		addi $t2, $t2, 257
 		sh $t2, 0($t1)
 		addi $s0, $s0, 2
 		j loop2
 	loop4: 
 		beq $s0, $a2, exit_loop
 		add $t1, $s0, $a0
 		lw $t2, 0($t1)
 		add $t2, $t2, 16843009
 		sw  $t2, 0($t1)
 		addi $s0, $s0, 4
 		j loop4
 	exit_loop:
 		jr $ra
 		
 		
