project(i2cUtil)

# Add the C source files
add_library(i2cUtil STATIC i2c_util.c)

# link pico sdk libs
target_link_libraries(i2cUtil pico_stdlib hardware_i2c)
