    .text
    .globl main
main:
    li $a0, 9 #n=とする
    addi $sp,$sp,-4 #OSの戻り番地をスタックに退避
    sw $ra,0($sp) #push

    jal Func

    lw $ra,0($sp)
    addi $sp,$sp,4

    move $s1,$v0
    li $v0, 10
    syscall
    jr $ra

Func:
    beq $a0,$zero,zero_case #n==0なら飛ぶ
    addi $sp,$sp,-8 #8バイトのスタックフレーム
    move $s0,$a0 #nの値を$s0に
    sw $s0,4($sp) #$s0をスタックに(n)
    sw $ra,0($sp) #$raをスタックに(戻り番地)

    addi $a0,$a0,-1 #$s0 == n-1
    jal Func 

    lw $s0,4($sp) #セーブしていたnを復元
    sll $t0,$s0,1 #2n
    addi $t0,$t0,-1 #-1
    add $v0,$v0,$t0 #最終結果A(n)が入る

Func_return:
    lw $ra,0($sp) 
    lw $s0,4($sp)
    addi $sp,$sp,8
    jr $ra

zero_case:
    li $v0, 0 #n==0の時の処理 結果は$v0
    jr $ra



