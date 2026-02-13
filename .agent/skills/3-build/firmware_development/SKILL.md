---
name: firmware_development
description: Embedded systems and firmware programming for microcontrollers and IoT devices
---

# Firmware Development Skill

**Purpose**: Guide the development of robust, power-efficient firmware for microcontrollers and embedded systems, from bare-metal programming to RTOS-based applications.

## :dart: TRIGGER COMMANDS

```text
"build firmware"
"embedded development"
"program microcontroller"
"Using firmware_development skill: [target platform] [application]"
```

## :gear: MICROCONTROLLER SELECTION

Choose the right MCU for your project requirements:

| MCU Family | Core | Wireless | Best For | Dev Framework | Price Range |
|---|---|---|---|---|---|
| ESP32 | Xtensa/RISC-V | WiFi + BLE | IoT, connected devices | Arduino / ESP-IDF | $2-8 |
| STM32 | ARM Cortex-M | Optional (STM32WB) | Professional/industrial | STM32CubeIDE / Zephyr | $2-15 |
| Arduino (AVR) | ATmega | None (shields) | Education, prototyping | Arduino IDE | $3-10 |
| Raspberry Pi Pico | RP2040 (Dual M0+) | WiFi on Pico W | General purpose, PIO | MicroPython / C SDK | $4-6 |
| nRF52 | ARM Cortex-M4F | BLE 5.x specialist | Wearables, BLE sensors | Zephyr / nRF Connect | $3-12 |
| ATSAMD21 | ARM Cortex-M0+ | None | USB devices, low power | Arduino / ASF4 | $2-6 |

> [!TIP]
> For most IoT projects, start with ESP32. For professional/certified products, go STM32. For BLE-only wearables, nRF52 is unbeatable on power consumption.

## :hammer_and_wrench: DEVELOPMENT ENVIRONMENTS

| Tool | Platforms | Strengths | Best For |
|---|---|---|---|
| **PlatformIO** (recommended) | ESP32, STM32, AVR, RP2040+ | Multi-board, library manager, CI-friendly | All projects |
| Arduino IDE | All Arduino-compatible | Simple, huge community | Prototyping |
| STM32CubeIDE | STM32 only | Full HAL/LL code gen, debugging | STM32 production |
| ESP-IDF | ESP32 only | Full ESP32 features, menuconfig | Advanced ESP32 |
| Zephyr RTOS | nRF52, STM32, ESP32+ | Portable RTOS, device tree | Multi-platform RTOS |
| Keil MDK | ARM Cortex-M | Industry standard, CMSIS | Certified/safety-critical |

## :file_folder: FIRMWARE PROJECT STRUCTURE

```text
firmware-project/
├── src/
│   ├── main.c                # Entry point, setup, main loop / RTOS start
│   ├── drivers/
│   │   ├── bme280.c          # Sensor driver
│   │   ├── display_ssd1306.c # OLED display driver
│   │   └── motor.c           # Actuator driver
│   ├── hal/
│   │   ├── hal_gpio.c        # GPIO abstraction
│   │   ├── hal_i2c.c         # I2C abstraction
│   │   ├── hal_spi.c         # SPI abstraction
│   │   └── hal_uart.c        # UART abstraction
│   ├── app/
│   │   ├── sensor_task.c     # Sensor reading task
│   │   ├── comm_task.c       # Communication task
│   │   └── control_task.c    # Control logic task
│   └── utils/
│       ├── ring_buffer.c     # Circular buffer utility
│       └── crc.c             # CRC calculation
├── include/
│   ├── drivers/
│   ├── hal/
│   ├── app/
│   └── config.h              # Project configuration defines
├── lib/                       # Third-party libraries
├── test/                      # Unit tests (run on host)
├── platformio.ini             # PlatformIO configuration
└── README.md
```

## :bricks: HARDWARE ABSTRACTION LAYER (HAL)

A HAL decouples your application logic from hardware specifics, enabling portability and testability.

```c
// include/hal/hal_gpio.h
#ifndef HAL_GPIO_H
#define HAL_GPIO_H

#include <stdint.h>
#include <stdbool.h>

typedef enum {
    GPIO_MODE_INPUT,
    GPIO_MODE_OUTPUT,
    GPIO_MODE_INPUT_PULLUP,
    GPIO_MODE_INPUT_PULLDOWN
} gpio_mode_t;

typedef enum {
    GPIO_EDGE_RISING,
    GPIO_EDGE_FALLING,
    GPIO_EDGE_BOTH
} gpio_edge_t;

typedef void (*gpio_isr_callback_t)(uint8_t pin);

void hal_gpio_init(uint8_t pin, gpio_mode_t mode);
void hal_gpio_write(uint8_t pin, bool state);
bool hal_gpio_read(uint8_t pin);
void hal_gpio_toggle(uint8_t pin);
void hal_gpio_attach_interrupt(uint8_t pin, gpio_edge_t edge, gpio_isr_callback_t cb);

#endif
```

> [!WARNING]
> Never put business logic inside your HAL. The HAL should only abstract hardware register access. Keep it thin and testable.

## :zap: RTOS FUNDAMENTALS (FreeRTOS)

### When to Use RTOS vs Bare-Metal

| Criteria | Bare-Metal (super loop) | RTOS |
|---|---|---|
| Task count | 1-3 simple tasks | 4+ concurrent tasks |
| Timing requirements | Soft deadlines | Hard real-time deadlines |
| Complexity | Low-medium | Medium-high |
| RAM overhead | None | ~2-8 KB for kernel |
| Debugging | Simpler | Requires RTOS-aware tools |
| Power management | Custom sleep logic | Idle task + tickless mode |

### FreeRTOS Task Creation

```c
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "freertos/semphr.h"

// Shared queue for sensor data
static QueueHandle_t sensor_queue;
static SemaphoreHandle_t i2c_mutex;

// Sensor reading task - runs every 1 second
void sensor_task(void *pvParameters) {
    sensor_data_t data;
    TickType_t last_wake = xTaskGetTickCount();

    for (;;) {
        // Take the I2C mutex before accessing the bus
        if (xSemaphoreTake(i2c_mutex, pdMS_TO_TICKS(100)) == pdTRUE) {
            data.temperature = bme280_read_temperature();
            data.humidity = bme280_read_humidity();
            data.timestamp = xTaskGetTickCount();
            xSemaphoreGive(i2c_mutex);

            // Send to processing queue (block up to 10ms if full)
            xQueueSend(sensor_queue, &data, pdMS_TO_TICKS(10));
        }

        // Precise 1-second interval (drift-free unlike vTaskDelay)
        vTaskDelayUntil(&last_wake, pdMS_TO_TICKS(1000));
    }
}

// Communication task - sends data when available
void comm_task(void *pvParameters) {
    sensor_data_t received;

    for (;;) {
        // Block until data arrives in queue
        if (xQueueReceive(sensor_queue, &received, portMAX_DELAY) == pdTRUE) {
            mqtt_publish_sensor_data(&received);
        }
    }
}

void app_main(void) {
    // Create synchronization primitives
    sensor_queue = xQueueCreate(10, sizeof(sensor_data_t));
    i2c_mutex = xSemaphoreCreateMutex();

    // Create tasks with priorities (higher number = higher priority)
    xTaskCreate(sensor_task, "sensor", 4096, NULL, 5, NULL);
    xTaskCreate(comm_task,   "comm",   8192, NULL, 3, NULL);

    // FreeRTOS scheduler starts automatically on ESP32 after app_main returns
}
```

> [!TIP]
> Task priority guidelines: ISR-like urgent tasks (7-9), sensor reading (5-6), communication (3-4), logging/display (1-2), idle housekeeping (0).

## :satellite: SENSOR INTEGRATION PATTERNS

### I2C Sensor Read (BME280 Temperature/Humidity/Pressure)

```c
#include "hal/hal_i2c.h"

#define BME280_ADDR       0x76
#define BME280_REG_ID     0xD0
#define BME280_REG_CTRL   0xF4
#define BME280_REG_DATA   0xF7

typedef struct {
    float temperature;
    float humidity;
    float pressure;
} bme280_data_t;

bool bme280_init(void) {
    uint8_t chip_id;
    hal_i2c_read_reg(BME280_ADDR, BME280_REG_ID, &chip_id, 1);
    if (chip_id != 0x60) return false; // Not a BME280

    // Configure: temp oversampling x1, pressure x1, normal mode
    uint8_t ctrl = 0x27; // osrs_t=001, osrs_p=001, mode=11
    hal_i2c_write_reg(BME280_ADDR, BME280_REG_CTRL, &ctrl, 1);
    return true;
}

bme280_data_t bme280_read(void) {
    uint8_t raw[8];
    hal_i2c_read_reg(BME280_ADDR, BME280_REG_DATA, raw, 8);

    bme280_data_t data;
    // Apply compensation formulas (simplified - see BME280 datasheet)
    int32_t adc_T = (raw[3] << 12) | (raw[4] << 4) | (raw[5] >> 4);
    data.temperature = compensate_temperature(adc_T);
    data.pressure = compensate_pressure(raw);
    data.humidity = compensate_humidity(raw);
    return data;
}
```

### GPIO Interrupt Handler

```c
// CRITICAL: ISR must be short - set flag and return
static volatile bool button_pressed = false; // volatile required!

void IRAM_ATTR button_isr_handler(void *arg) {
    button_pressed = true;
    // For RTOS: use xTaskNotifyFromISR or xQueueSendFromISR
    // NEVER call printf, malloc, or blocking functions in ISR
}

void button_init(void) {
    gpio_config_t io_conf = {
        .pin_bit_mask = (1ULL << GPIO_NUM_0),
        .mode = GPIO_MODE_INPUT,
        .pull_up_en = GPIO_PULLUP_ENABLE,
        .intr_type = GPIO_INTR_NEGEDGE // Falling edge (button press)
    };
    gpio_config(&io_conf);
    gpio_install_isr_service(0);
    gpio_isr_handler_add(GPIO_NUM_0, button_isr_handler, NULL);
}
```

### Communication Protocols Reference

| Protocol | Speed | Wires | Addressing | Distance | Best For |
|---|---|---|---|---|---|
| UART | 9600-921600 baud | 2 (TX/RX) | None (point-to-point) | ~15m | Debug console, GPS, BLE modules |
| SPI | 1-80 MHz | 4 (MOSI/MISO/CLK/CS) | CS pin select | ~1m | Displays, SD cards, fast sensors |
| I2C | 100-400 KHz (std) | 2 (SDA/SCL) | 7-bit address | ~1m | Sensors, EEPROMs, RTCs |
| CAN | 1 Mbps | 2 (differential) | Message ID | ~500m | Automotive, industrial |
| 1-Wire | 16 Kbps | 1 (data + GND) | 64-bit ROM code | ~100m | Temperature sensors (DS18B20) |

## :battery: POWER MANAGEMENT

### Sleep Mode Comparison (ESP32)

| Mode | Current Draw | Wake Sources | Wake Time | RAM Retained |
|---|---|---|---|---|
| Active (WiFi) | 80-260 mA | N/A | N/A | Yes |
| Modem Sleep | 20-30 mA | Auto (WiFi interval) | Instant | Yes |
| Light Sleep | 0.8 mA | Timer, GPIO, touchpad, UART | ~1 ms | Yes |
| Deep Sleep | 10 uA | Timer, ext0/ext1 GPIO, touchpad | ~200 ms | RTC memory only |
| Hibernation | 5 uA | ext0 GPIO only | ~200 ms | No |

### Deep Sleep with Timer Wake

```c
#include "esp_sleep.h"
#include "driver/rtc_io.h"

// Data preserved across deep sleep (stored in RTC memory)
RTC_DATA_ATTR int boot_count = 0;

void enter_deep_sleep(uint64_t sleep_time_us) {
    printf("Boot count: %d\n", ++boot_count);

    // Configure wake source: timer
    esp_sleep_enable_timer_wakeup(sleep_time_us);

    // Optional: also wake on GPIO (e.g., button press)
    esp_sleep_enable_ext0_wakeup(GPIO_NUM_33, 0); // Wake on LOW

    // Isolate unused GPIOs to save power
    esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_PERIPH, ESP_PD_OPTION_OFF);

    printf("Entering deep sleep for %llu seconds...\n", sleep_time_us / 1000000);
    esp_deep_sleep_start();
    // Code below here never executes - device resets on wake
}

// Power budget calculation example:
// Active (reading sensor + WiFi transmit): 150mA for 2 seconds = 83 uAh
// Deep sleep: 10uA for 298 seconds = 828 uAh
// Total per cycle (300s): 911 uAh
// 2000mAh battery: 2000000 / 911 = 2,196 cycles = 7.6 days
```

## :brain: MEMORY MANAGEMENT

| Aspect | Recommendation | Rationale |
|---|---|---|
| Allocation | Prefer static (compile-time) | No fragmentation, deterministic |
| Stack size | Profile with `uxTaskGetStackHighWaterMark()` | Overflow = hard crash, no warning |
| Heap | Use memory pools for fixed-size allocs | Avoids fragmentation over time |
| Strings | Fixed-size buffers, never `sprintf` unbounded | Buffer overflow is #1 embedded bug |
| Flash layout | Code + read-only data in flash, variables in RAM | Flash is 4-16MB, RAM is 320-520KB |

> [!WARNING]
> On a microcontroller with 320KB RAM, a single `malloc(1024)` in a loop that runs 300 times will exhaust memory. Always use static buffers or memory pools for repeated allocations.

## :rocket: BOOTLOADER AND OTA UPDATES

### OTA-Capable Partition Layout (ESP32)

```text
# Partition Table (partitions.csv)
# Name,   Type, SubType, Offset,  Size,    Flags
nvs,      data, nvs,     0x9000,  0x5000,
otadata,  data, ota,     0xe000,  0x2000,
app0,     app,  ota_0,   0x10000, 0x1E0000,  # ~1.9MB slot A
app1,     app,  ota_1,   0x1F0000,0x1E0000,  # ~1.9MB slot B
spiffs,   data, spiffs,  0x3D0000,0x30000,   # File storage
```

A/B partitioning ensures safe OTA: write new firmware to inactive slot, verify checksum, switch boot partition, reboot. If new firmware fails, watchdog triggers rollback to previous slot.

## :mag: DEBUGGING TECHNIQUES

| Method | Cost | Setup Difficulty | Best For |
|---|---|---|---|
| `printf` over UART | $0 (USB cable) | Trivial | Quick logging, state inspection |
| Logic Analyzer | $10-50 | Low | Protocol debugging (SPI, I2C, UART) |
| JTAG/SWD Debugger | $15-200 | Medium | Breakpoints, memory inspection, step-through |
| Oscilloscope | $50-500 | Medium | Timing issues, analog signals, power |
| GDB Remote | $0 (with JTAG) | Medium | Full source-level debugging |
| Segger SystemView | $0 (with J-Link) | Medium | RTOS task visualization, timing |

## :shield: WATCHDOG TIMERS

```c
#include "esp_task_wdt.h"

#define WDT_TIMEOUT_SEC 10

void watchdog_init(void) {
    // Configure hardware watchdog - resets MCU if not fed within timeout
    esp_task_wdt_config_t wdt_config = {
        .timeout_ms = WDT_TIMEOUT_SEC * 1000,
        .trigger_panic = true  // true = reset on timeout
    };
    esp_task_wdt_init(&wdt_config);
    esp_task_wdt_add(NULL); // Subscribe current task
}

void main_loop(void) {
    for (;;) {
        do_sensor_reading();
        do_communication();
        esp_task_wdt_reset(); // Feed the watchdog

        vTaskDelay(pdMS_TO_TICKS(100));
    }
}
```

> [!TIP]
> A watchdog timer is your safety net for production firmware. If your code hangs (infinite loop, deadlock, hardware fault), the watchdog resets the MCU and your bootloader can log the crash reason.

## :test_tube: TESTING EMBEDDED CODE

### Unit Testing on Host with Unity

```c
// test/test_ring_buffer.c
#include "unity.h"
#include "ring_buffer.h"

void setUp(void) {}
void tearDown(void) {}

void test_buffer_write_read(void) {
    ring_buffer_t buf;
    ring_buffer_init(&buf, 64);

    uint8_t data[] = {0xDE, 0xAD, 0xBE, 0xEF};
    TEST_ASSERT_EQUAL(4, ring_buffer_write(&buf, data, 4));

    uint8_t out[4];
    TEST_ASSERT_EQUAL(4, ring_buffer_read(&buf, out, 4));
    TEST_ASSERT_EQUAL_MEMORY(data, out, 4);
}

void test_buffer_overflow(void) {
    ring_buffer_t buf;
    ring_buffer_init(&buf, 4);

    uint8_t data[8] = {0};
    TEST_ASSERT_EQUAL(4, ring_buffer_write(&buf, data, 8)); // Only 4 fit
    TEST_ASSERT_TRUE(ring_buffer_is_full(&buf));
}
```

### PlatformIO Configuration

```ini
; platformio.ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
lib_deps =
    adafruit/Adafruit BME280 Library@^2.2
    knolleary/PubSubClient@^2.8
build_flags =
    -DCORE_DEBUG_LEVEL=3
    -DBOARD_HAS_PSRAM
upload_speed = 921600

[env:native]
platform = native
test_framework = unity
build_flags = -DUNIT_TEST
; Runs tests on host machine (no hardware needed)

[env:stm32]
platform = ststm32
board = nucleo_f446re
framework = stm32cube
debug_tool = stlink
```

## :warning: COMMON MISTAKES

| Mistake | Consequence | Fix |
|---|---|---|
| Blocking code in ISR | Missed interrupts, watchdog reset | Set flag in ISR, process in task |
| Missing `volatile` on shared vars | Compiler optimizes away reads, stale data | Always `volatile` for ISR-shared variables |
| Unchecked stack overflow | Silent memory corruption, random crashes | Profile with `uxTaskGetStackHighWaterMark()` |
| `malloc` in tight loops | Heap fragmentation, eventual OOM | Use static buffers or memory pools |
| Busy-waiting (`while(!flag)`) | 100% CPU, blocks lower-priority tasks | Use RTOS notifications or interrupts |
| No debouncing on buttons | Multiple triggers per press | Hardware RC filter or software debounce (50ms) |
| Ignoring ISR priority levels | Priority inversion, missed critical ISRs | Map priorities: highest for safety, lowest for logging |
| Not handling I2C NACK | Bus lockup, hung communication | Always check return codes, implement bus recovery |

## :white_check_mark: EXIT CHECKLIST

- [ ] HAL abstractions in place for all peripheral access (GPIO, I2C, SPI, UART)
- [ ] RTOS tasks created with appropriate stack sizes and priorities
- [ ] Sensors reading correctly with validated data ranges
- [ ] Power consumption measured and within battery budget
- [ ] Watchdog timer configured with appropriate timeout
- [ ] OTA update mechanism tested (write, verify, boot, rollback)
- [ ] All shared variables between ISRs and tasks use `volatile` and proper synchronization
- [ ] Unit tests pass on host (native) environment
- [ ] Communication protocols verified with logic analyzer
- [ ] Error handling covers hardware failures (sensor disconnect, bus lockup)
- [ ] Memory usage profiled (stack high watermarks, heap free space)
- [ ] Production build flags set (no debug logging, optimized)

*Skill Version: 1.0 | Created: February 2026*
