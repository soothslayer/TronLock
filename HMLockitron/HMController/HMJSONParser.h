//
//  HMJSONParser.h
//  TronLock
//
//  Created by Hanlon Miller on 2/18/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMJSONParser : NSObject
+ (NSString *)convertLockStateNumber:(NSNumber *)stateNumber;
+ (id)parse:(NSDictionary *)dictionary ObjectForKey:(NSString *)key;
@end
