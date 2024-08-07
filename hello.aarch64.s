.section .rodata
msg:      .asciz "Hello, World!"
title:    .asciz "Message"
format:   .asciz "MessageBoxA returned %d: "
abort:    .asciz  "Abort  "
retry:    .asciz  "Retry  "
ignore:   .asciz "Ignore "
unknown:  .asciz "Unknown"

.section .data
buffer:   .space 128

.section .text
    .extern show_message
    .extern printf
    .extern puts
    .extern exit
    .global main

main:
    // Function prologue
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Call show_message(title, msg)
    ldr x0, =title
    ldr x1, =msg
    bl show_message
    mov x19, x0  // Store returned value in x19

    // Print formatted message
    ldr x0, =format
    mov x1, x19
    bl printf

    // Compare the returned value with 3
    cmp x19, #3
    b.eq print_abort

    // Compare the returned value with 4
    cmp x19, #4
    b.eq print_retry

    // Compare the returned value with 5
    cmp x19, #5
    b.eq print_ignore

    // If none of the above, print "Unknown"
    ldr x0, =unknown
    b print_call

print_abort:
    ldr x0, =abort
    b print_call

print_retry:
    ldr x0, =retry
    b print_call

print_ignore:
    ldr x0, =ignore

print_call:
    // Print the selected message
    bl puts

_exit:
    // Function epilogue
    ldp x29, x30, [sp], 16
    ret

