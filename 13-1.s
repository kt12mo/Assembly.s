    .text
    .global main
main:
    li.s $f10, 10.0
    li.s $f1, 0.0
    li.s $f2, 0.0 #sum
    li.s $f3, 0.0 #MAX
    li.s $f4, 0.0 #min
    li.s $f6, 0.0 #average
    li.s $f20, 0.0
    li.s $f21, 1.0

L1: c.le.s $f10,$f1
    bc1t L2
    
    li $v0,6 #キーボードから少数入力
    syscall # $f0に入る

    c.eq.s $f0,$f20
    bc1t L2

    add.s $f2,$f2,$f0
    c.lt.s $f0,$f3
    bc1t L3
    mov.s $f3,$f0

L3: c.le.s $f4,$f0
    bc1t L4
    mov.s $f4,$f0

L4: add.s $f1,$f1,$f21
    j L1

L2: c.eq.s $f1, $f20
    bc1t EXIT 

    div.s $f6,$f2,$f1

    li $v0,4
    la $a0,AVE 
    syscall
    mov.s $f12,$f6
    li $v0,2
    syscall

    li $v0,4
    la $a0,MAX
    syscall
    mov.s $f12,$f3
    li $v0,2
    syscall

    li $v0,4
    la $a0,MIN 
    syscall
    mov.s $f12,$f4
    li $v0,2
    syscall

    li $v0,4
    la $a0,NUM
    syscall
    mov.s $f12,$f1
    li $v0,2
    syscall

EXIT:  
    li $v0,10
    syscall
    jr $ra

    .data
AVE: .asciiz "\n Average:"
MAX: .asciiz "\n Max:"
MIN: .asciiz "\n Min:"
NUM: .asciiz "\n Number of data:"


 　　