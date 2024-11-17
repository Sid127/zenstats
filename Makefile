VERSION         := 0.2.0
TARGET          := $(shell uname -r)
DKMS_ROOT_PATH  := /usr/src/zenstats-$(VERSION)

KBUILD_CFLAGS   += -Wimplicit-fallthrough=3

KERNEL_MODULES	:= /lib/modules/$(TARGET)

ifneq ("","$(wildcard /usr/src/linux-headers-$(TARGET)/*)")
# Ubuntu
KERNEL_BUILD	:= /usr/src/linux-headers-$(TARGET)
else
ifneq ("","$(wildcard /usr/src/kernels/$(TARGET)/*)")
# Fedora
KERNEL_BUILD	:= /usr/src/kernels/$(TARGET)
else
KERNEL_BUILD	:= $(KERNEL_MODULES)/build
endif
endif

obj-m	:= $(patsubst %,%.o,zenstats)
obj-ko	:= $(patsubst %,%.ko,zenstats)

.PHONY: all modules clean dkms-install dkms-install-swapped dkms-uninstall

all: modules

modules:
	@$(MAKE) -C $(KERNEL_BUILD) M=$(CURDIR) modules

clean:
	@$(MAKE) -C $(KERNEL_BUILD) M=$(CURDIR) clean

dkms-install:
	dkms --version >> /dev/null
	mkdir -p $(DKMS_ROOT_PATH)
	cp $(CURDIR)/dkms.conf $(DKMS_ROOT_PATH)
	cp $(CURDIR)/Makefile $(DKMS_ROOT_PATH)
	cp $(CURDIR)/zenstats.c $(DKMS_ROOT_PATH)

	sed -e "s/@CFLGS@/${MCFLAGS}/" \
	    -e "s/@VERSION@/$(VERSION)/" \
	    -i $(DKMS_ROOT_PATH)/dkms.conf

	dkms add zenstats/$(VERSION)
	dkms build zenstats/$(VERSION)
	dkms install zenstats/$(VERSION)

dkms-uninstall:
	dkms remove zenstats/$(VERSION) --all
	rm -rf $(DKMS_ROOT_PATH)
