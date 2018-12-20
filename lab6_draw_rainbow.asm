.data
DISPLAY: .space 16384#65536 #0x00100 # 8*8*4, we need to reserve this space at the beginning of .data segment
DISPLAYWIDTH: .word 64
DISPLAYHEIGHT: .word 64
 
red: .word 0xff0000
r: .double 15.0
zero: .double 0.0
i: .double 0.05
full: .double 64
half: .double 32
one: .double 1.0

RED: .word 0xff0000 
.text

j main

set_pixel_color:
# Assume a display of width DISPLAYWIDTH and height DISPLAYHEIGHT
# Pixels are numbered from 0,0 at the top left
# a0: x-coordinate
# a1: y-coordinate
# a2: color
# address of pixel = DISPLAY + (y*DISPLAYWIDTH + x)*4
#   y rows down and x pixels across
# write color (a2) at arrayposition

lw $t0, DISPLAYWIDTH
mul $t0, $t0, $a1  # y*DISPLAYWIDTH
add $t0,$t0, $a0  # +x
sll $t0, $t0, 2  # *4
la $t1, DISPLAY  # get address of display: DISPLAY
add $t1, $t1, $t0 # add the calculated address of the pixel
sw $a2, ($t1)   # write color to that pixel
jr $ra    # return
 
main:
	jal rainbow

rainbow:
	lw  $a2, RED
	li $s0, 7	
	ldc1 $f0, zero 		# x-initial
	ldc1 $f4, full 		# 64
	ldc1 $f6, half 		# 32
	ldc1 $f8, i 		# 0.08
	ldc1 $f20, r 		# radius
	ldc1 $f30, one
	
loop_r:
	mul.d $f10, $f20, $f20 	# r^2
	ldc1 $f2, zero 		# y = 0
 
	loop_y:	
		ldc1 $f0, zero 		# x = 0
 
	loop_x:   	
   		mov.d $f12, $f0  	# x => 
   		mov.d $f14, $f2 	# y =>
   	
   		cvt.w.d $f12, $f12
   		mfc1 $a0, $f12 		# a0 => x-coord
   	
   		cvt.w.d $f14, $f14
   		mfc1 $a1, $f14 		# a1 => y-coord
   	
   		sub.d $f22, $f0, $f6 	# x^2
   		mul.d $f22, $f22, $f22
   		sub.d $f24, $f2, $f6 	# y^2
   		mul.d $f24, $f24, $f24
   		add.d $f22, $f24, $f22 	# x^2 + y^2
   	
   		round.w.d $f26, $f22
   		round.w.d $f28, $f10
   		c.eq.d $f26, $f28
   		bc1t colorCircle   	# x*x + y*y = r*r
   	
   		j skipColor2     	# skip red
   	
   		colorCircle:  
   			j skipColor1
   			
   		skipColor1:	
   			jal set_pixel_color # color the current pixel
   	
   		skipColor2:
   			add.d $f0, $f0, $f8 # increment x	
   			c.le.d $f0, $f4 # x < 64
   			bc1t loop_x
       
  		add.d $f2, $f2, $f8  	# increment y
  		c.le.d $f2, $f6 	# y < 32
   		bc1t loop_y
   	
   	sub.d $f20, $f20, $f30
	subi $s0, $s0, 1
	addi $a2, $a2, 20000
	bne $s0, $zero, loop_r
	li $v0, 10                 # exit program
	syscall
	jr $ra


  
