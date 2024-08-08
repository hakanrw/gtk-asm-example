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
    push   %rbp
    mov    %rsp,%rbp
    sub    $0x20,%rsp

    mov $title, %rdx
    mov $msg, %rcx
    call show_message
    mov %rax, %rbx

    mov $0, %rax
    mov $format, %rcx
    mov %rbx, %rdx
    call printf

    

    cmp $3, %rbx
    je print_abort

    cmp $4, %rbx
    je print_retry

    cmp $5, %rbx
    je print_ignore

    mov $unknown, %rcx
    jmp print_call

print_abort:
    mov $abort, %rcx
    jmp print_call

print_retry:
    mov $retry, %rcx
    jmp print_call

print_ignore:
    mov $ignore, %rcx
    jmp print_call

print_call:
    mov $0, %rax
    call puts

_exit:
    mov    $0x0,%eax
    add    $0x20,%rsp
    pop    %rbp
    ret
