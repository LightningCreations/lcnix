enable_language(C)

set(CMAKE_C_DIALECT 11)
set(CMAKE_C_FLAGS "-ffreestanding")

add_subdirectory(arch/${LCNIX_TARGET_ARCH})

add_library(m SHARED __finite.c __finitef.c arch/${LCNIX_TARGET_ARCH})
