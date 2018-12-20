.data
input: .space 20
n: .asciiz "\n"

msg1: .asciiz "berfore: "
msg2: .asciiz "after: "

.text
main: 
	li	$s7, '-'			# load char "-"
	
	for_loop :

		la	$a0, input		# store input inputing in $a0	
		li 	$a1, 20		
		li	$v0, 8			# input some inputing
		syscall 
		
		li 	$s6, 0			
		lb	$s6, 0($a0)		# set a[0] to $t6 
		beq	$s6, $s7, exit_loop	# check if inputing[0] is "-"
		
		li 	$v0, 4                  # print before:
		la 	$a0, msg1
		syscall
		
		li	$v0, 4			# output original inputing
		la	$a0, input
		syscall
		
		li    	$t0, 0         
 	 	addi  	$sp, $sp, -4    
  		sw    	$t0, ($sp)    
  		li    	$t1, 0         
  		
		
	push_to_stack:
  		lb    	$t0, input($t1) 
  		beq   	$t0, $zero, exit_push   

  		addi  	$sp, $sp, -4   
  		sw    	$t0, ($sp)    

  		add   	$t1, $t1 1     
  		j     	push_to_stack        

	exit_push:               
  		li    	$t1, 0        

		jal 	reverse
		
		li 	$v0, 4              
		la 	$a0, n
		syscall
		
		j 	for_loop

	
reverse: 		
  		lw    	$t0, ($sp)   
  		addi  	$sp, $sp, 4
  		beq   	$t0, $zero,  exit      

 		sb    	$t0, input($t1) 
  		addi  	$t1, $t1, 1    
  		j      	reverse
	exit:             
  		li    	$v0, 4    
  		la    	$a1, input       
  		syscall
  		
  		jr	$ra


exit_loop: 
	li 	$v0, 10               
	syscall
