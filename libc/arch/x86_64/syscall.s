.text

.global syscall
syscall:
    # Bump all arguments by one, and move the first (the syscall number) into rax
    mov %rdi,%rax
    mov %rsi,%rdi
    mov %rdx,%rsi
    mov %rcx,%rdx
    mov %r8,%r10
    mov %r9,%r8
    mov 8(%rsp),%r9
    syscall
    mov %rax,%rdi
    js .seterrno
    ret
    .seterrno:
    lea __errno(%rip), %rsi
    neg %rdi
    mov %rdi,(%rsi)

    ret

