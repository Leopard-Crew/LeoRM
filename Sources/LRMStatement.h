//
//  LRMStatement.h
//  LeoRM
//
//  Prepared SQLite statement wrapper for LeoRM V1.
//

#import <Foundation/Foundation.h>

struct sqlite3;
struct sqlite3_stmt;

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

- (BOOL)bindObject:(id)value atIndex:(NSInteger)index error:(NSError **)error;
- (BOOL)executeUpdate:(NSError **)error;

- (void)reset;
- (void)finalizeStatement;

@end
