
.text

.syscall_handler:
    lea __syscall,%r10
    lea 4(%r10,%rax),%r10
    mov (%r10),%r9
    jz .enosys
    lea __syscall_end,%r11
    cmp %r10,%r11
    jbe .enosys
    call *%r8
    sysret
    .enosys:
    mov $-1024,%rax # Hardcoding ENOSYS to 1024.
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

