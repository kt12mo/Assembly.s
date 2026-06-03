    .text
    .globl main
main:
    li  $s1, 0x41        # 'A'
    li  $s2, 0x5A        # 'Z'
    li  $s3, 0x61        # 'a'
    li  $s4, 0x7A        # 'z'
    li  $s5, 0x20        # ' '

    la  $t2, A           # A_index（入
    la  $t3, B           # B_index（出
    li  $t6, 0        

    la  $a0, A
    li  $a1, 101
    li  $v0, 8
    syscall

L1:
    lb  $t0, 0($t2)         
    beq $t0, $zero, L6       # NULL →
    beq $t0, $s5, L5         # 空白なら L5
    bne $t6, $zero, L3
    j L2

L2:
    blt  $t0, $s1, L2_store   # 'A' 未満 → そのまま格納
    bgt  $t0, $s2, L2_store   # 'Z' より大 → そのまま格納
    addi $t0, $t0, 32         
L2_store:
    sb   $t0, 0($t3)
    addi $t3, $t3, 1
    addi $t2, $t2, 1
    li   $t6, 0              
    j L1


L3:
    blt  $t0, $s3, L4        # 'a'未満 → L4 に格納
    bgt  $t0, $s4, L4        # 'z'超え → L4 に格納
    addi $t0, $t0, -32       # 小文字 → 大文字
    j L4

L4:
    sb   $t0, 0($t3)
    addi $t3, $t3, 1
    addi $t2, $t2, 1
    li   $t6, 0             
    j L1

L5:
    bne $t6, $zero, L5_skip
    li   $t6, 1              
    sb   $s5, 0($t3)         
    addi $t3, $t3, 1

L5_skip:
    addi $t2, $t2, 1    
    j L1

L6:
    sb   $zero, 0($t3)        
    la   $a0, B
    li   $v0, 4
    syscall

    li $v0, 10              
    syscall

    .data
A:  .space 101
B:  .space 101
