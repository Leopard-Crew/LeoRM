//
//  LRMMigrationRunner.h
//  LeoRM
//
//  Ordered schema migration runner for LeoRM V1.
//

#import <Foundation/Foundation.h>

@class LRMDatabase;
@class LRMSchema;

@interface LRMMigrationRunner : NSObject

- (BOOL)migrateDatabase:(LRMDatabase *)database
                 schema:(LRMSchema *)schema
                  error:(NSError **)error;

@end
