#include <stdbool.h>
#include <stdint.h>

struct elf_file {
    bool ei_valid;
    uint8_t ei_class;
    uint8_t ei_data;
    uint8_t ei_version;
};
