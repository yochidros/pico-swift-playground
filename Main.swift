
@main
struct Main {
    // PICO_DEFAULT_LED_PIN: GP25
    static func main() {
        // if you need print debug, comment out this code.
        // stdio_init_all()

        // initialize pico-sdk
        var device = PicoDevice(
            defaultLED: LED(pin: UInt32(PICO_DEFAULT_LED_PIN)),
            redLed: LED(pin: UInt32(22)),
            blueLed: LED(pin: UInt32(16)),
            greenLed: LED(pin: UInt32(18)),
            button: nil,
            lcd: LCD()
        )

        // demoDefaultLED()

        while true {
            // demoLEDs(&device)
            demoFinal(&device)
        }
    }

    static func demoDefaultLED() {
        let pin = UInt32(PICO_DEFAULT_LED_PIN)
        gpio_init(pin)
        gpio_set_dir(pin, true)

        while true {
            gpio_put(pin, true)
            sleep_ms(1000)
            gpio_put(pin, false)
            sleep_ms(1000)
        }
    }

    static func demoLEDs(_ device: inout PicoDevice) {
        device.allOn.toggle()
        sleep_ms(1000)
    }

    static func demoLEDsWithButton(_ device: inout PicoDevice) {
        if device.button?.isPressed == true {
            device.allOn.toggle()
            while device.button?.isPressed == true {
                sleep_ms(100)
            }
        }
    }

    static func demoFinal(_ device: inout PicoDevice) {
        device.allOn = false
        device.lcd?.clear()
        sleep_ms(2000)

        device.lcd?.displayString("iOSDC ")
        sleep_ms(1000)
        device.lcd?.displayString("Japan ")
        sleep_ms(1000)
        device.lcd?.displayString("2024")
        sleep_ms(1000)
        device.lcd?.setCursor(line: 1, pos: 0)
        device.lcd?.displayString("08/22 - 08/24")

        sleep_ms(2000)
        device.lcd?.clear()
        device.lcd?.displayString("Hello World! from Embedded Swift")
        device.redLed?.isOn = true
        sleep_ms(1000)
        device.greenLed?.isOn = true
        sleep_ms(1000)
        device.blueLed?.isOn = true
        sleep_ms(2000)

        device.lcd?.clear()
        device.allOn = false
        device.lcd?.displayStringWithStreaming("Thank you for Listening!!")
        for _ in 0 ..< 5 {
            device.allOn.toggle()
            sleep_ms(1000)
        }

        sleep_ms(2000)
    }
}
