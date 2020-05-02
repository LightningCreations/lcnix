enable_language(C)

set(CMAKE_C_DIALECT 11)
set(CMAKE_C_FLAGS "-ffreestanding")

add_subdirectory(arch/${LCNIX_TARGET_ARCH})
add_subdirectory(common)

add_library(m-shared SHARED $<TARGET_OBJECTS:m-common> $<TARGET_OBJECTS:m-arch-${LCNIX_TARGET_ARCH}>)
set_target_properties(m-shared PROPERTIES OUTPUT_NAME m SOVERSION 1.0)
add_library(m-static STATIC $<TARGET_OBJECTS:m-common> $<TARGET_OBJECTS:m-arch-${LCNIX_TARGET_ARCH}>)
set_target_properties(m-static PROPERTIES OUTPUT_NAME m)