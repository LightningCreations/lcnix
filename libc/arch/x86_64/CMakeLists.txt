enable_language(ASM)

add_library(c-arch-x86_64 OBJECT syscall.s exit.s unwind_deterministic.c)
add_subdirectory(ld)