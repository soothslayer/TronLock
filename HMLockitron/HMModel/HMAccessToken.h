//
//  HMAccessToken.h
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HMLock;

@interface HMAccessToken : NSManagedObject

@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSDate * expiration_date;
@property (nonatomic, retain) NSSet *locks;
@end

@interface HMAccessToken (CoreDataGeneratedAccessors)

- (void)addLocksObject:(HMLock *)value;
- (void)removeLocksObject:(HMLock *)value;
- (void)addLocks:(NSSet *)values;
- (void)removeLocks:(NSSet *)values;

@end
