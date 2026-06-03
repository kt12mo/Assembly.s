    .text
    .globl main
main:
    li $s0,20           #$t1(未整列部分の先頭インデックス)
    li $s1,16           #$t2(最大値を探すインデックス)
    li $t1,0            #$t3,前の最大値位置 $t4,今の最大値の置
outloop:
    addi $t2,$t1,4
    move $t3,$t1
    lw $t4,A($t1)
inloop:
    lw $t8,A($t2)
    bgt $t4,$t8,skip  #$t4の方が大きいとskipへ
    move $t4,$t8  #大きい方を$t4(最大値)
    move $t3,$t2  #最大値の位置を$t2に
skip:
    addi $t2,$t2,4
    blt $t2,$s0,inloop
    lw $t0,A($t1) #外側の値を$t0に一回避難
    sw $t0,A($t3)  #最大値の位置$t3に書き戻す
    sw $t4,A($t1)  #外側位置に書き戻す
    addi $t1,$t1,4
    blt $t1,$s1,outloop
fin:
    li $v0,10
    syscall
    jr $ra

    .data
A:  .word 7, 8, 9, 10, 11
