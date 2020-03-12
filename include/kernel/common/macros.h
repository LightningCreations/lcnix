//
// Created by connor on 2020-03-12.
//

#ifndef LCNIX_MACROS_H
#define LCNIX_MACROS_H

#ifndef MODULES
#ifndef LCNIX_USE_SNESOS_MAP
#define __init __attribute__((section(".text.init")))
#define __initdata __attribute__((section(".data.init")))
#else
#define __init __attribute__((section(".text.kinit")))
#define __initdata __attribute__((section(".data.kinit")))
#endif
#else
#define __init
#define __initdata
#endif

#endif //LCNIX_MACROS_H
