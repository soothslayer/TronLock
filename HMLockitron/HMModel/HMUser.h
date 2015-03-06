//
//  HMUser.h
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HMKey;

@interface HMUser : NSManagedObject

@property (nonatomic, retain) NSNumber * activated;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * changing_email;
@property (nonatomic, retain) NSNumber * changing_phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * facebook;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) HMKey *key;

@end
