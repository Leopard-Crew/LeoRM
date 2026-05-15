//
//  LRMResultSet.h
//  LeoRM
//
//  SQLite result set wrapper for LeoRM V1.
//

#import <Foundation/Foundation.h>

@class LRMRow;
@class LRMStatement;

@interface LRMResultSet : NSObject
{
@private
    LRMStatement *_statement;
    LRMRow *_currentRow;
    BOOL _closed;
}

- (id)initWithStatement:(LRMStatement *)statement;

- (BOOL)next:(NSError **)error;
- (LRMRow *)currentRow;
- (void)close;
- (BOOL)isClosed;

@end
