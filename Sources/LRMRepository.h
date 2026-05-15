//
//  LRMRepository.h
//  LeoRM
//
//  Minimal DAO-style repository helper for LeoRM V1.
//

#import <Foundation/Foundation.h>

@class LRMDatabase;
@class LRMResultSet;
@class LRMStatement;

@interface LRMRepository : NSObject
{
@private
    LRMDatabase *_database;
}

- (id)initWithDatabase:(LRMDatabase *)database error:(NSError **)error;

- (LRMDatabase *)database;

- (BOOL)executeSQL:(NSString *)sql
         arguments:(NSArray *)arguments
             error:(NSError **)error;

- (LRMResultSet *)resultSetForSQL:(NSString *)sql
                        arguments:(NSArray *)arguments
                            error:(NSError **)error;

- (BOOL)bindArguments:(NSArray *)arguments
          toStatement:(LRMStatement *)statement
                error:(NSError **)error;

@end
