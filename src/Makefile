obj-m += sysmon.o

# Enable debug prints if DEBUG=1 is passed
ifdef DEBUG
    ccflags-y += -DDEBUG
endif

# Get the kernel build directory
KERNEL_DIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	@echo "Building kernel module with $(if $(DEBUG),debug,release) configuration..."
	@echo "Kernel build directory: $(KERNEL_DIR)"
	@echo "Current directory: $(PWD)"
	@make -C $(KERNEL_DIR) M=$(PWD) modules
	@if [ ! -f "sysmon.ko" ]; then \
		echo "Error: Module build failed - sysmon.ko not created"; \
		exit 1; \
	fi
	@echo "Module built successfully: sysmon.ko"

clean:
	@echo "Cleaning build artifacts..."
	@make -C $(KERNEL_DIR) M=$(PWD) clean
	@rm -f *.ko
	@rm -f *.mod.c
	@rm -f *.o
	@rm -f *.symvers
	@rm -f *.order
