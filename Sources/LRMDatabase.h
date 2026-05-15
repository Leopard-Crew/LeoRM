//
//  LRMDatabase.h
//  LeoRM
//
//  Database connection for LeoRM V1.
//

#import <Foundation/Foundation.h>

typedef struct sqlite3 sqlite3;

@interface LRMDatabase : NSObject
{
@private
    NSString *_path;
    sqlite3 *_database;
}

+ (id)databaseWithPath:(NSString *)path error:(NSError **)error;
- (id)initWithPath:(NSString *)path error:(NSError **)error;

- (NSString *)path;

- (BOOL)open:(NSError **)error;
- (void)close;
- (BOOL)isOpen;

@end
