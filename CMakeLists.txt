project(lcnix CXX)
cmake_minimum_required(VERSION 3.10)

include_directories(include)

# The following lines are for satisfying CMAKE
# Remove in production
set(LCNIX_TARGET_ARCH x86_64)

add_subdirectory(kernel)
add_subdirectory(libm)

