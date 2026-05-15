//
//  LRMStatement.h
//  LeoRM
//
//  Public prepared-statement interface for LeoRM.
//

#import <Foundation/Foundation.h>

struct sqlite3;
struct sqlite3_stmt;

@class LRMResultSet;

/*!
 * @class LRMStatement
 * @abstract Explicit wrapper around one prepared SQLite statement.
 * @discussion
 * LRMStatement owns one sqlite3_stmt prepared from visible SQL. It supports
 * Foundation value binding, update execution, query execution, resetting, and
 * explicit finalization.
 *
 * LRMStatement does not generate SQL, own transactions, map rows into domain
 * objects, or hide SQLite semantics. SQL remains visible through the sql
 * accessor for debugging and error reporting.
 *
 * Instances use manual retain/release. Statements should be finalized
 * explicitly with finalizeStatement when no longer needed. dealloc performs
 * defensive cleanup.
 */
@interface LRMStatement : NSObject
{
@private
    struct sqlite3 *_database;
    struct sqlite3_stmt *_statement;
    NSString *_sql;
    NSString *_databasePath;
}

/*!
 * @method initWithDatabase:sql:databasePath:error:
 * @abstract Prepares SQL against an open SQLite database handle.
 * @param database Open SQLite database handle. Must not be NULL.
 * @param sql SQL string to prepare. Must not be nil or empty.
 * @param databasePath Optional database path used for error context.
 * @param error Optional NSError output. Filled on invalid input or SQLite
 * prepare failure.
 * @result Returns an owned LRMStatement, or nil on failure.
 * @discussion
 * The statement retains the SQL and database path strings, but it does not own
 * the SQLite database handle itself. The database must remain open while the
 * statement is used.
 */
- (id)initWithDatabase:(struct sqlite3 *)database
                   sql:(NSString *)sql
          databasePath:(NSString *)databasePath
                 error:(NSError **)error;

/*!
 * @method sql
 * @abstract Returns the SQL string used to prepare this statement.
 * @result Returns the SQL string. The caller does not own the returned object.
 */
- (NSString *)sql;

/*!
 * @method databasePath
 * @abstract Returns the database path associated with this statement.
 * @result Returns the database path, or nil if none was provided. The caller
 * does not own the returned object.
 */
- (NSString *)databasePath;

/*!
 * @method sqliteDatabase
 * @abstract Returns the underlying SQLite database handle.
 * @result Returns the sqlite3 handle used by this statement.
 * @discussion
 * This is exposed for LeoRM internals such as LRMResultSet error reporting.
 * Callers should not close this handle.
 */
- (struct sqlite3 *)sqliteDatabase;

/*!
 * @method sqliteStatement
 * @abstract Returns the underlying prepared SQLite statement handle.
 * @result Returns the sqlite3_stmt handle, or NULL after finalization.
 * @discussion
 * This is exposed for LeoRM internals such as LRMResultSet and LRMRow. Callers
 * should not step, reset, or finalize this handle directly.
 */
- (struct sqlite3_stmt *)sqliteStatement;

/*!
 * @method bindObject:atIndex:error:
 * @abstract Binds a Foundation value to a SQLite parameter index.
 * @param value Value to bind. Supported values are NSString, NSNumber, NSData,
 * nil, and NSNull.
 * @param index SQLite parameter index. SQLite bind indexes start at 1.
 * @param error Optional NSError output. Filled on invalid state, unsupported
 * value class, invalid index, or SQLite bind failure.
 * @result Returns YES on success, NO on failure.
 * @discussion
 * NSNumber values are bound as integer or double based on Objective-C type
 * encoding. NSString values are bound as UTF-8 text. NSData values are bound as
 * blobs. nil and NSNull are bound as SQL NULL.
 */
- (BOOL)bindObject:(id)value atIndex:(NSInteger)index error:(NSError **)error;

/*!
 * @method executeUpdate:
 * @abstract Executes a statement that is expected to finish with SQLITE_DONE.
 * @param error Optional NSError output.
 * @result Returns YES when sqlite3_step returns SQLITE_DONE, NO otherwise.
 * @discussion
 * Use this for CREATE, INSERT, UPDATE, DELETE, and other non-row-returning SQL.
 * The statement is not automatically reset after execution.
 */
- (BOOL)executeUpdate:(NSError **)error;

/*!
 * @method executeQuery:
 * @abstract Creates a result set for row-returning SQL.
 * @param error Optional NSError output. Filled if the statement has already
 * been finalized.
 * @result Returns an autoreleased LRMResultSet, or nil on failure.
 * @discussion
 * The returned result set retains this statement and owns the stepping process.
 * Closing the result set finalizes the underlying statement.
 */
- (LRMResultSet *)executeQuery:(NSError **)error;

/*!
 * @method reset
 * @abstract Resets the prepared statement and clears bindings.
 * @discussion
 * This calls sqlite3_reset and sqlite3_clear_bindings when the statement is
 * still active. Calling reset after finalization has no effect.
 */
- (void)reset;

/*!
 * @method finalizeStatement
 * @abstract Finalizes the underlying sqlite3_stmt.
 * @discussion
 * This method is idempotent. After finalization, binding and execution methods
 * fail. Result sets that own a statement call this when closed.
 */
- (void)finalizeStatement;

@end
