
struct PicoDevice {
    var defaultLED: LED
    var redLed: LED
    var blueLed: LED
    var greenLed: LED

    var button: Button

    var allOn: Bool = false {
        didSet {
            defaultLED.isOn = allOn
            redLed.isOn = allOn
            blueLed.isOn = allOn
            greenLed.isOn = allOn
        }
    }

    init(defaultLED: LED, redLed: LED, blueLed: LED, greenLed: LED, button: Button) {
        self.defaultLED = defaultLED
        self.redLed = redLed
        self.blueLed = blueLed
        self.greenLed = greenLed
        self.button = button
        stdio_init_all()
    }
}

struct LED {
    private let pin: UInt32

    init(pin: UInt32) {
        self.pin = pin
        gpio_init(pin)
        gpio_set_dir(pin, true)
    }

    var isOn: Bool = false {
        didSet {
            gpio_put(pin, isOn)
        }
    }
}

struct Button {
    let pin: UInt32

    // pressed -> false (LOW)
    var isPressed: Bool {
        !gpio_get(pin)
    }

    init(pin: UInt32) {
        self.pin = pin
        gpio_init(pin)
        // input
        gpio_set_dir(pin, false)
    }
}

@main
struct Main {
    // PICO_DEFAULT_LED_PIN: GP25
    static func main() {
        var device = PicoDevice(
            defaultLED: LED(pin: UInt32(PICO_DEFAULT_LED_PIN)),
            redLed: LED(pin: UInt32(22)),
            blueLed: LED(pin: UInt32(16)),
            greenLed: LED(pin: UInt32(18)),
            button: Button(pin: UInt32(13))
        )

        var v = i2c_inst_t()
        withUnsafeMutablePointer(to: &v) {
            i2c_init($0, 100 * 1000)
        }
        gpio_set_function(UInt32(4), GPIO_FUNC_I2C)
        gpio_set_function(UInt32(5), GPIO_FUNC_I2C)
        gpio_pull_up(4)
        gpio_pull_up(5)
        lcd_send_byte
        // bi_decl(bi_2pins_with_func(PICO_DEFAULT_I2C_SDA_PIN, PICO_DEFAULT_I2C_SCL_PIN, GPIO_FUNC_I2C))
        while true {
            if device.button.isPressed {
                device.allOn.toggle()
                while device.button.isPressed {
                    sleep_ms(100)
                }
            }
            print(i2c_default)
            // print(PICO_DEFAULT_I2C_SDA_PIN)
            // print(PICO_DEFAULT_I2C_SCL_PIN)

            sleep_ms(100)
        }
    }
}
