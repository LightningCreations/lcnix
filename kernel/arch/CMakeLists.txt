
enable_language(ASM)


add_subdirectory(${LCNIX_TARGET_ARCH})

add_library(arch STATIC ${LCNIX_TARGET_ARCH})