.section .note.GNU-stack,"",@progbits

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
    pushl %ebp            # Save base pointer
    movl %esp, %ebp       # Set up stack frame

    mov $0, %eax
    push $msg
    push $title
    call show_message
    mov %eax, %ebx

    add $8, %esp

    mov $0, %eax
    push $0
    push $format
    call printf

    add $8, %esp

    cmp $3, %ebx
    je print_abort

    cmp $4, %ebx
    je print_retry

    cmp $5, %ebx
    je print_ignore

    push $unknown
    jmp print_call

print_abort:
    push $abort
    jmp print_call

print_retry:
    push $retry
    jmp print_call

print_ignore:
    push $ignore
    jmp print_call

print_call:
    mov $0, %eax
    call puts
    add $4, %esp

_exit:
    popl %ebp             # Restore base pointer
    mov $0, %eax
    ret
