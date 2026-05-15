//
//  LRMDatabase.h
//  LeoRM
//
//  Database connection placeholder for LeoRM V1.
//

#import <Foundation/Foundation.h>

@interface LRMDatabase : NSObject
{
@private
    NSString *_path;
}

+ (id)databaseWithPath:(NSString *)path error:(NSError **)error;
- (id)initWithPath:(NSString *)path error:(NSError **)error;

- (NSString *)path;

@end
