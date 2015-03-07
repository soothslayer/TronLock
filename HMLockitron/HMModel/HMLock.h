//
//  HMLock.h
//  TronLock
//
//  Created by Hanlon Miller on 3/6/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HMAccessToken, HMKey, HMPendingActivity;

typedef NS_ENUM(NSInteger, LockitronSDKLockState) {
    LockitronSDKLockNotConfigured = -1,
    LockitronSDKLockOpen,
    LockitronSDKLockClosed
};
typedef NS_ENUM(NSInteger, LockitronSDKLockButtonType) {
    LockitronSDKLockitronBuzzer,
    LockitronSDKLockitronNew,
    LockitronSDKLockitronOld
};

@interface HMLock : NSManagedObject

@property (nonatomic, retain) NSNumber * avr_update_progress;
@property (nonatomic, retain) NSNumber * avr_version;
@property (nonatomic, retain) NSNumber * battery_voltage;
@property (nonatomic, retain) NSNumber * ble_update_progress;
@property (nonatomic, retain) NSNumber * button_type;
@property (nonatomic, retain) NSNumber * handedness;
@property (nonatomic, retain) NSString * hardware_id;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * last_heard_from;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * next_wake;
@property (nonatomic, retain) NSString * serial_number;
@property (nonatomic, retain) NSNumber * sleep_period;
@property (nonatomic, retain) NSNumber * sms;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * time_zone;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) HMAccessToken *access_token;
@property (nonatomic, retain) NSSet *keys;
@property (nonatomic, retain) NSSet *pending_activities;
- (void)changeLockStateTo:(NSNumber *)newState;
@end

@interface HMLock (CoreDataGeneratedAccessors)

- (void)addKeysObject:(HMKey *)value;
- (void)removeKeysObject:(HMKey *)value;
- (void)addKeys:(NSSet *)values;
- (void)removeKeys:(NSSet *)values;

- (void)addPending_activitiesObject:(HMPendingActivity *)value;
- (void)removePending_activitiesObject:(HMPendingActivity *)value;
- (void)addPending_activities:(NSSet *)values;
- (void)removePending_activities:(NSSet *)values;

@end
