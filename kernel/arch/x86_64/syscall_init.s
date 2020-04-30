
.text

.syscall_handler:
    lea __syscall,%r8
    lea 4(%r8,%rax),%r8
    call *%r8
    sysret


.globl init_syscall_handle

init_syscall_handle:
    lea .syscall_handler,%rax
    mov %rax,%rdx
    shr $32,%rdx
    mov $0x82,%ecx
    wrmsr
    mov $0x83,%ecx
    wrmsr
    # set both LSTAR and CSTAR
    # Deal with the rest later.

