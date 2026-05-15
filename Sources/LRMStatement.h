//
//  LRMStatement.h
//  LeoRM
//
//  Prepared SQLite statement wrapper for LeoRM V1.
//

#import <Foundation/Foundation.h>

struct sqlite3;
struct sqlite3_stmt;

@class LRMResultSet;

@interface LRMStatement : NSObject
{
@private
    struct sqlite3 *_database;
    struct sqlite3_stmt *_statement;
    NSString *_sql;
    NSString *_databasePath;
}

- (id)initWithDatabase:(struct sqlite3 *)database
                   sql:(NSString *)sql
          databasePath:(NSString *)databasePath
                 error:(NSError **)error;

- (NSString *)sql;
- (NSString *)databasePath;

- (struct sqlite3 *)sqliteDatabase;
- (struct sqlite3_stmt *)sqliteStatement;

- (BOOL)bindObject:(id)value atIndex:(NSInteger)index error:(NSError **)error;
- (BOOL)executeUpdate:(NSError **)error;
- (LRMResultSet *)executeQuery:(NSError **)error;

- (void)reset;
- (void)finalizeStatement;

@end
