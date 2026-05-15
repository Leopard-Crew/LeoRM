//
//  LRMError.h
//  LeoRM
//
//  Error definitions for LeoRM.
//

#import <Foundation/Foundation.h>

extern NSString * const LRMErrorDomain;

enum {
    LRMErrorUnknown = 1,
    LRMErrorInvalidArgument = 2,
    LRMErrorSQLite = 100
};

NSError *LRMErrorMake(NSInteger code, NSString *message);
