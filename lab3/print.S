.syntax unified
.thumb

.global dbgput_line
.global dbgput_num
.global newline

.equ SEMIHOSTING_SYS_WRITE0, 0x04
.equ SEMIHOSTING_SYS_WRITEC, 0x03

.section .text

// Вивід рядка
.type dbgput_line, %function
dbgput_line:
    push {r0-r4, lr}
    mov r1, r0
    mov r0, #SEMIHOSTING_SYS_WRITE0
    bkpt #0xAB
    pop {r0-r4, pc}

// Вивід одного символу
.type dbgput_char, %function
dbgput_char:
    push {r0-r4, lr}
    sub sp, sp, #4
    strb r0, [sp]
    mov r1, sp
    mov r0, #SEMIHOSTING_SYS_WRITEC
    bkpt #0xAB
    add sp, sp, #4
    pop {r0-r4, pc}

// Переведення рядка
.type newline, %function
newline:
    push {r0-r4, lr}
    mov r0, #'\n'
    bl dbgput_char
    pop {r0-r4, pc}

// Вивід HEX-числа
.type dbgput_num, %function
dbgput_num:
    push {r4, r5, lr}
    mov r5, r0         // Збереження числа для виводу
    mov r4, #28        // Ініціалізація лічильника зсуву
print_hex_loop:
    mov r0, r5
    lsr r0, r0, r4
    and r0, r0, #0xF
    cmp r0, #9
    ble print_digit
    add r0, r0, #('A' - 10)
    b print_char
print_digit:
    add r0, r0, #'0'
print_char:
    bl dbgput_char
    subs r4, r4, #4
    bge print_hex_loop
    bl newline
    pop {r4, r5, pc}
