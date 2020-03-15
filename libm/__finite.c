#include <math.h>
#include <stdint.h>

int __finite(double arg) {
    union {
        double d;
        uint64_t i;
    } u;
    u.d = arg;
    if(((u.i & 0x7FF0000000000000) >> 52) == 0x7FF) return 0;
    return 1;
}
