.syntax unified
.cpu cortex-m3
.thumb

.global vtable
.global _hard_reset_

.section .text

.type vtable, %object
vtable:
    .word stack_start
    .word _hard_reset_ + 1
    .size vtable, . - vtable

.type _hard_reset_, %function
_hard_reset_:
    ldr r0, =stack_start
    mov sp, r0
    b _hard_reset_
