.PHONY: all clean install remove debug test help

# Default target
all:
	@echo "Building kernel module..."
	@$(MAKE) -C src

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@$(MAKE) -C src clean
	@rm -f *.ko
	@rm -f *.mod.c
	@rm -f *.o
	@rm -f *.symvers
	@rm -f *.order

# Install the module
install: all
	@echo "Installing kernel module..."
	@if [ ! -f "src/sysmon.ko" ]; then \
		echo "Error: Kernel module not built. Run 'make all' first."; \
		exit 1; \
	fi
	@sudo insmod src/sysmon.ko || { echo "Error: Failed to load module"; exit 1; }
	@echo "Module installed successfully"
	@echo "You can view process information with: cat /proc/sysmon"
	@echo "Check debug messages with: dmesg | grep SysMon"

# Remove the module
remove:
	@echo "Removing kernel module..."
	@sudo rmmod sysmon || { echo "Error: Failed to unload module"; exit 1; }
	@echo "Module removed successfully"

# Enable debug mode
debug:
	@echo "Building with debug enabled..."
	@$(MAKE) -C src DEBUG=1

# Test the module
test: install
	@echo "Testing module functionality..."
	@echo "Checking if module is loaded..."
	@lsmod | grep sysmon || { echo "Error: Module not loaded"; exit 1; }
	@echo "Reading process information..."
	@cat /proc/sysmon || { echo "Error: Failed to read /proc/sysmon"; exit 1; }
	@echo "Checking debug messages..."
	@dmesg | grep SysMon
	@echo "Test completed successfully"

# Show help message
help:
	@echo "Available targets:"
	@echo "  all     - Build the kernel module (default)"
	@echo "  clean   - Remove all build artifacts"
	@echo "  install - Build and install the module"
	@echo "  remove  - Remove the module"
	@echo "  debug   - Build with debug enabled"
	@echo "  test    - Run basic functionality tests"
	@echo "  help    - Show this help message"
