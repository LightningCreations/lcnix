#include <math.h>
#include <stdint.h>

int __finitef(float arg) {
    union {
        float f;
        uint32_t i;
    } u;
    u.f = arg;
    if(((u.i & 0x7F800000) >> 23) == 0xFF) return 0;
    return 1;
}
