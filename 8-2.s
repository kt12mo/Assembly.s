.data
prompt: .asciiz "N (1-9): "

.text
.globl main

main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0
    move $t1, $t0

L1:
    beq $t1, $zero, L4

    addi $sp, $sp, -4
    sw $t0, 0($sp)

    move $a0, $t1
    move $a1, $t0
    jal Linedisp

    lw $t0, 0($sp)
    addi $sp, $sp, 4

    addi $t1, $t1, -1
    j L1

L4:
    li $v0, 10
    syscall

Linedisp:
    move $t0, $a0

L2:
    beq $t0, $zero, L3
    li $v0, 1
    move $a0, $t1
    syscall
    addi $t0, $t0, -1
    j L2

L3:
    sub $t2, $a1, $a0
    move $t0, $zero

L5:
    beq $t0, $t2, L6
    li $v0, 11
    li $a0, '*'
    syscall
    addi $t0, $t0, 1
    j L5

L6:
    li $v0, 11
    li $a0, 10
    syscall
    jr $ra
