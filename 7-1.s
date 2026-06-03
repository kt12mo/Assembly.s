    .text
    .globl main
main:
    li $s1, 0x41
    li $s2, 0x5A
    li $s3, 0x61
    li $s4, 0x7A
    li $s5, 0x20

    la $a0, A
    la $t2, A
    la $t3, B
    li $t6, 1
    li $a1, 101
    li $v0, 8
    syscall

L1: lb $t0, 0($t2)
    beq $t0,$zero,L6
    beq $t0,$s5, L5
    bne $t0,$t6, L3
    beq $t2, $zero, L3
    blt $t0, $s1, L2  
    bgt $t0, $s4, L2     
    ble $t0, $s2, L4    
        j L2

L2: sb  $t0, 0($t3)      
    addi $t3, $t3, 1     # B のインデックス（出力ポインタ
    addi $t2, $t2, 1     # A のインデックス（入力ポインタ
    li   $t6, 0          # space_flag = 0（空白ではない文字）
    j L1 

L3: blt  $t0, $s3, L4     # 'a' より小さい → L4
    bgt  $t0, $s4, L4     # 'z' より大きい → L4
    addi $t0, $t0, -32    # 小文字 → 大文字  (a→A)
    li   $t6, 0           # space_flag = 0（次は先頭ではない）
    j L2                  # 大文字化した文字を L2 で格納

L4: sb  $t0, 0($t3)     
    addi $t3, $t3, 1     # Bのインデックス
    addi $t2, $t2, 1     # Aのインデックス        
    j L1                 

L5:
    bne  $t6, $zero, L5_skip  # flag=1なら書かずに進める
    li   $t6, 1               # flag=0なら1にセット
    sb   $t1, 0($t3)          # Bに空白を書き込む
    addi $t3, $t3, 1
L5_skip:
    addi $t2, $t2, 1          # Aポインタ進める
    j L1

L6:
    sb   $zero, 0($t3)      
    la   $a0, B               
    li   $v0, 4               
    syscall
    li $v0,10
    syscall
    .data
A:  .space 101
B:  .space 101
space: .byte 0x20

