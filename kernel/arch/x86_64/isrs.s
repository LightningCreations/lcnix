
.text


.global init_interrupts
init_interrupts:
    lidt (__idt_info)
    ret

.data
__idt_info:
