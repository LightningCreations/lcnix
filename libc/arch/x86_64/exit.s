
.global _Exit
.global _exit

_exit:
_Exit:
    mov $60,%rax
    syscall
    ud2 # For good luck

