//
//  LRMStatement.m
//  LeoRM
//
//  Prepared SQLite statement wrapper for LeoRM V1.
//

#import "LRMStatement.h"
#import "LRMError.h"

#import <sqlite3.h>
#import <string.h>

@implementation LRMStatement

- (id)initWithDatabase:(struct sqlite3 *)database
                   sql:(NSString *)sql
          databasePath:(NSString *)databasePath
                 error:(NSError **)error
{
    int result = SQLITE_OK;

    self = [super init];
    if (self == nil) {
        return nil;
    }

    if (database == NULL) {
        if (error != NULL) {
            *error = LRMErrorMake(LRMErrorInvalidArgument, @"Database must be open before preparing a statement.");
        }

        [self release];
        return nil;
    }

    if (sql == nil || [sql length] == 0) {
        if (error != NULL) {
            *error = LRMErrorMake(LRMErrorInvalidArgument, @"SQL must not be empty.");
        }

        [self release];
        return nil;
    }

    _database = database;
    _sql = [sql copy];
    _databasePath = [databasePath copy];
    _statement = NULL;

    result = sqlite3_prepare_v2(_database,
                                [_sql UTF8String],
                                -1,
                                &_statement,
                                NULL);

    if (result != SQLITE_OK) {
        if (error != NULL) {
            *error = LRMSQLiteErrorMake(_database, result, _sql, _databasePath);
        }

        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [self finalizeStatement];

    [_sql release];
    [_databasePath release];

    [super dealloc];
}

- (NSString *)sql
{
    return _sql;
}

- (BOOL)bindObject:(id)value atIndex:(NSInteger)index error:(NSError **)error
{
    int result = SQLITE_OK;

    if (_statement == NULL) {
        if (error != NULL) {
            *error = LRMErrorMake(LRMErrorInvalidArgument, @"Cannot bind to a finalized statement.");
        }

        return NO;
    }

    if (index < 1) {
        if (error != NULL) {
            *error = LRMErrorMake(LRMErrorInvalidArgument, @"SQLite bind indexes start at 1.");
        }

        return NO;
    }

    if (value == nil || value == [NSNull null]) {
        result = sqlite3_bind_null(_statement, (int)index);
    } else if ([value isKindOfClass:[NSString class]]) {
        result = sqlite3_bind_text(_statement,
                                   (int)index,
                                   [value UTF8String],
                                   -1,
                                   SQLITE_TRANSIENT);
    } else if ([value isKindOfClass:[NSNumber class]]) {
        const char *type = [value objCType];

        if (type != NULL &&
            (strcmp(type, @encode(float)) == 0 ||
             strcmp(type, @encode(double)) == 0)) {
            result = sqlite3_bind_double(_statement,
                                         (int)index,
                                         [value doubleValue]);
        } else {
            result = sqlite3_bind_int64(_statement,
                                        (int)index,
                                        (long long)[value longLongValue]);
        }
    } else if ([value isKindOfClass:[NSData class]]) {
        result = sqlite3_bind_blob(_statement,
                                   (int)index,
                                   [value bytes],
                                   (int)[value length],
                                   SQLITE_TRANSIENT);
    } else {
        if (error != NULL) {
            NSString *message = [NSString stringWithFormat:@"Unsupported bind value class: %@",
                                                           NSStringFromClass([value class])];
            *error = LRMErrorMake(LRMErrorInvalidArgument, message);
        }

        return NO;
    }

    if (result != SQLITE_OK) {
        if (error != NULL) {
            *error = LRMSQLiteErrorMake(_database, result, _sql, _databasePath);
        }

        return NO;
    }

    return YES;
}

- (BOOL)executeUpdate:(NSError **)error
{
    int result = SQLITE_OK;

    if (_statement == NULL) {
        if (error != NULL) {
            *error = LRMErrorMake(LRMErrorInvalidArgument, @"Cannot execute a finalized statement.");
        }

        return NO;
    }

    result = sqlite3_step(_statement);

    if (result != SQLITE_DONE) {
        if (error != NULL) {
            *error = LRMSQLiteErrorMake(_database, result, _sql, _databasePath);
        }

        return NO;
    }

    return YES;
}

- (void)reset
{
    if (_statement != NULL) {
        sqlite3_reset(_statement);
        sqlite3_clear_bindings(_statement);
    }
}

- (void)finalizeStatement
{
    if (_statement != NULL) {
        sqlite3_finalize(_statement);
        _statement = NULL;
    }
}

@end
