//
//  smoke_main.m
//  LeoRM
//
//  Minimal compile/runtime smoke test.
//

#import <Foundation/Foundation.h>
#import "../Sources/LeoRM.h"

int main(int argc, const char *argv[])
{
    (void)argc;
    (void)argv;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSError *error = nil;
    LRMDatabase *database = [LRMDatabase databaseWithPath:@"test.sqlite"
                                                    error:&error];

    if (database == nil) {
        fprintf(stderr, "LeoRM smoke test failed: %s\n",
                [[[error localizedDescription] description] UTF8String]);
        [pool drain];
        return 1;
    }

    printf("LeoRM smoke test OK: %s\n", [[database path] UTF8String]);

    [pool drain];
    return 0;
}
