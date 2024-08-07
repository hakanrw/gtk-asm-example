.section .rodata
    msg: .asciz "Hello, World!"
    title: .asciz "Message"
    format: .asciz "MessageBoxA returned %d: "
    abort: .asciz  "Abort  "
    retry: .asciz  "Retry  "
    ignore: .asciz "Ignore "
    unknown: .asciz "Unknown"

.section .data
    buffer: .space 128

.section .text
    .extern show_message
    .extern printf
    .extern puts
    .extern exit
    .global main

main:
    sub $8, %rsp

    mov $title, %rdi
    mov $msg, %rsi
    call show_message
    mov %rax, %rbx

    mov $0, %rax
    mov $format, %rdi
    mov %rbx, %rsi
    call printf

    cmp $3, %rbx
    je print_abort

    cmp $4, %rbx
    je print_retry

    cmp $5, %rbx
    je print_ignore

    mov $unknown, %rdi
    jmp print_call

print_abort:
    mov $abort, %rdi
    jmp print_call

print_retry:
    mov $retry, %rdi
    jmp print_call

print_ignore:
    mov $ignore, %rdi
    jmp print_call

print_call:
    mov $0, %rax
    call puts

_exit:
    mov $0, %rax
    add $8, %rsp
    ret
