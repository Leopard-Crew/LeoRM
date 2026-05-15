//
//  LRMRow.h
//  LeoRM
//
//  SQLite result row access for LeoRM V1.
//

#import <Foundation/Foundation.h>

struct sqlite3_stmt;

@interface LRMRow : NSObject
{
@private
    struct sqlite3_stmt *_statement;
}

- (id)initWithStatement:(struct sqlite3_stmt *)statement;

- (NSInteger)columnCount;
- (NSString *)columnNameAtIndex:(NSInteger)index;

- (id)objectAtIndex:(NSInteger)index;
- (id)objectForColumn:(NSString *)name;

- (NSString *)stringAtIndex:(NSInteger)index;
- (NSString *)stringForColumn:(NSString *)name;

- (NSNumber *)numberAtIndex:(NSInteger)index;
- (NSNumber *)numberForColumn:(NSString *)name;

- (NSData *)dataAtIndex:(NSInteger)index;
- (NSData *)dataForColumn:(NSString *)name;

- (BOOL)isNullAtIndex:(NSInteger)index;
- (BOOL)isNullForColumn:(NSString *)name;

@end
