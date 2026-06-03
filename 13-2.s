.text
.globl main

main:
    li.s $f10, 10.0      # 入力可能な最大個数
    li.s $f1, 0.0        # カウント値
    li.s $f2, 0.0        # 総和
    li.s $f3, 0.0        # 最大値
    li.s $f4, 0.0        # 最小値
    li.s $f6, 0.0        # 平均値
    li.s $f20, 0.0       # 0.0保持
    li.s $f21, 1.0       # 1.0保持

L1:
    # if ($f10 <= $f1) then L2
    c.le.s $f10, $f1
    bc1t L2

    li $v0, 6            # float入力
    syscall              # $f0 に入る

    # if ($f0 == 0.0) then L2
    c.eq.s $f0, $f20
    bc1t L2

    add.s $f2, $f2, $f0 # 総和更新

    # if ($f0 < $f3) skip
    c.lt.s $f0, $f3
    bc1t L3
    mov.s $f3, $f0       # 最大値更新

L3:
    # if ($f4 <= $f0) skip
    c.le.s $f4, $f0
    bc1t L4
    mov.s $f4, $f0       # 最小値更新

L4:
    add.s $f1, $f1, $f21 # カウント++
    j L1

L2:
    # if (count == 0) EXIT
    c.eq.s $f1, $f20
    bc1t EXIT

    # 平均値 = 総和 / 個数
    div.s $f6, $f2, $f1

    # Average 表示
    li $v0, 4
    la $a0, AVE
    syscall

    mov.s $f12, $f6
    li $v0, 2
    syscall

    # Max 表示
    li $v0, 4
    la $a0, MAX
    syscall

    mov.s $f12, $f3
    li $v0, 2
    syscall

    # Min 表示
    li $v0, 4
    la $a0, MIN
    syscall

    mov.s $f12, $f4
    li $v0, 2
    syscall

    # Number of data 表示
    li $v0, 4
    la $a0, NUM
    syscall

    mov.s $f12, $f1
    li $v0, 2
    syscall

EXIT:
    li $v0, 10
    syscall
    jr $ra

.data
AVE: .asciiz "\n Average: "
MAX: .asciiz "\n Max: "
MIN: .asciiz "\n Min: "
NUM: .asciiz "\n Number of data: "