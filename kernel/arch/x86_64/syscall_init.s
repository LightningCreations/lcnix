
.text

.syscall_handler:
    call __syscall
    sysret


init_syscall_handle:
    lea .syscall_handler,%rax
    mov %rax,%rdx
    shr %rdx,$32
    movd $0x82,%ecx
    wrmsr
    movd $0x83,%ecx
    wrmsr
    # set both LSTAR and CSTAR

