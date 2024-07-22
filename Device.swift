
struct PicoDevice {
    var defaultLED: LED
    var redLed: LED
    var blueLed: LED
    var greenLed: LED

    var button: Button

    var lcd: LCD?

    var allOn: Bool = false {
        didSet {
            defaultLED.isOn = allOn
            redLed.isOn = allOn
            blueLed.isOn = allOn
            greenLed.isOn = allOn
        }
    }

    init(defaultLED: LED, redLed: LED, blueLed: LED, greenLed: LED, button: Button, lcd: LCD?) {
        self.defaultLED = defaultLED
        self.redLed = redLed
        self.blueLed = blueLed
        self.greenLed = greenLed
        self.button = button
        self.lcd = lcd
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

struct LCD {
    let addr: UInt8 = 0x27
    var i2c0: UnsafeMutablePointer<i2c_inst_t> = get_pointer()

    init() {
        i2c_init(i2c0, 100 * 1000)
        gpio_set_function(UInt32(4), GPIO_FUNC_I2C) // SDA
        gpio_set_function(UInt32(5), GPIO_FUNC_I2C) // SCL
        gpio_pull_up(4) // SDA
        gpio_pull_up(5) // SCL
        sleep_ms(40)
        setup()
    }

    func clear() {
        send(Command.clearDisplay, mode: .command)
        setCursor(line: 0, pos: 0)
    }

    func setCursor(line: UInt8, pos: UInt8) {
        let value = (line == 0) ? 0x80 + pos : 0xC0 + pos
        send(value, mode: .command)
    }

    func displayString(_ value: StaticString) {
        let maxCharPerLine = 16

        value.withUTF8Buffer { b in
            var i = 0
            var l = 0
            for ch in b {
                i += 1
                if i > maxCharPerLine, l == 0 {
                    setCursor(line: 1, pos: 0)
                    l += 1
                }
                send(ch, mode: .character)
            }
        }
    }

    private func setup() {
        send(0x03, mode: .command)
        send(0x03, mode: .command)
        send(0x03, mode: .command)
        send(0x02, mode: .command)

        send(Command.entryModeSet | EntryMode.left, mode: .command)
        send(Command.functionSet | FunctionSet.LCD_2LINE, mode: .command)
        send(Command.displayControl | CursorContol.displayON, mode: .command)
        send(Command.returnHome, mode: .command)
        clear()
    }

    private func toggleEnable(value: UInt8) {
        sleep_us(600)
        write(value: UInt8(value | 0x04))
        sleep_us(600)
        write(value: UInt8(value & ~0x04))
        sleep_us(600)
    }

    private func write(value: UInt8) {
        var v = value
        _ = withUnsafeMutablePointer(to: &v) { p in
            _ = i2c_write_blocking(i2c0, addr, p, 1, false)
        }
    }

    private func send(_ bytes: UInt8, mode: Mode) {
        let high = (mode.rawValue) | (bytes & 0xF0) | Backlight.on
        let low = (mode.rawValue) | ((bytes << 4) & 0xF0) | Backlight.on
        write(value: high)

        toggleEnable(value: high)
        write(value: low)
        toggleEnable(value: low)
    }


    enum Mode: UInt8 {
        case command = 0
        case character = 1
    }

    enum Command {
        static let clearDisplay: UInt8 = 0x01
        static let returnHome: UInt8 = 0x02
        static let entryModeSet: UInt8 = 0x04
        static let displayControl: UInt8 = 0x08
        static let cursorShift: UInt8 = 0x10
        static let functionSet: UInt8 = 0x20
        static let setCGRamAddr: UInt8 = 0x40
        static let setDDRamAddr: UInt8 = 0x80
    }

    enum EntryMode {
        static let shiftIncrement: UInt8 = 0x01
        static let left: UInt8 = 0x02
    }

    enum CursorContol {
        static let blinkON: UInt8 = 0x01
        static let cursorON: UInt8 = 0x02
        static let displayON: UInt8 = 0x04
    }

    enum CursorShift {
        static let moveRight: UInt8 = 0x04
        static let displayMove: UInt8 = 0x08
    }

    enum FunctionSet {
        static let LCD_5x10DOTS: UInt8 = 0x04
        static let LCD_2LINE: UInt8 = 0x08
        static let LCD_8BITMODE: UInt8 = 0x10
    }

    enum Backlight {
        static let on: UInt8 = 0x08
        static let off: UInt8 = 0x00
    }

    enum Flag {
        static let enable: UInt8 = 0x04
    }
}
