//
//  HMLockitronViewController.m
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "HMLockitronViewController.h"
#import <CRToast/CRToast.h>
#import "HMLock.h"

@interface HMLockitronViewController ()

@end

@implementation HMLockitronViewController {
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)refreshAllLocks {
    
}
- (void)showLoginVCbecauseAccessTokenIsExpiredOrNil:(NSString *)expiredOrNil {

}
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState {
    [CRToastManager showNotificationWithMessage:[NSString stringWithFormat:@"%@ just %@", lock.name, ([changedState integerValue] == 0) ? @"Unlocked" : @"Locked"] completionBlock:nil];
}
- (NSString *)displayFuzzyTimeFromDate:(NSDate *)fromDate basedOnTimeZone:(NSString *)timeZone {
    NSString *fuzzyTime = @"";
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd yy hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    NSTimeInterval timeSince = [fromDate timeIntervalSinceNow];
    if (timeSince > 0) {
        fuzzyTime = @"in:";
    } else if (timeSince < 0) {
        fuzzyTime = @"for:";
    }
    if (floor(fmod(timeSince, 5)) == -5) {
        [HMLockitronManager refreshLocks];
    } else {
    }
    timeSince = abs(timeSince);
    NSInteger seconds = fmod(timeSince, 60);
    NSInteger minutes = fmod(timeSince, 3600) / 60;
    NSInteger hours = fmod(timeSince, 87500) / 3600;
    NSInteger days = timeSince / 87500;
    if (days > 0) {
        fuzzyTime = [fuzzyTime stringByAppendingString:[NSString stringWithFormat:@"%li ", (long)days]];
        if (minutes > 1 && minutes < 2) {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Day "];
        } else {
            [fuzzyTime stringByAppendingString:@"Days "];
        }
    }
    if (hours > 0) {
        fuzzyTime = [fuzzyTime stringByAppendingString:[NSString stringWithFormat:@"%li ", (long)hours]];
        if (minutes > 1 && hours < 2) {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Hour "];
        } else {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Hours "];
        }
    }
    if (minutes > 0) {
        fuzzyTime = [fuzzyTime stringByAppendingString:[NSString stringWithFormat:@"%li ", (long)minutes]];
        if (minutes > 1 && minutes < 2) {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Minute "];
        } else {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Minutes "];
        }
    }
    if (seconds > 0 && minutes == 0) {
        fuzzyTime = [fuzzyTime stringByAppendingString:[NSString stringWithFormat:@"%li ", (long)seconds]];
        if (seconds > 1 && seconds < 2) {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Second "];
        } else {
            fuzzyTime = [fuzzyTime stringByAppendingString:@"Seconds "];
        }
    }
    return fuzzyTime;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
