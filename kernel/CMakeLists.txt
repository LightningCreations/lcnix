
enable_language(C)



set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_FLAGS "-ffreestanding -fno-rtti -fno-exceptions")
set(CMAKE_C_FLAGS "-ffreestanding")

add_subdirectory(arch)
include_directories(common)

add_library(lcnix STATIC common/allocator.h common/main.cpp common/elf/loadelf.c ../include/kernel/proc/credentials.hpp ../include/kernel/common/macros.h arch/${LCNIX_TARGET_ARCH} common/list.h)
