//
//  HMLockitronManager.h
//  TronLock
//
//  Created by Hanlon Miller on 2/23/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMLock;

@protocol HMLockitronManagerDelegate <NSObject>

@required
- (void)refreshAllLocks;

@optional
- (void)lockitronChangedLockState:(HMLock *)lock to:(NSInteger)state;
- (void)lockitronDeniedAccess:(HMLock *)lock errorMessage:(NSString *)error;
- (void)showLoginVCbecauseAccessTokenIsExpiredOrNil:(NSString *)expiredOrNil;
//delegates forwarded from HMLockitrornAPI
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState;

@end

@interface HMLockitronManager : NSObject
+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret URIcallback:(NSString *)URIcallback delegate:(id<HMLockitronManagerDelegate>)delegate;
+ (NSArray *)lockList;
+ (NSURL *)provideAuthenticationCodeURL;
+ (void)authenticationCodeReceived:(NSString *)code;
+ (void)refreshLocks;
+ (void)requestLock:(HMLock *)lock ChangeAttribute:(NSString *)attribute to:(NSString *)changeTo;
@end
