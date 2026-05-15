//
//  LRMError.m
//  LeoRM
//
//  Error definitions for LeoRM.
//

#import "LRMError.h"

NSString * const LRMErrorDomain = @"org.quietcode.LeoRM";

NSError *LRMErrorMake(NSInteger code, NSString *message)
{
    NSDictionary *userInfo = nil;

    if (message != nil) {
        userInfo = [NSDictionary dictionaryWithObject:message
                                               forKey:NSLocalizedDescriptionKey];
    }

    return [NSError errorWithDomain:LRMErrorDomain
                               code:code
                           userInfo:userInfo];
}
