.syntax unified
.cpu cortex-m4
.thumb

.equ A, 10
.equ B, 4
.equ C, 3

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word _stack_start
    .word __kernel_reset__ + 1
    .size vtable_kernel, . - vtable_kernel

.section .rodata
msg_start: .asciz "kernel started!"
msg_result: .asciz "Final result in r0: 0x"

.section .text
__kernel_reset__:
    ldr r0, =_stack_start
    mov sp, r0

    // Вивід повідомлення про старт
    adr r0, msg_start
    bl dbgput_line
    bl newline

    // Обчислення математичного виразу
    mov r0, #C
    bl factorial
    mov r3, r0

    mov r0, #A
    mov r1, #B
    add r0, r0, r1
    asr r0, r0, #1
    add r0, r0, r3

    // Вивід результату обчислень
    mov r4, r0
    adr r0, msg_result
    bl dbgput_line
    mov r0, r4
    bl dbgput_num

end:
    b end              // Зациклення програми

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
