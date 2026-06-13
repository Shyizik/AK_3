.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global _hard_reset

.section .text
.type vtable, %object
.type _hard_reset, %function

vtable:
    .word _stack_start
    .word _hard_reset + 1
    .size vtable, . - vtable

_hard_reset:
    ldr r0, =_stack_start
    mov sp, r0
    
    bl lab2
    
_loop: 
    b _loop

.size _hard_reset, . - _hard_reset
