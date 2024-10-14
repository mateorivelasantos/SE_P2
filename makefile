# Toolchain and flags
CC = arm-none-eabi-gcc
CFLAGS = -I./includes -I./drivers -O0 -g3 -Wall -mthumb -mcpu=cortex-m0plus -DCPU_MKL46Z256VLL4
LDFLAGS =  --specs=nano.specs -Wl,--gc-sections,-Map,main.map,-Tlink.ld

# OpenOCD configuration
OPENOCD = openocd
OPENOCD_CFG = openocd.cfg
OPENOCD_TARGET = target_name

# Source files for hello_world
SRCS_HELLO = hello_world.c startup.c drivers/board.c drivers/clock_config.c \
drivers/fsl_clock.c drivers/fsl_gpio.c drivers/fsl_common.c drivers/pin_mux.c \
drivers/system_MKL46Z4.c drivers/fsl_assert.c drivers/fsl_debug_console.c \
drivers/fsl_smc.c drivers/fsl_io.c drivers/fsl_uart.c drivers/fsl_str.c \
drivers/fsl_log.c drivers/fsl_ftfx_cache.c drivers/fsl_lpsci.c

# Source files for led_blinky
SRCS_LED = led_blinky.c startup.c drivers/board.c drivers/clock_config.c \
drivers/fsl_clock.c drivers/fsl_gpio.c drivers/fsl_common.c drivers/pin_mux.c \
drivers/system_MKL46Z4.c drivers/fsl_debug_console.c drivers/fsl_smc.c \
drivers/fsl_log.c drivers/fsl_io.c drivers/fsl_lpsci.c drivers/fsl_uart.c \
drivers/fsl_str.c drivers/fsl_ftfx_cache.c drivers/fsl_ftfx_controller.c \
drivers/fsl_ftfx_flash.c drivers/fsl_assert.c drivers/pin_mux.c

# Object files
OBJS_LED = $(SRCS_LED:.c=.o)
OBJS_HELLO = $(SRCS_HELLO:.c=.o)

# Binaries
BIN_LED = led_blinky.elf
BIN_HELLO = hello_world.elf

# Default target
all:  $(BIN_HELLO) $(BIN_LED)

# Rules for led_blinky
$(BIN_LED): $(OBJS_LED)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

# Rules for hello_world
$(BIN_HELLO): $(OBJS_HELLO)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

# Flash led_blinky
flash_led: $(BIN_LED)
	$(OPENOCD) -f $(OPENOCD_CFG) -c "program $(BIN_LED) verify reset exit"

# Flash hello_world
flash_hello: $(BIN_HELLO)
	$(OPENOCD) -f $(OPENOCD_CFG) -c "program $(BIN_HELLO) verify reset exit"

# Clean up the build
clean:
	rm -f $(OBJS_LED) $(OBJS_HELLO) $(BIN_LED) $(BIN_HELLO)

# Implicit rules for object files
%.o: %.c
	$(CC) $(CFLAGS)  -c -o $@ $<
