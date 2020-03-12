
.text

.syscall_handler:
    call __syscall
    sysret


init_syscall_handle:
    lea .syscall_handler,rax
    mov rax,rdx
    shr rdx,$32
    mov $0x82,ecx
    wrmsr
    mov $0x83,ecx
    wrmsr
    # set both LSTAR and CSTAR

