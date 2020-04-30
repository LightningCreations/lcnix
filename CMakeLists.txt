cmake_minimum_required(VERSION 3.15)
project(lcnix CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/lccc/cmake")

# If we have lccc, use it.
# If someone knows what they are doing on clang or gcc, then can -DLCNIX_OVERRIDE_COMPILERS
# GNU Toolchain is not supported for full Builds.
# Bootstrapping with GCC is supported, as is using gnu binutils with clang in both GNU mode and Native Mode
# lccc is recommended natively.
include(detect_lccc.cmake)
if(NOT LCNIX_OVERRIDE_COMPILERS)
    detect_lccc(C CMAKE_C_COMPILER)
    detect_lccc(CXX CMAKE_CXX_COMPILER)
    detect_lccc(LD CMAKE_LD)
    detect_lccc(AR CMAKE_AR)
else()
    message(WARNING "-- Overriding detection of lc toolchain, this can cause problems with builds")
endif()

# The following lines are for satisfying CMAKE
# Remove in production
set(LCNIX_TARGET_ARCH x86_64)


if(LCNIX_BOOTSTRAP_BUILD AND LCNIX_GNU_BUILD)
    message(FATAL_ERROR "Bootstrapping, and in-place GNU Build are mutually exclusive")
endif()

if(LCNIX_BOOTSTRAP_BUILD)
    message("-- Bootstrapping lcnix from scratch")
    if(NOT DEFINED LCNIX_BOOTSTRAP_ROOT)
        set(LCNIX_BOOTSTRAP_ROOT "/mnt/lcnix")
    endif()
    detect_lccc(CODEGEN LCNIX_LCCC_GENERATOR)
    set(CMAKE_INSTALL_PREFIX "${LCNIX_BOOTSTRAP_ROOT}/lcnix-stage1")
    set(_LCNIX_BOOTSTRAP_SOURCES_ROOT "${LCNIX_BOOTSTRAP_ROOT}/lcnix-sources")
    set(LCNIX_GNU_BUILD "ON")
    set(_LCNIX_STAGE1_CHROOT "${CMAKE_CURRENT_SOURCE_DIR}/scripts/as-root.sh chroot ${LCNIX_BOOTSTRAP_ROOT}")
    set(_LCNIX_CMAKE_STAGE2_DEFINES "-D_LCNIX_BOOTSTRAP_STAGE2=ON -DLCNIX_BUILD_LIBC=ON -DLCNIX_BUILD_SYSTEMD=ON")
    add_subdirectory(stage1)
endif()

if(NOT DEFINED LCNIX_BUILD_LCCC)
    set(LCNIX_BUILD_LCCC "ON")
endif()
if(NOT DEFINED LCNIX_BUILD_KERNEL AND NOT LCNIX_GNU_BUILD)
    set(LCNIX_BUILD_KERNEL ON)
endif()

if(LCNIX_BUILD_LCCC)
    message("-- Building LCCC Compiler")
    add_subdirectory(lccc)
endif()


if(LCNIX_BUILD_KERNEL)
    if(LCNIX_GNU_BUILD)
        message(WARNING "-- Building lcnix kernel on GNU/Linux is not supported")
    endif()
    message("-- Building lcnix kernel")
    set(LCNIX_LCCC_KERNEL_HEADERS ON)
    add_subdirectory(kernel)
    include_directories(include)
endif()

if(LCNIX_BUILD_LIBC)
    if(LCNIX_GNU_BUILD)
        message(WARNING "-- Building libc on GNU/Linux is not supported")
    endif()
    message("-- Building libc and low-level libraries")
    # Enable LSB required low-level libraries, including libc
    add_subdirectory(libm)
endif()

if(LCNIX_BUILD_SYSTEMD)
    if(NOT _LCNIX_BOOTSTRAP_STAGE2)
        message(WARNING "Building Systemd outside of bootstrap is not supported")
    endif()
    message("-- Building systemd")
    include(ExternalProject)
    ExternalProject_Add(systemd
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/systemd
        CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/systemd && ${CMAKE_CURRENT_SOURCE_DIR}/systemd/configure
        BUILD_COMMAND make -C ${CMAKE_CURRENT_SOURCE_DIR}/systemd
    )
endif()

