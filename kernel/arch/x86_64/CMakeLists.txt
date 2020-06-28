
enable_language(ASM)

add_library(i386-loader OBJECT loader.s)
# set_target_properties(i386-loader PROPERTIES COMPILE_FLAGS "-m32")

add_library(lcnix-kernel-arch-x86_64 STATIC syscall_init.s bus.s gdt.c idt.c loader-64long.s $<TARGET_OBJECTS:i386-loader> halt.s isrs.s)


