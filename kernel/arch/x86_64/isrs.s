
.section .rodata
__idt_info:
    .word __idt_end - __idt_start -1
    .qword __idt_start

.text

.global init_idt_tab
init_idt_tab:
    lidt (__idt_info)
    sei
    ret