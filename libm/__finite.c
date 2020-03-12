#include <math.h>
#include <stdint.h>

int __finite(double arg) {
    if(((((uint64_t) arg) & 0x7FFC000000000000) >> 52) == 0x3FFF) return 0;
    return 1;
}
