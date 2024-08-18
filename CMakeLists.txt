# Set the minimum version of CMake required
cmake_minimum_required(VERSION 3.30)

set(PICO_PLATFORM "rp2040")
set(PICO_BOARD "pico")
# set(PICO_DEFAULT_COMPILER "pico_arm_clang")
# set(PICO_COMPILER "pico_arm_clang")
# set(PICO_TOOLCHAIN_PATH "/Applications/LLVM-ET-Arm-18.1.3-Darwin-universal")
# set(CMAKE_C_COMPILER_WORKS 1)
# set(CMAKE_CXX_COMPILER_WORKS 1)
# set(CMAKE_SYSTEM_NAME Generic)
# set(CMAKE_SYSTEM_PROCESSOR arm)
# SET(CMAKE_CROSSCOMPILING 1)
# Set environment variables for toolchains and board
# set(ENV{TOOLCHAINS} "swift")

# Set the path to the Pico SDK
set(PICO_SDK_PATH $ENV{PICO_SDK_PATH})

# Include the Pico SDK
include(${PICO_SDK_PATH}/external/pico_sdk_import.cmake)

# Set Swift compilation mode and indicate that the Swift compiler works
set(CMAKE_Swift_COMPILER_WORKS YES)

# Define the project name
project(pico_swift-playground)

# Workaround release build is not work due to mystery compiler optimazation crash.
# debug build is work fine.
set(CMAKE_BUILD_TYPE Debug)

# Initialize the Pico SDK
pico_sdk_init()

# include i2c helper util
add_subdirectory(i2c_util)

# Enable Swift language support
enable_language(Swift)

# Add the executable target and source files
add_executable(pico_swift Main.swift Device.swift)
set_target_properties(pico_swift PROPERTIES LINKER_LANGUAGE CXX)

# Clear default compile options and set them only for C code
set_target_properties(pico_standard_link PROPERTIES INTERFACE_COMPILE_OPTIONS "")
target_compile_options(pico_standard_link INTERFACE "$<$<COMPILE_LANGUAGE:C>:SHELL: -ffunction-sections -fdata-sections>")

# Set Swift include directories
set(SWIFT_INCLUDES)
foreach(dir ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
    string(CONCAT SWIFT_INCLUDES ${SWIFT_INCLUDES} "-Xcc ")
    string(CONCAT SWIFT_INCLUDES ${SWIFT_INCLUDES} "-I${dir} ")
endforeach()

# Set Swift compile options
# if compile with arm llvm toolchain, then add option -disable-stack-protector
target_compile_options(pico_swift PUBLIC "$<$<COMPILE_LANGUAGE:Swift>:SHELL:
        -target armv6m-none-none-eabi -Xcc -mfloat-abi=soft  -Xcc -fshort-enums -Xfrontend -function-sections
        -enable-experimental-feature Embedded -wmo
        -parse-as-library
        -disable-stack-protector
        -import-bridging-header ${CMAKE_CURRENT_LIST_DIR}/BridgingHeader.h
        -Xcc -DPICO_RP2040
				-Xlinker -lc
        -v
        ${SWIFT_INCLUDES}
    >")

# Link libraries to the executable
target_link_libraries(pico_swift
    pico_stdlib
    pico_time
    hardware_i2c
    i2cUtil
)

# Include directories for the project
# include_directories(${CMAKE_CURRENT_LIST_DIR}/include)

# Add extra outputs for the Pico board
pico_add_extra_outputs(pico_swift)

# Enable USB output and disable UART output for the executable
pico_enable_stdio_usb(pico_swift 1)
pico_enable_stdio_uart(pico_swift 0)
