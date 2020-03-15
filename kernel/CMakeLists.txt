
enable_language(C)



set(CMAKE_CXX_DIALECT 17)
set(CMAKE_C_DIALECT 11)
set(CMAKE_CXX_FLAGS "-ffreestanding -fno-rtti -fno-exceptions")
set(CMAKE_C_FLAGS "-ffreestanding")

add_subdirectory(arch)

add_library(lcnix STATIC dummy.cpp common/main.cpp ../include/kernel/proc/credentials.hpp ../include/kernel/common/macros.h arch)
