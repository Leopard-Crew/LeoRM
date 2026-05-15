//
//  LRMRow.h
//  LeoRM
//
//  SQLite result row access for LeoRM V1.
//

#import <Foundation/Foundation.h>

@interface LRMRow : NSObject
{
@private
    void *_statement;
}

- (id)initWithStatement:(void *)statement;

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
