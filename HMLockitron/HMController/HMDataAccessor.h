//
//  HMDataAccessor.h
//  TronLock
//
//  Created by Hanlon Miller on 2/9/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HMAccessToken;

@interface HMDataAccessor : NSObject

@property (strong) HMAccessToken *accessTokenObject;

- (void)DoYouExist;
- (NSArray *)fetchEntitiesWithName:(NSString *)entityName;
- (NSArray *)fetchEntitiesUsingFetchRequest:(NSFetchRequest *)fetchRequest;
- (id)createNewEntityWithName:(NSString *)entityName;
- (void)deleteEntityObject:(NSManagedObject *)object;
- (NSError *)save;
@end
