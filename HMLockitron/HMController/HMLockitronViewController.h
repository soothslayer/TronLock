//
//  HMLockitronViewController.h
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMLockitronManager.h"
@class HMLock;
@interface HMLockitronViewController : UIViewController
- (void)refreshAllLocks;
- (void)showLoginVCbecauseAccessTokenIsExpiredOrNil:(NSString *)expiredOrNil;
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState;
- (NSString *)displayFuzzyTimeFromDate:(NSDate *)fromDate basedOnTimeZone:(NSString *)timeZone;
@end
