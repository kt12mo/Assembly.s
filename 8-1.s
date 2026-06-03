    .text
    .globl main
main:
    addi $sp,$sp,-4
    sw $ra,0($sp)

    li $v0,5
    syscall 
    move $s0,$v0

    li $t0,0

L1:
    bge $t0,$s0,L2
    sub $a0,$s0,$t0 #
    addi $a0,$a0,1
    move $a1,$s0

    addi $sp,$sp,-4
    sw $t0,0($sp)
    jal Linedisp

    lw $t0,0($sp)
    addi $sp,$sp,4
    
    addi $t0,$t0,1
    j L1

L2:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    li $v0,10
    syscall

Linedisp:
    move $t1,$a0
    li $t2,0

L3:
    beq $t2, $t1, L4   
    move $t3, $t1
    addi $t3, $t3, 48   #0を足す

    li $v0, 11
    move $a0, $t3
    syscall

    addi $t2, $t2, 1
    j L3
    
L4:
    sub $t4, $a1, $t1
    move $t2,0    #カウンタリセット

L5:
    beq $t2, $t4, L6  
    li $v0, 11
    li $a0, 42
    syscall

    addi $t2, $t2, 1
    j L5

L6:
    li $v0, 11
    li $a0, 10
    syscall

    jr $ra



