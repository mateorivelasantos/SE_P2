# Toolchain and flags
CC = arm-none-eabi-gcc
CFLAGS = -mcpu=cortex-m0plus -mthumb -O2 -Wall -g -I./includes -I./drivers -DCPU_MKL46Z256VLL4
LDFLAGS = -T link.ld --specs=nano.specs -nostartfiles -Wl,--gc-sections

# OpenOCD configuration
OPENOCD = openocd
OPENOCD_CFG = openocd.cfg

# Source files
SRCS_LED = led_blinky.c startup.c drivers/board.c drivers/clock_config.c drivers/fsl_clock.c drivers/fsl_gpio.c drivers/fsl_common.c drivers/pin_mux.c drivers/system_MKL46Z4.c

# Object files
OBJS_LED = $(SRCS_LED:.c=.o)

# Binaries
BIN_LED = led_blinky.elf

# Default target
all: $(BIN_LED)

# Rules for led_blinky
$(BIN_LED): $(OBJS_LED)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Flash the board using OpenOCD
flash: $(BIN_LED)
	$(OPENOCD) -f $(OPENOCD_CFG) -c "program $(BIN_LED) verify reset exit"

# Clean up the build
clean:
	rm -f $(OBJS_LED) $(BIN_LED)

# Implicit rules for object files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<
