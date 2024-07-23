
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
            button: Button(pin: UInt32(13)),
            lcd: LCD()
        )

        while true {
            // demoDefaultLED(&device)
            // demoLEDs(&device)
            // demoLEDsWithButton(&device)
            demoFinal(&device)
        }
    }

    static func demoDefaultLED(_ device: inout PicoDevice) {
        device.defaultLED.isOn.toggle()
        sleep_ms(1000)
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
        device.lcd?.displayString("Hello World! from Swift Embedded")
        device.redLed?.isOn = true
        sleep_ms(1000)
        device.greenLed?.isOn = true
        sleep_ms(1000)
        device.blueLed?.isOn = true
        sleep_ms(2000)

        device.lcd?.clear()
        device.blueLed?.isOn = false
        device.lcd?.displayStringWithStreaming("Thank you for Listening!!")
        device.allOn = true
        sleep_ms(1000)
        device.allOn = false
        sleep_ms(1000)
        device.allOn = true
        sleep_ms(1000)
        device.allOn = false
        sleep_ms(1000)
        device.allOn = true
        sleep_ms(2000)
    }
}
