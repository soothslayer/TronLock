//
//  HMLock.m
//  TronLock
//
//  Created by Hanlon Miller on 3/6/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "HMLock.h"
#import "HMAccessToken.h"
#import "HMKey.h"
#import "HMPendingActivity.h"
#import "HMLockitronManager.h"

@implementation HMLock

@dynamic avr_update_progress;
@dynamic avr_version;
@dynamic battery_voltage;
@dynamic ble_update_progress;
@dynamic button_type;
@dynamic handedness;
@dynamic hardware_id;
@dynamic id;
@dynamic last_heard_from;
@dynamic name;
@dynamic next_wake;
@dynamic serial_number;
@dynamic sleep_period;
@dynamic sms;
@dynamic state;
@dynamic time_zone;
@dynamic updated_at;
@dynamic access_token;
@dynamic keys;
@dynamic pending_activities;
- (void)changeLockStateTo:(NSNumber *)newState {
    NSString *newStateAsString = ([newState integerValue] == 0) ? @"unlock" : @"lock";
    NSLog(@"HMLock:lock:%@ request state change to %@", self.name, newState);
    [HMLockitronManager requestLock:self ChangeAttribute:@"state" to:newStateAsString];
}
@end
