# LeoRM Makefile
#
# This Makefile is intentionally small and Leopard-friendly.
# It is a smoke-test build path, not a replacement for the Xcode project.

CC ?= gcc-4.0
SDKROOT ?= /Developer/SDKs/MacOSX10.5.sdk
ARCH ?= ppc

BUILD_DIR = Build
SOURCES = Sources/LRMError.m Sources/LRMDatabase.m Sources/LRMStatement.m Sources/LRMResultSet.m Sources/LRMRow.m Sources/LRMTransaction.m Sources/LRMMigration.m Sources/LRMSchema.m Sources/LRMMigrationRunner.m Sources/LRMRepository.m
OBJECTS = $(BUILD_DIR)/LRMError.o $(BUILD_DIR)/LRMDatabase.o $(BUILD_DIR)/LRMStatement.o $(BUILD_DIR)/LRMResultSet.o $(BUILD_DIR)/LRMRow.o $(BUILD_DIR)/LRMTransaction.o $(BUILD_DIR)/LRMMigration.o $(BUILD_DIR)/LRMSchema.o $(BUILD_DIR)/LRMMigrationRunner.o $(BUILD_DIR)/LRMRepository.o

CFLAGS = -isysroot $(SDKROOT) -mmacosx-version-min=10.5 -arch $(ARCH) -Wall -Wextra
OBJCFLAGS = $(CFLAGS)
LDFLAGS = -isysroot $(SDKROOT) -mmacosx-version-min=10.5 -arch $(ARCH)
LIBS = -framework Foundation -lsqlite3

.PHONY: all clean smoke apidocs clean-docs leaks-check release-archive

all: $(BUILD_DIR)/libLeoRM.a $(BUILD_DIR)/lrm-smoke $(BUILD_DIR)/lrm-error-smoke $(BUILD_DIR)/lrm-statement-smoke $(BUILD_DIR)/lrm-query-smoke $(BUILD_DIR)/lrm-transaction-smoke $(BUILD_DIR)/lrm-metadata-smoke $(BUILD_DIR)/lrm-migration-smoke $(BUILD_DIR)/lrm-repository-smoke $(BUILD_DIR)/lrm-notes-example $(BUILD_DIR)/lrm-failure-paths-smoke $(BUILD_DIR)/lrm-constraint-errors-smoke $(BUILD_DIR)/lrm-migration-rollback-smoke $(BUILD_DIR)/lrm-edge-cases-smoke $(BUILD_DIR)/lrm-file-database-smoke $(BUILD_DIR)/lrm-leaks-target

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/LRMError.o: Sources/LRMError.m Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMError.m -o $@

$(BUILD_DIR)/LRMDatabase.o: Sources/LRMDatabase.m Sources/LRMDatabase.h Sources/LRMStatement.h Sources/Private/LRMStatementPrivate.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMDatabase.m -o $@

$(BUILD_DIR)/LRMStatement.o: Sources/LRMStatement.m Sources/LRMStatement.h Sources/Private/LRMStatementPrivate.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMStatement.m -o $@

$(BUILD_DIR)/LRMResultSet.o: Sources/LRMResultSet.m Sources/LRMResultSet.h Sources/LRMRow.h Sources/LRMStatement.h Sources/Private/LRMStatementPrivate.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMResultSet.m -o $@

$(BUILD_DIR)/LRMRow.o: Sources/LRMRow.m Sources/LRMRow.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMRow.m -o $@

$(BUILD_DIR)/LRMTransaction.o: Sources/LRMTransaction.m Sources/LRMTransaction.h Sources/LRMDatabase.h Sources/LRMStatement.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMTransaction.m -o $@

$(BUILD_DIR)/LRMMigration.o: Sources/LRMMigration.m Sources/LRMMigration.h Sources/LRMDatabase.h Sources/LRMStatement.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMMigration.m -o $@

$(BUILD_DIR)/LRMSchema.o: Sources/LRMSchema.m Sources/LRMSchema.h Sources/LRMMigration.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMSchema.m -o $@

$(BUILD_DIR)/LRMMigrationRunner.o: Sources/LRMMigrationRunner.m Sources/LRMMigrationRunner.h Sources/LRMDatabase.h Sources/LRMMigration.h Sources/LRMSchema.h Sources/LRMTransaction.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMMigrationRunner.m -o $@

$(BUILD_DIR)/LRMRepository.o: Sources/LRMRepository.m Sources/LRMRepository.h Sources/LRMDatabase.h Sources/LRMStatement.h Sources/LRMResultSet.h Sources/LRMError.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Sources/LRMRepository.m -o $@

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

$(BUILD_DIR)/lrm-migration-smoke: Tests/migration_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/migration_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-repository-smoke: Tests/repository_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/repository_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/NotesStoreNote.o: Examples/NotesStore/Note.m Examples/NotesStore/Note.h | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Examples/NotesStore/Note.m -o $@

$(BUILD_DIR)/NotesStoreNoteStore.o: Examples/NotesStore/NoteStore.m Examples/NotesStore/NoteStore.h Examples/NotesStore/Note.h $(BUILD_DIR)/libLeoRM.a | $(BUILD_DIR)
	$(CC) $(OBJCFLAGS) -c Examples/NotesStore/NoteStore.m -o $@

$(BUILD_DIR)/lrm-notes-example: Examples/NotesStore/main.m Examples/NotesStore/Note.h Examples/NotesStore/NoteStore.h $(BUILD_DIR)/NotesStoreNote.o $(BUILD_DIR)/NotesStoreNoteStore.o $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Examples/NotesStore/main.m $(BUILD_DIR)/NotesStoreNote.o $(BUILD_DIR)/NotesStoreNoteStore.o $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-failure-paths-smoke: Tests/failure_paths_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/failure_paths_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-constraint-errors-smoke: Tests/constraint_errors_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/constraint_errors_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-migration-rollback-smoke: Tests/migration_rollback_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/migration_rollback_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-edge-cases-smoke: Tests/edge_cases_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/edge_cases_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

$(BUILD_DIR)/lrm-file-database-smoke: Tests/file_database_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/file_database_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

smoke: $(BUILD_DIR)/lrm-smoke $(BUILD_DIR)/lrm-error-smoke $(BUILD_DIR)/lrm-statement-smoke $(BUILD_DIR)/lrm-query-smoke $(BUILD_DIR)/lrm-transaction-smoke $(BUILD_DIR)/lrm-metadata-smoke $(BUILD_DIR)/lrm-migration-smoke $(BUILD_DIR)/lrm-repository-smoke $(BUILD_DIR)/lrm-notes-example $(BUILD_DIR)/lrm-failure-paths-smoke $(BUILD_DIR)/lrm-constraint-errors-smoke $(BUILD_DIR)/lrm-migration-rollback-smoke $(BUILD_DIR)/lrm-edge-cases-smoke $(BUILD_DIR)/lrm-file-database-smoke
	$(BUILD_DIR)/lrm-smoke
	$(BUILD_DIR)/lrm-error-smoke
	$(BUILD_DIR)/lrm-statement-smoke
	$(BUILD_DIR)/lrm-query-smoke
	$(BUILD_DIR)/lrm-transaction-smoke
	$(BUILD_DIR)/lrm-metadata-smoke
	$(BUILD_DIR)/lrm-migration-smoke
	$(BUILD_DIR)/lrm-repository-smoke
	$(BUILD_DIR)/lrm-notes-example
	$(BUILD_DIR)/lrm-failure-paths-smoke
	$(BUILD_DIR)/lrm-constraint-errors-smoke
	$(BUILD_DIR)/lrm-migration-rollback-smoke
	$(BUILD_DIR)/lrm-edge-cases-smoke
	$(BUILD_DIR)/lrm-file-database-smoke

$(BUILD_DIR)/lrm-leaks-target: Tests/leaks_main.m $(BUILD_DIR)/libLeoRM.a
	$(CC) $(OBJCFLAGS) Tests/leaks_main.m $(BUILD_DIR)/libLeoRM.a $(LIBS) -o $@

leaks-check: $(BUILD_DIR)/lrm-leaks-target
	Tools/run_leaks_check.sh

release-archive:
	@if [ -z "$(VERSION)" ]; then echo "error: VERSION is required, e.g. make release-archive VERSION=v0.1.2-quality-gates"; exit 1; fi
	Tools/make_release_archive.sh "$(VERSION)"

apidocs:
	Tools/build_headerdoc.sh

clean-docs:
	rm -rf $(BUILD_DIR)/HeaderDoc

clean:
	rm -rf $(BUILD_DIR)
