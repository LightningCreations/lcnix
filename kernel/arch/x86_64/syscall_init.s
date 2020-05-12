
.text

.syscall_handler:
    mov %r10,%rcx # Apparently arg 6 is in r10, but Sys-V expects it in rcx, so move it back to rcx before making the call
    lea __syscall,%r11
    lea (%r11,%rax,8),%r11
    mov (%r11),%rax
    jz .enosys
    lea __syscall_end,%rax
    cmp %rax,%r11
    jbe .enosys
    xor %rax,%rax # In case the whole register isn't overwritten, zero it so that nothing gets leaked back to PM 3
    call *%r11
    xor %r11,%r11
    sysret
    .enosys:
    xor %rax,%rax # Yes its dumb, we are explicitly calling mov, but I don't want to leak PM 0 temporaries to PM 3
    xor %r11,%r11
    mov $-1024,%rax # Hardcoding ENOSYS to 1024.
    sysret



.globl init_syscall_handle

init_syscall_handle:
    lea .syscall_handler,%rax
    mov %rax,%rdx
    shr $32,%rdx
    mov $0x82,%ecx
    wrmsr
    # set LSTAR
    ret

