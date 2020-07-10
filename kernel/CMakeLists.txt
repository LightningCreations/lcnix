

project(lcnix-kernel C Rust)

if(CMAKE_INSTALL_PREFIX STREQUAL "/usr" OR CMAKE_INSTALL_PREFIX STREQUAL "/usr/local")
    set(LCNIX_INSTALL_BOOTDIR_INIT /boot)
elseif(DEFINED LCNIX_BOOTSTRAP_SYSROOT)
    set(LCNIX_INSTALL_BOOTDIR_INIT ${LCNIX_BOOTSTRAP_SYSROOT}/boot)
else()
    set(LCNIX_INSTALL_BOOTDIR_INIT boot)
endif()

set(LCNIX_INSTALL_BOOTDIR ${LCNIX_INSTALL_BOOTDIR_INIT} CACHE PATH "The path to install kernel and boot artifacts")


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_FLAGS "-ffreestanding -fno-rtti -fno-exceptions")
set(CMAKE_C_FLAGS "-ffreestanding")

add_subdirectory(arch)
add_subdirectory(common)

set(LCNIX_KERNEL_VERSION 1.0)

set(LCNIX_KERNEL_USERSUFFIX "" CACHE STRING "Sets a custom user-defined suffix to append to the kernel version")
set(LCNIX_KERNEL_UNAME)

add_executable(lcnix-kernel dummy.cpp)
set_target_properties(lcnix-kernel PROPERTIES LINK_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/ld/${LCNIX_TARGET_ARCH}-lcnix-kernel.ld;${CMAKE_CURRENT_SOURCE_DIR}/ld/generic-lcnix-kernel.ld")
target_link_libraries(lcnix-kernel -Wl,--start-group lcnix_kernel_common lcnix-kernel-arch-${LCNIX_TARGET_ARCH} -Wl,--end-group)

target_link_options(lcnix-kernel PRIVATE -nostdlib -Wl,-Map=lcnix-kernel.map -nodefaultlibs -static -L${CMAKE_CURRENT_SOURCE_DIR}/ld  -Wl,-T -Wl,${CMAKE_CURRENT_SOURCE_DIR}/ld/${LCNIX_TARGET_ARCH}-lcnix-kernel.ld)

set_target_properties(lcnix-kernel PROPERTIES SUFFIX "-${LCNIX_KERNEL_VERSION}${LCNIX_KERNEL_SUFFIX}")
INSTALL(TARGETS lcnix-kernel DESTINATION ${LCNIX_INSTALL_BOOTDIR})


