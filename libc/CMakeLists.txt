
enable_language(C)

include_directories(SYSTEM include)

add_subdirectory(arch/${LCNIX_TARGET_ARCH})
add_subdirectory(common)
add_subdirectory(crt)
add_subdirectory(ld)


add_library(c-static STATIC $<TARGET_OBJECTS:c-arch-${LCNIX_TARGET_ARCH}> $<TARGET_OBJECTS:c-common>)
add_library(c-shared SHARED $<TARGET_OBJECTS:c-arch-${LCNIX_TARGET_ARCH}> $<TARGET_OBJECTS:c-common>)
add_library(c ALIAS c-static)
set(LCNIX_LIBC_VER "0.1")

set_target_properties(c-static PROPERTIES OUTPUT_NAME c)
set_target_properties(c-shared PROPERTIES OUTPUT_NAME c SOVERSION ${LCNIX_LIBC_VER})
target_link_options(c-shared PRIVATE "-nostdlib")
target_link_options(c-static PRIVATE "-nostdlib")

install(TARGETS c-static c-shared crt EXPORT libc LIBRARY DESTINATION lib OBJECTS DESTINATION lib)
install(DIRECTORY include DESTINATION . FILES_MATCHING PATTERN "*.h")
