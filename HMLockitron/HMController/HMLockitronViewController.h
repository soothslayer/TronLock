//
//  HMLockitronViewController.h
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMLockitronManager.h"

@interface HMLockitronViewController : UIViewController
- (void)refreshAllLocks;
- (void)showLoginVCbecauseAccessTokenIsExpiredOrNil:(NSString *)expiredOrNil;
- (void)lockNotificationLock:(NSString *)lock ChangedLockStateTo:(NSNumber *)changedState;
@end
