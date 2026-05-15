//
//  LRMDatabase.m
//  LeoRM
//
//  Database connection placeholder for LeoRM V1.
//

#import "LRMDatabase.h"
#import "LRMError.h"

@implementation LRMDatabase

+ (id)databaseWithPath:(NSString *)path error:(NSError **)error
{
    return [[[self alloc] initWithPath:path error:error] autorelease];
}

- (id)initWithPath:(NSString *)path error:(NSError **)error
{
    self = [super init];
    if (self == nil) {
        return nil;
    }

    if (path == nil || [path length] == 0) {
        if (error != NULL) {
            *error = LRMErrorMake(LRMErrorInvalidArgument, @"Database path must not be empty.");
        }

        [self release];
        return nil;
    }

    _path = [path copy];

    return self;
}

- (void)dealloc
{
    [_path release];
    [super dealloc];
}

- (NSString *)path
{
    return _path;
}

@end
