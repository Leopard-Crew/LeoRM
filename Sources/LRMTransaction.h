//
//  LRMTransaction.h
//  LeoRM
//
//  Explicit SQLite transaction wrapper for LeoRM V1.
//

#import <Foundation/Foundation.h>

@class LRMDatabase;

@interface LRMTransaction : NSObject
{
@private
    LRMDatabase *_database;
    BOOL _active;
}

- (id)initWithDatabase:(LRMDatabase *)database error:(NSError **)error;

- (BOOL)commit:(NSError **)error;
- (BOOL)rollback:(NSError **)error;
- (BOOL)isActive;

@end
