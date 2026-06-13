.syntax unified
.thumb
.global lab2

.equ A, 10
.equ B, 4
.equ C, 3

.section .text
.type lab2, %function
lab2:
    push {lr}

    //c!
    mov r0, #C
    bl factorial
    mov r3, r0

    //(a+b)/2
    mov r0, #A
    mov r1, #B
    add r0, r0, r1
    asr r0, r0, #1

    //0(a+b)/2 + c!
    add r0, r0, r3

    pop {pc}

.type factorial, %function
factorial:
    push {r1, lr}
    mov r1, r0
    mov r0, #1
    cmp r1, #1
    ble fact_end
fact_loop:
    mul r0, r0, r1
    sub r1, r1, #1
    cmp r1, #1
    bgt fact_loop
fact_end:
    pop {r1, pc}
