# LeoRM Makefile
#
# This Makefile is intentionally small and Leopard-friendly.
# It is a smoke-test build path, not a replacement for the Xcode project.

CC ?= gcc-4.0
SDKROOT ?= /Developer/SDKs/MacOSX10.5.sdk
ARCH ?= ppc

BUILD_DIR = Build
SOURCES = Sources/LRMError.m Sources/LRMDatabase.m
OBJECTS = $(BUILD_DIR)/LRMError.o $(BUILD_DIR)/LRMDatabase.o

CFLAGS = -isysroot $(SDKROOT) -mmacosx-version-min=10.5 -arch $(ARCH) -Wall -Wextra
OBJCFLAGS = $(CFLAGS)
LDFLAGS = -isysroot $(SDKROOT) -mmacosx-version-min=10.5 -arch $(ARCH)
LIBS = -framework Foundation -lsqlite3

.PHONY: all clean smoke

all: $(BUILD_DIR)/libLeoRM.a $(BUILD_DIR)/lrm-smoke

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/LRMError.o: Sources/LRMError.m Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMError.m -o $@

$(BUILD_DIR)/LRMDatabase.o: Sources/LRMDatabase.m Sources/LRMDatabase.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMDatabase.m -o $@

$(BUILD_DIR)/libLeoRM.a: $(OBJECTS)
	libtool -static -o $@ $(OBJECTS)

$(BUILD_DIR)/lrm-smoke: Tests/smoke_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/smoke_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

smoke: $(BUILD_DIR)/lrm-smoke
	$(BUILD_DIR)/lrm-smoke

clean:
	rm -rf $(BUILD_DIR)
