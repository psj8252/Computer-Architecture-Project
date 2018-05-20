.data

arr: .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
dot: .word 0, 0
         .word 2, 6
         .word 8, 4
         .word 7, 2
         .word 1, 6
         .word 4, 9
         .word 3, 2    
course: .word 0, 0, 0, 0, 0, 0
double_max: .double 999999.0
    zero:   .double 0.0
    x:      .double 1.0
    two:    .double 2.0


# d1 ~ d6 = s1 ~ s6
# f0 = dist_min, f2=dist
# f4, f6, f8, f10, f12 = dist1 ~ dist5

.text
main:
l.d $f0, double_max
# GetPathLenthData funciton excution
la $a0, arr
la $a1, dot
jal getPathLengthData

# --- This codes for test path lenth
la $t0, 0
li $v0, 3
li $a0, 10
test_loop:
l.d $f12, arr($t0)
syscall
li $v0, 11
syscall
addi $t0, $t0, 8
ble $t0, 384, test_loop




# for loop1
li $s1, 0
loop1:
addi $s1, $s1, 1
bge $s1, 7, exit_loop
sll $t0, $s1, 3
l.d $f2, arr($t0)                 # dist = arr[0][d1]
mov.d $f4, $f2                # dist1 = dist
c.le.d $f0, $f2 
bc1t loop1                    # if (dist > dist_min)    continue;	
# for loop2
li $s2, 0
loop2:
addi $s2, $s2, 1
beq $s2, $s1, loop2
bge $s2, 7, loop1
sll $t0, $s1, 3
sub $t0, $t0, $s1
add $t0, $t0, $s2
sll $t0, $t0, 3
l.d $f2, arr($t0)                 # dist = arr[d1][d2]
add.d $f2, $f2, $f4           # dist = dist + dist1
mov.d $f6, $f2                # dist2 = dist
c.le.d $f0, $f2 
bc1t loop2                    # if (dist > dist_min)    continue;
# for loop3
li $s3, 0
loop3:
addi $s3, $s3, 1
beq $s3, $s1, loop3
beq $s3, $s2, loop3
bge $s3, 7, loop2
sll $t0, $s2, 3
sub $t0, $t0, $s2
add $t0, $t0, $s3
sll $t0, $t0, 3
l.d $f2, arr($t0)                 # dist = arr[d2][d3]
add.d $f2, $f2, $f6           # dist = dist + dist2
mov.d $f8, $f2                # dist3 = dist
c.le.d $f0, $f2 
bc1t loop3                    # if (dist > dist_min)    continue;
# for loop4
li $s4, 0
loop4:
addi $s4, $s4, 1
beq $s4, $s1, loop4
beq $s4, $s2, loop4
beq $s4, $s3, loop4
bge $s4, 7, loop3
sll $t0, $s3, 3
sub $t0, $t0, $s3
add $t0, $t0, $s4
sll $t0, $t0, 3
l.d $f2, arr($t0)                 # dist = arr[d3][d4]
add.d $f2, $f2, $f8           # dist = dist + dist3
mov.d $f10, $f2               # dist4 = dist
c.le.d $f0, $f2 
bc1t loop4                    # if (dist > dist_min)    continue;
# for loop5
li $s5, 0
loop5:
addi $s5, $s5, 1
beq $s5, $s1, loop5
beq $s5, $s2, loop5
beq $s5, $s3, loop5
beq $s5, $s4, loop5
bge $s5, 7, loop4
sll $t0, $s4, 3
sub $t0, $t0, $s4
add $t0, $t0, $s5
sll $t0, $t0, 3
l.d $f2, arr($t0)                 # dist = arr[d4][d5]
add.d $f2, $f2, $f10          # dist = dist + dist4
mov.d $f12, $f2               # dist5 = dist
c.le.d $f0, $f2 
bc1t loop5                    # if (dist > dist_min)    continue;
# for loop6
li $s6, 0
loop6:
addi $s6, $s6, 1
beq $s6, $s1, loop6
beq $s6, $s2, loop6
beq $s6, $s3, loop6
beq $s6, $s4, loop6
beq $s6, $s5, loop6
bge $s6, 7, loop5
sll $t0, $s5, 3
sub $t0, $t0, $s5
add $t0, $t0, $s6
sll $t0, $t0, 3
l.d $f2, arr($t0)                 # dist = arr[d5][d6]
add.d $f2, $f2, $f12          # dist = dist + dist4
sll $t0, $s6, 3
l.d $f14, arr($t0)       
add.d $f2, $f2, $f14          # dist = dist + arr[d6][0]
c.le.d $f0, $f2
bc1t loop6                    # if (dist >= dist_min)    continue;
sw $s1, course
sw $s2, course+4
sw $s3, course+8
sw $s4, course+12
sw $s5, course+16
sw $s6, course+20
mov.d $f0, $f2
j loop6
exit_loop:
la $v0, 1
la $a0, 1
syscall
lw $a0, course
addi $a0, 1
syscall
lw $a0, course+4
addi $a0, 1
syscall
lw $a0, course+8
addi $a0, 1
syscall
lw $a0, course+12
addi $a0, 1
syscall
lw $a0, course+16
addi $a0, 1
syscall
lw $a0, course+20
addi $a0, 1
syscall
la $v0, 1
la $a0, 1
syscall
la $v0, 11
la $a0, 10
syscall
la $v0, 3
mov.d $f12, $f0
syscall
la $v0, 10
syscall


getPathLengthData:
	addi	$sp, $sp, -12
	sw	$ra, 0($sp)			
	sw	$a0, 4($sp)			
	sw	$a1, 8($sp)		

	li	$s0, 0				
	li	$t0, 7				


Loop1:
	li	$s1, 0				
	
	
Loop2:


	la	$s3, 0($a1)			

	sll	$s2, $s0, 3			# $s2 = i * 8
	add	$s3, $s3, $s2			# $s3 = $s3 + (i * 8)

	lw	$t1, 0($s3)			# $t1 = dot[i][0]
	lw	$t2, 4($s3)			# $t2 = dot[i][1]



	la	$s3, 0($a1)			

	sll	$s2, $s1, 3			# $s2 = j * 8
	add	$s3, $s3, $s2			# $s3 = $s3 + (j * 8)

	lw	$t3, 0($s3)			# $t3 = dot[j][0]
	lw	$t4, 4($s3)			# $t4 = dot[j][1]


	sub	$t3, $t3, $t1			# x_length = dot[j][0] - dot[i][0] (x2 - x1)
	sub	$t4, $t4, $t2			# y_length = dot[j][1] - dot[i][1] (y2 - y1)

	mul	$t1, $t3, $t3			# $t1 = x_length * x_length
	mul	$t2, $t4, $t4			# $t2 = y_length * y_length

	add	$t1, $t1, $t2			# $t1 = $t1 + $t2   ($t1 = temp)


	addi	$sp, $sp, -4
	sw	$a0, 0($sp)			

	add	$a0, $zero, $t1			

	addi	$sp, $sp, -4
	sw	$s1, 0($sp)			# store $s1

	jal	sqrt				# call sqrt(temp)

	lw	$s1, 0($sp)
	addi	$sp, $sp, 4			# restore $s1

	lw	$a0, 0($sp)			
	addi	$sp, $sp, 4		

	
	li	$t1, 56				# $t1 = 8 * 7
	mul	$t2, $s0, $t1			# $t2 = i * 8 * 7
	
	sll	$t1, $s1, 3			# $t1 = j * 8

	la	$s3, 0($a0)		

	add	$t3, $t2, $t1			# $t3 = (i * 8 * 7) + (j * 8)
	add	$s3, $s3, $t3			# $s3 = arr + (i * 8 * 7) + (j * 8)
	
	s.d	$f0, 0($s3)		



	addi	$s1, $s1, 1			# j++
	beq	$s1, $t0, Loop_End		
	j	Loop2

Loop_End:

	addi	$s0, $s0, 1			# i++
	bne	$s0, $t0, Loop1			

	lw	$ra, 0($sp)			
	lw	$a0, 4($sp)		
	lw	$a1, 8($sp)			
	addi	$sp, $sp, 12

	jr	$ra				


sqrt:
mtc1 $a0, $f12
cvt.d.w $f12, $f12
l.d $f2, x
l.d $f6, two
add $s1, $zero, $zero   #s1=i=0

loop_sqrt:
div.d $f4, $f12, $f2    #f4=input/x          
add.d $f4, $f4, $f2     #f4= x+input/x
div.d $f2, $f4, $f6    #x=f4/2
addi $s1, $s1, 0x1      #i++
bne $s1, 10, loop_sqrt  #if i!=10, loop

#add.d $f12, $f8, 0.0
mov.d $f12, $f2
jr $ra                  #return