//
//  LRMSchema.h
//  LeoRM
//
//  Schema description for LeoRM V1 migrations.
//

#import <Foundation/Foundation.h>

@interface LRMSchema : NSObject
{
@private
    NSString *_name;
    NSInteger _targetVersion;
    NSArray *_migrations;
}

+ (id)schemaWithName:(NSString *)name
       targetVersion:(NSInteger)targetVersion
          migrations:(NSArray *)migrations
               error:(NSError **)error;

- (id)initWithName:(NSString *)name
     targetVersion:(NSInteger)targetVersion
        migrations:(NSArray *)migrations
             error:(NSError **)error;

- (NSString *)name;
- (NSInteger)targetVersion;
- (NSArray *)migrations;

@end
