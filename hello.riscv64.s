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
    # Function prologue
    addi sp, sp, -16           # Make room on the stack
    sd ra, 8(sp)              # Save the return address
    sd s0, 0(sp)               # Save the frame pointer
    mv s0, sp                  # Set the frame pointer

    # Call show_message(title, msg)
    la a0, title               # Load address of title into a0
    la a1, msg                 # Load address of msg into a1
    call show_message          # Call show_message
    mv t0, a0                  # Move the return value to t0

    # Print formatted message
    la a0, format              # Load address of format into a0
    mv a1, t0                  # Move the return value into a1
    call printf                # Call printf

    # Compare the returned value with 3
    li t1, 3                   # Load immediate 3 into t1
    beq t0, t1, print_abort   # Branch to print_abort if t0 == 3

    # Compare the returned value with 4
    li t1, 4                   # Load immediate 4 into t1
    beq t0, t1, print_retry   # Branch to print_retry if t0 == 4

    # Compare the returned value with 5
    li t1, 5                   # Load immediate 5 into t1
    beq t0, t1, print_ignore  # Branch to print_ignore if t0 == 5

    # If none of the above, print "Unknown"
    la a0, unknown             # Load address of unknown into a0
    j print_call               # Jump to print_call

print_abort:
    la a0, abort               # Load address of abort into a0
    j print_call               # Jump to print_call

print_retry:
    la a0, retry               # Load address of retry into a0
    j print_call               # Jump to print_call

print_ignore:
    la a0, ignore              # Load address of ignore into a0

print_call:
    call puts                  # Call puts to print the message

_exit:
    # Function epilogue
    ld ra, 8(sp)               # Restore the return address
    ld s0, 0(sp)               # Restore the frame pointer
    addi sp, sp, 16            # Restore the stack pointer
    li a0, 0                   # Load immediate 0 into a0 (exit status)
    ret                        # return
