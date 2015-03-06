//
//  HMKey.h
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HMLock, HMUser;

typedef NS_ENUM(NSInteger, LockitronSDKUserRole) {
    LockitronSDKUserGuest,
    LockitronSDKUserAdmin,
    LockitronSDKUserOwner
};@interface HMKey : NSManagedObject

@property (nonatomic, retain) NSDate * expiration_date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * role;
@property (nonatomic, retain) NSNumber * sms_pin;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) NSNumber * visible;
@property (nonatomic, retain) HMLock *lock;
@property (nonatomic, retain) HMUser *user;

@end
