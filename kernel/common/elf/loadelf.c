#include <stdint.h>
#include <unistd.h>
#include "elf.h"

struct elf_file loadelf(int fd) {
    struct elf_file result;

    uint8_t sig[4];
    read(fd, sig, 4);

    result.ei_valid = 0;

    if(sig[0] != '\x7F' || sig[1] != 'E' || sig[2] != 'L' || sig[3] != 'F')
        return result;

    result.ei_valid = 1;

    uint8_t buf1;
    read(fd, &buf1, 1);
    result.ei_class = buf1;

    read(fd, &buf1, 1);
    result.ei_data = buf1;

    read(fd, &buf1, 1);
    result.ei_version = buf1;

    lseek(fd, 9, SEEK_CUR);

    return result;
}
