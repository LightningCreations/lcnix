enable_language(ASM)

add_library(c-arch-x86_64 OBJECT syscall.s exit.s)
set_target_properties(c-arch-x86_64 PROPERTIES POSITION_IDENPENDENT_CODE ON)
add_subdirectory(ld)