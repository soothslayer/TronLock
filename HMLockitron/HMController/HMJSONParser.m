//
//  HMJSONParser.m
//  TronLock
//
//  Created by Hanlon Miller on 2/18/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "HMJSONParser.h"
#import "HMLock.h"

@interface HMJSONParser ()

+ (NSNumber *)convertLockStateString:(NSString *)stateString;

@end
@implementation HMJSONParser

+ (id)parse:(NSDictionary *)dictionary ObjectForKey:(NSString *)key {
    //NSLog(@"parsing key:%@", key);
    if ([dictionary objectForKey:key] == [NSNull null]) {
        //NSLog(@"null");
        return nil;
    }
    //NSLog(@"not null");
    if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]]) {
        //NSLog(@"string class");
        NSString *objectAtKey = [dictionary objectForKey:key];
        if ([key isEqualToString:@"state"]) {
            //NSLog(@"string is state");
            return [HMJSONParser convertLockStateString:objectAtKey];
        }
        //NSLog(@"string is not state");
    }
    return [dictionary objectForKey:key];
}
+ (NSString *)convertLockStateNumber:(NSNumber *)stateNumber {
    return ([stateNumber integerValue] == LockitronSDKLockOpen) ? @"unlock" : @"lock";
}
+ (NSNumber *)convertLockStateString:(NSString *)stateString {
    //NSLog(@"checking if unlock");
    return ([stateString isEqualToString:@"unlock"]) ? [NSNumber numberWithInteger:LockitronSDKLockOpen] : [NSNumber numberWithInteger:LockitronSDKLockClosed];
}
@end
