//
//  HMPendingActivity.h
//  TronLock
//
//  Created by Hanlon Miller on 3/6/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HMLock;

@interface HMPendingActivity : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * updated_value;
@property (nonatomic, retain) NSNumber * request_status;
@property (nonatomic, retain) HMLock *lock;

@end
