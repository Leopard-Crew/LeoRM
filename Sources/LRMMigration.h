//
//  LRMMigration.h
//  LeoRM
//
//  Explicit schema migration step for LeoRM V1.
//

#import <Foundation/Foundation.h>

@class LRMDatabase;

@interface LRMMigration : NSObject
{
@private
    NSInteger _fromVersion;
    NSInteger _toVersion;
    NSArray *_SQLStatements;
}

+ (id)migrationFromVersion:(NSInteger)fromVersion
                 toVersion:(NSInteger)toVersion
             SQLStatements:(NSArray *)SQLStatements;

- (id)initFromVersion:(NSInteger)fromVersion
            toVersion:(NSInteger)toVersion
        SQLStatements:(NSArray *)SQLStatements;

- (NSInteger)fromVersion;
- (NSInteger)toVersion;
- (NSArray *)SQLStatements;

- (BOOL)applyToDatabase:(LRMDatabase *)database error:(NSError **)error;

@end
