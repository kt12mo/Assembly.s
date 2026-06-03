
# 逆ポーランド変換
    .text
    .globl main
main:
    li $v0, 8   # キーボードから文字列を入力（syscall8番）
    la $a0, A
    li $a1, 30
    syscall
    li $t3, 0# 配列Aのインデックス $t3
    lb $t1, A($t3)
    beq $t1, $zero, PLEXT  # A[0] が NULL なら終了
### 変換処理 ###
# SS に戻るための戻り番地をスタックに push する
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # OSへの戻り番地をpush
    addi $sp, $sp, -4
    li $t8, 0xffffffff
    sw $t8, 0($sp)   # スタック清掃用目印を push
    addi $sp, $sp, -4
    sw $ra, 0($sp)   # 戻り番地 push
jal GETC          # 1文字取り出す
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal EXP           # 変換処理開始
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $t9, 0x0A      # 改行文字
    bne $t1, $t9, EREND
    li $v0, 4
    la $a0, B         # 結果を出力
    syscall

EREND:
    li $v0, 4
    la $a0, ERMSG
    syscall
    j CLEAR

CLEAR:
    lw $t6, 0($sp)
    addi $sp, $sp, 4
    li $t8, 0xffffffff
    bne $t6, $t8, CLEAR
    lw $ra, 0($sp)
    addi $sp, $sp, 4

PLEXT:
    li $v0, 10
    syscall
    jr $ra

# この下から、データセグメントより前に関










## 関数 GETC ##
GETC:
    lb $t1, A($t3)
    addi $t3, $t3, 1
    li $t9, 0x20
    beq $t1, $t9, GETC
    jr $ra

#### 関数 TERM：項の処理 ####
TERM:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal FACTOR
    lw $ra, 0($sp)
    addi $sp, $sp, 4

TO:
    li $t9, 0x2A   # '*'
    beq $t1, $t9, T1
    li $t9, 0x2F   # '/'
    bne $t1, $t9, TERMEND

T1:
    addi $sp, $sp, -4
    sw $t1, 0($sp)
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal GETC
    lw $ra, 0($sp)
    addi $sp, $sp, 4    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal FACTOR
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    lw $t0, 0($sp)
    addi $sp, $sp, 4
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal STORE
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j TO
TERMEND:
    jr $ra

##### 関数 EXP：式の処理 ####

# ここにコードを書く (課題)

EXP:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)        #push
    jal  TERM               #最初の項
    lw   $ra, 0($sp)        #pop
    addi $sp, $sp, 4

EXP1:
    li   $t9, 0x2B          #'+'
    beq  $t1, $t9, EXP2
    li   $t9, 0x2D          #'-'
    bne  $t1, $t9, EXP_end  #+ でも - でもなければendに

EXP2:
    addi $sp, $sp, -4
    sw   $t1, 0($sp)        #演算子32-bit push

    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal  GETC               #次の文字($t1)
    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal  TERM               #演算子の右側の項
    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    lw   $t0, 0($sp)        #演算子pop $t0
    addi $sp, $sp, 4

    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    jal  STORE              #演算子$t0を出力
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    j    EXP1

EXP_end:
    jr   $ra
##### 関数 FACTOR：因子 #####
FACTOR:
    li $t9, 0x28     # '('
    bne $t1, $t9, P1
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal GETC
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal EXP
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $t9, 0x29 #')'のアスキー  
    bne $t1, $t9, EREND
    j GETC

P1:
    li $t9, 0x41     # 'A'
    blt $t1, $t9, EREND
    li $t9, 0x5A     # 'Z'
    bgt $t1, $t9, EREND
P2:
    move $t0, $t1   
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal STORE
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    j GETC

##### 関数 STORE：出力 #####
STORE:
    sb $t0, B($t2)
    addi $t2,$t2,1
    jr $ra

.data
A: .space 30
B: .space 30

ERMSG: .asciiz "*ERROR*\n" #エラーメッセ