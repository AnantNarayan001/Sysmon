obj-m += sysmon.o

# Enable debug prints if DEBUG=1 is passed
ifdef DEBUG
    ccflags-y += -DDEBUG
endif

all:
	@echo "Building kernel module with $(if $(DEBUG),debug,release) configuration..."
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	@echo "Cleaning build artifacts..."
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f *.ko
	rm -f *.mod.c
	rm -f *.o
	rm -f *.symvers
	rm -f *.order
