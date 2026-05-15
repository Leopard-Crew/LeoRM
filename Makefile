# LeoRM Makefile
#
# This Makefile is intentionally small and Leopard-friendly.
# It is a smoke-test build path, not a replacement for the Xcode project.

CC ?= gcc-4.0
SDKROOT ?= /Developer/SDKs/MacOSX10.5.sdk
ARCH ?= ppc

BUILD_DIR = Build
SOURCES = Sources/LRMError.m Sources/LRMDatabase.m Sources/LRMStatement.m Sources/LRMResultSet.m Sources/LRMRow.m Sources/LRMTransaction.m
OBJECTS = $(BUILD_DIR)/LRMError.o $(BUILD_DIR)/LRMDatabase.o $(BUILD_DIR)/LRMStatement.o $(BUILD_DIR)/LRMResultSet.o $(BUILD_DIR)/LRMRow.o $(BUILD_DIR)/LRMTransaction.o

CFLAGS = -isysroot $(SDKROOT) -mmacosx-version-min=10.5 -arch $(ARCH) -Wall -Wextra
OBJCFLAGS = $(CFLAGS)
LDFLAGS = -isysroot $(SDKROOT) -mmacosx-version-min=10.5 -arch $(ARCH)
LIBS = -framework Foundation -lsqlite3

.PHONY: all clean smoke

all: $(BUILD_DIR)/libLeoRM.a $(BUILD_DIR)/lrm-smoke $(BUILD_DIR)/lrm-error-smoke $(BUILD_DIR)/lrm-statement-smoke $(BUILD_DIR)/lrm-query-smoke $(BUILD_DIR)/lrm-transaction-smoke $(BUILD_DIR)/lrm-metadata-smoke

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/LRMError.o: Sources/LRMError.m Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMError.m -o $@

$(BUILD_DIR)/LRMDatabase.o: Sources/LRMDatabase.m Sources/LRMDatabase.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMDatabase.m -o $@

$(BUILD_DIR)/LRMStatement.o: Sources/LRMStatement.m Sources/LRMStatement.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMStatement.m -o $@

$(BUILD_DIR)/LRMResultSet.o: Sources/LRMResultSet.m Sources/LRMResultSet.h Sources/LRMRow.h Sources/LRMStatement.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMResultSet.m -o $@

$(BUILD_DIR)/LRMRow.o: Sources/LRMRow.m Sources/LRMRow.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMRow.m -o $@

$(BUILD_DIR)/LRMTransaction.o: Sources/LRMTransaction.m Sources/LRMTransaction.h Sources/LRMDatabase.h Sources/LRMStatement.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMTransaction.m -o $@

$(BUILD_DIR)/libLeoRM.a: $(OBJECTS)
	libtool -static -o $@ $(OBJECTS)

$(BUILD_DIR)/lrm-smoke: Tests/smoke_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/smoke_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-error-smoke: Tests/error_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/error_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-statement-smoke: Tests/statement_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/statement_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-query-smoke: Tests/query_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/query_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-transaction-smoke: Tests/transaction_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/transaction_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-metadata-smoke: Tests/metadata_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/metadata_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

smoke: $(BUILD_DIR)/lrm-smoke $(BUILD_DIR)/lrm-error-smoke $(BUILD_DIR)/lrm-statement-smoke $(BUILD_DIR)/lrm-query-smoke $(BUILD_DIR)/lrm-transaction-smoke $(BUILD_DIR)/lrm-metadata-smoke
	$(BUILD_DIR)/lrm-smoke
	$(BUILD_DIR)/lrm-error-smoke
	$(BUILD_DIR)/lrm-statement-smoke
	$(BUILD_DIR)/lrm-query-smoke
	$(BUILD_DIR)/lrm-transaction-smoke
	$(BUILD_DIR)/lrm-metadata-smoke

clean:
	rm -rf $(BUILD_DIR)
