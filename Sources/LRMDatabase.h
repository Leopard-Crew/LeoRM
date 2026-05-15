//
//  LRMDatabase.h
//  LeoRM
//
//  Database connection for LeoRM V1.
//

#import <Foundation/Foundation.h>

struct sqlite3;

@class LRMStatement;
@class LRMTransaction;

@interface LRMDatabase : NSObject
{
@private
    NSString *_path;
    struct sqlite3 *_database;
}

+ (id)databaseWithPath:(NSString *)path error:(NSError **)error;
- (id)initWithPath:(NSString *)path error:(NSError **)error;

- (NSString *)path;

- (BOOL)open:(NSError **)error;
- (void)close;
- (BOOL)isOpen;

- (LRMStatement *)prepareStatement:(NSString *)sql error:(NSError **)error;
- (LRMTransaction *)beginTransaction:(NSError **)error;

- (BOOL)ensureMetadataTable:(NSError **)error;

- (NSString *)metadataValueForKey:(NSString *)key error:(NSError **)error;
- (BOOL)setMetadataValue:(NSString *)value forKey:(NSString *)key error:(NSError **)error;

- (BOOL)getSchemaVersion:(NSInteger *)version
           forSchemaName:(NSString *)schemaName
                   error:(NSError **)error;

- (BOOL)setSchemaVersion:(NSInteger)version
           forSchemaName:(NSString *)schemaName
                   error:(NSError **)error;

@end
