    .text
    .globl main
main:
    li $s7, 4 # 挿入データ今回は()を$s7格納
    li $v0, 9     
    li $a0, 8     #8バイト確保(data+next)
    syscall
    move $s1, $v0        #s1→新ノードの住所
    sw $s1, first($zero) 
    li $t0, 1
    sw $t0, 0($s1)       #data=1 箱を作って１を入れてfirstに登録

    li $v0, 9 
    li $a0, 8
    syscall
    sw $v0, 4($s1)  #next→新しい箱
    move $s1, $v0        
    li $t0, 3
    sw $t0, 0($s1)      

    li $v0, 9
    li $a0, 8
    syscall
    sw $v0, 4($s1) 
    move $s1, $v0       
    li $t0, 5
    sw $t0, 0($s1)       

    li $v0, 9
    li $a0, 8
    syscall
    sw $v0, 4($s1)
    move $s1, $v0     
    li $t0, 7 
    sw $t0, 0($s1)    

    li $v0, 9
    li $a0, 8
    syscall
    sw $v0, 4($s1) 
    move $s1, $v0        
    li $t0, 9
    sw $t0, 0($s1)     
    sw $zero, 4($s1)    


### 新ノード
    li $v0, 9    
    li $a0, 8
    syscall
    move $s2, $v0 
    sw $s7, 0($s2) 

    lw $s0, first($zero) 

INSERT_LOOP:
    lw $t4, 4($s0)     #next
    beq $t4, $zero, INSERT_AT_END  #末尾に追加

    lw $t5, 0($t4)  #次の箱の数字を確認
    blt $s7, $t5, PERFORM_INSERT #aはnextより小さいかどうか

    move $s0, $t4 
    j INSERT_LOOP

PERFORM_INSERT:
    sw $t4, 4($s2)  #new→next = next
    sw $s2, 4($s0)  #curr→next = new
    j PRINT_LIST

INSERT_AT_END:
    sw $zero, 4($s2) 
    sw $s2, 4($s0)   
    j PRINT_LIST

PRINT_LIST:
    lw $s0, first($zero) 

LOOP2:
    beq $s0, $zero, ENDLP 

    lw $a0, 0($s0) 
    li $v0, 1      
    syscall

    la $a0, kuuhaku 
    li $v0, 4   
    syscall

    lw $s0, 4($s0)
    j LOOP2

ENDLP:
    li $v0, 10 # syscall 10: exit [5, 6, 9]
    syscall

    .data
    first: .word 0     # 連結リストの頭のアドレスを格納 [3, 6]
    kuuhaku: .asciiz " " # セパレータとしての空白 [9]