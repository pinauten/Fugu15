#include <stdio.h>
#include <stdbool.h>
#include <mach/mach.h>

kern_return_t litehook_hook_function(void *source, void *target);