#include "i2c_util.h"
#include "hardware/i2c.h"

// Function to return pointer to i2c0_inst
i2c_inst_t* get_pointer(void) {
    return i2c0;
}

