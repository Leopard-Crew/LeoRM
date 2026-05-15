//
//  LRMError.h
//  LeoRM
//
//  Error definitions for LeoRM.
//

#import <Foundation/Foundation.h>

struct sqlite3;

extern NSString * const LRMErrorDomain;

extern NSString * const LRMErrorSQLiteCodeKey;
extern NSString * const LRMErrorSQLiteMessageKey;
extern NSString * const LRMErrorSQLKey;
extern NSString * const LRMErrorDatabasePathKey;

enum {
    LRMErrorUnknown = 1,
    LRMErrorInvalidArgument = 2,
    LRMErrorSQLite = 100
};

NSError *LRMErrorMake(NSInteger code, NSString *message);
NSError *LRMErrorMakeWithUserInfo(NSInteger code, NSString *message, NSDictionary *extraUserInfo);

NSError *LRMSQLiteErrorMake(struct sqlite3 *database,
                            int sqliteCode,
                            NSString *sql,
                            NSString *databasePath);
