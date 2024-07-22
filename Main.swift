@main
struct Main {
    // PICO_DEFAULT_LED_PIN: GP25
    static func main() {
        stdio_init_all()
        var device = PicoDevice(
            defaultLED: LED(pin: UInt32(PICO_DEFAULT_LED_PIN)),
            redLed: LED(pin: UInt32(22)),
            blueLed: LED(pin: UInt32(16)),
            greenLed: LED(pin: UInt32(18)),
            button: Button(pin: UInt32(13)),
            lcd: LCD()
        )

        while true {
            // if device.button.isPressed {
            //     device.allOn.toggle()
            //     while device.button.isPressed {
            //         sleep_ms(100)
            //     }
            // }
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
            sleep_ms(1000)
            device.lcd?.clear()
            device.lcd?.displayString("Hello World! from Swift Embedded")
            device.redLed.isOn = true
            sleep_ms(1000)
            device.greenLed.isOn = true
            sleep_ms(1000)
            device.blueLed.isOn = true
            sleep_ms(1000)
            device.lcd?.clear()
            device.lcd?.displayString("Thank you for Listening!!")
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
}
