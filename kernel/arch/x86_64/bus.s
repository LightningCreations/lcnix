
.globl read8

read8:
    inb %dx, %al
    ret

.global read16

read16:
    inw %dx, %ax
    ret

.global read32

read32:
    inl %dx, %eax
    ret

.globl write8

write8:
    mov %sil,%al
    outb %al, %dx
    ret

.globl write16

write16:
    mov %si,%ax
    outw %ax,%dx
    ret

.globl write32
write32:
    mov %esi,%eax
    outl %eax,%dx
    ret

.global kwrite
kwrite:
    mov %rsi,%rcx
    mov %rdi,%rsi
    ret