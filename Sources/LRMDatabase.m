//
//  LRMDatabase.m
//  LeoRM
//
//  Database connection for LeoRM V1.
//

#import "LRMDatabase.h"
#import "LRMError.h"

#import <sqlite3.h>

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
    _database = NULL;

    return self;
}

- (void)dealloc
{
    [self close];

    [_path release];

    [super dealloc];
}

- (NSString *)path
{
    return _path;
}

- (BOOL)open:(NSError **)error
{
    int result = SQLITE_OK;

    if (_database != NULL) {
        return YES;
    }

    result = sqlite3_open([_path fileSystemRepresentation], &_database);

    if (result != SQLITE_OK) {
        if (error != NULL) {
            *error = LRMSQLiteErrorMake(_database, result, nil, _path);
        }

        if (_database != NULL) {
            sqlite3_close(_database);
            _database = NULL;
        }

        return NO;
    }

    return YES;
}

- (void)close
{
    if (_database != NULL) {
        sqlite3_close(_database);
        _database = NULL;
    }
}

- (BOOL)isOpen
{
    return (_database != NULL);
}

@end
