.global start_x64

.text

start_x64:
    # Now we can use x86_64 instructions
    cli
    mov __gdt_data,%ax
    mov %ax,%es
    mov %ax,%fs
    mov %ax,%gs
    mov %ax,%ss
    mov %ebx,%edi
    call start_kernel
    _hlt:
    cli
    hlt
    jmp _hlt
