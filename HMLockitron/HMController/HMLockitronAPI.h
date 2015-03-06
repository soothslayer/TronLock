//
//  HMLockitronAPI.h
//  TronLock
//
//  Created by Hanlon Miller on 2/23/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMLock;


static const NSString *lockitronURL = @"https://api.lockitron.com/v1/";
static const NSString *lockitronBaseURL = @"https://api.lockitron.com/";
static const NSString *lockitronCommandURL = @"https://api.lockitron.com/v1/locks";
static const NSString *suiteName = @"group.hanlonmiller";

@class HMAccessToken;

@protocol HMLockitronAPIDelegate <NSObject>

@optional
- (void)lockNotificationNewID:(NSString *)newID;
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState;
@end

@interface HMLockitronAPI : NSObject

@property (weak) id<HMLockitronAPIDelegate> delegate;

- (id)requestAllLocksFromLockitronAPI;
- (void)parseAllLocksFromJSON:(id)JSONresults;
- (void)requestLock:(HMLock *)lock ChangeAttribute:(NSString *)attribute to:(NSString *)changeTo;

@end