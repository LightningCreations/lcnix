

project(lcnix-kernel C Rust)



set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_FLAGS "-ffreestanding -fno-rtti -fno-exceptions")
set(CMAKE_C_FLAGS "-ffreestanding")

add_subdirectory(arch)
add_subdirectory(common)

add_executable(lcnix-kernel dummy.cpp)
set_target_properties(lcnix-kernel PROPERTIES LINK_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/ld/${LCNIX_TARGET_ARCH}-lcnix-kernel.ld;${CMAKE_CURRENT_SOURCE_DIR}/ld/generic-lcnix-kernel.ld")
target_link_libraries(lcnix-kernel -Wl,--start-group lcnix_kernel_common lcnix-kernel-arch-${LCNIX_TARGET_ARCH} -Wl,--end-group)

target_link_options(lcnix-kernel PRIVATE -nostdlib -Wl,-Map=lcnix-kernel.map -nodefaultlibs -static -L${CMAKE_CURRENT_SOURCE_DIR}/ld  -Wl,-T -Wl,${CMAKE_CURRENT_SOURCE_DIR}/ld/${LCNIX_TARGET_ARCH}-lcnix-kernel.ld)

