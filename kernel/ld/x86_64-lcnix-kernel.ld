INCLUDE generic-lcnix-kernel.ld

SECTIONS {
    .bss.stack ALIGN(4096):{
        __stack_tail = .;
        . = .+4096;
        __stack_head = .;
    }
    __vram_start = 0xb8000;
    .pt ALIGN(4096):{
        __pt_start = 0;
        __pml4t = 0;
        __pdpt = 0x1000;
        __pdt = 0x2000;
        __pt  = 0x3000;
    }
    .gdt ALIGN(4096):{
        __gdt = 0;
        __gdt_nul = .;
        SHORT(0xFFFF);
        SHORT(0);
        SHORT(0);
        BYTE(1);
        BYTE(0);
        __gdt_code = .;
        SHORT(0);
        SHORT(0);
        BYTE(0);
        BYTE(0x9a);
        BYTE(0xaf);
        BYTE(0);
        __gdt_data = .;
        SHORT(0);
        SHORT(0);
        BYTE(0);
        BYTE(0x92);
        BYTE(0);
        BYTE(0);
        __gdt_ptr = .;
        SHORT(__gdt_ptr);
        SHORT(ABSOLUTE(__gdt));
    }
}