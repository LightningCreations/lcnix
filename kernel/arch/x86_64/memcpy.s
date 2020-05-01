
.global memcpy
.global memmove
.global memcmp
.global memset

memcpy:
    mov %rdi,%r11
    cmp $16,%rdx
    jb memmove
    mov (%rsi),%xmm0
    mov %xmm0,(%rdi)
    lea 16(%rsi),%rsi
    lea 16(%rdi),%rdi
    lea -16(%rdx),%rdx
    jmp memcpy
memmove:
    mov %rdx,%rcx
    jz .ret
    .rem1:
    mov (%rsi),%al
    mov %al,(%rdi)
    lea 1(%rsi),%rsi
    lea 1(%rdi),%rdi
    lea -1(%rdx),%rdx
    jnz .rem1
    .ret:
    mov %r11,%rax
    ret

bcmp:
memcmp:
    lea -1(%rdx),%rdx
    xor %rax,%rax
    jl .memcmp_ret
    mov (%rdi),%al
    mov (%rsi),%bl
    sub %bl,%al
    jz memcmp
    .memcmp_ret:
    movsx %al,%rax
    ret

memset:
    mov %rsi,%rax
    mov %rdi,%rsi
    mov %rdx,%rcx
    rep stosb
    mov %rsi,%rax
    ret

