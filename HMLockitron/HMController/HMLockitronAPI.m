//
//  HMLockitronAPI.m
//  TronLock
//
//  Created by Hanlon Miller on 2/23/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "HMLockitronAPI.h"
#import "HMAccessToken.h"
#import "HMLock.h"
#import "HMKey.h"
#import "HMUser.h"
#import "HMDataAccessor.h"
#import "HMJSONParser.h"
#import "HMPendingActivity.h"

@interface HMLockitronAPI ()

@property (strong) HMDataAccessor *dataAccessor;
@property (strong) HMAccessToken *accessTokenObject;

@end

@implementation HMLockitronAPI {
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *numberFormatter;
}
- (id)init {
    if (self == [super init]) {
        _delegate = self.delegate;
        _dataAccessor = [HMDataAccessor new];
    }
    //set up the date formatter and number formatter
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return self;
}

- (id)requestAllLocksFromLockitronAPI {
    _accessTokenObject = [_dataAccessor fetchEntitiesWithName:@"HMAccessToken"][0];
    return [self lockitronAPIRequestforLocksorUsers:@"locks" withRequestMethod:@"GET" andDirectory:nil andAruments:nil];
}
- (id)lockitronAPIRequestforLocksorUsers:(NSString *)locksOrUsers withRequestMethod:(NSString *)requestMethod andDirectory:(NSString *)directory andAruments:(NSDictionary *)arguments {
    NSMutableDictionary *mutableArguments = [NSMutableDictionary dictionaryWithDictionary:arguments];
    //set up the base url
    NSString *urlString = [NSString stringWithFormat:@"%@v2", lockitronBaseURL];
    //add the locks or users subdirectory
    if ([locksOrUsers isEqualToString:@"locks"] || [locksOrUsers isEqualToString:@"users"]) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"/%@/", locksOrUsers]];
    } else {
        NSLog(@"lockitronAPI request wasn't for locks or users");
    }
    //add any other subdirectories
    if (directory != nil) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@", directory]];
    }
    //now add the access token
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?access_token=%@", _accessTokenObject.access_token]];
    //add no block parm if put
    //now add any arguments
    if (arguments != nil) {
        if ([requestMethod isEqualToString:@"PUT"]) {
            [mutableArguments addEntriesFromDictionary:@{@"noblock" : @"true"}];
        }
        for (NSString *argument in [mutableArguments allKeys]) {
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", argument, [mutableArguments objectForKey:argument]]];
        }
    }
    NSLog(@"sending api request:%@", urlString);
    //set up the request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
    //make sure the request is correct
    if ([requestMethod isEqualToString:@"GET"] || [requestMethod isEqualToString:@"PUT"] || [requestMethod isEqualToString:@"POST"] || [requestMethod isEqualToString:@"DELETE"]) {
        [urlRequest setHTTPMethod:requestMethod];
    } else {
        NSLog(@"lockitronAPI request method wasn't correct");
    }
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (data != nil) {
        NSError *error;
        id JSONdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        return JSONdata;
    }
    return nil;
    //    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error) {
    //        if (data) {
    //            _JSONdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //            if (_JSONdata) {
    //                [self lockitronAPIRequestCompletedWithJSONdata];
    //            } else {
    //                NSLog(@"JSON parsing error");
    //            }
    //        } else {
    //            NSLog(@"Error description:%@", error.description);
    //        }
    //    }];
}

- (void)parseAllLocksFromJSON:(id)JSONresults {
    NSMutableArray *locksFromTheWeb = [NSMutableArray array];
    if ([JSONresults isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in JSONresults)
        {
            [self parseLockInfofromJSONData:item];
            [locksFromTheWeb addObject:[item objectForKey:@"id"]];
        } //end of iterating through the locks
    } else if ([JSONresults isKindOfClass:[NSDictionary class]]) {
        [self parseLockInfofromJSONData:JSONresults];
        [locksFromTheWeb addObject:[JSONresults objectForKey:@"id"]];
    }
    NSLog(@"Finished loading locks");
    [_dataAccessor save];
    NSSet *locksFromMemory = _accessTokenObject.locks;
    NSSet *locksInMemoryThatDontExistOnWeb = [locksFromMemory objectsPassingTest:^BOOL(id obj, BOOL *stop){
        HMLock *tempLock = (HMLock *)obj;
        //return only locks whose id is not found in locks from the web
        return [locksFromTheWeb indexOfObject:tempLock.id] == NSNotFound;
    }];
    [_accessTokenObject removeLocks:locksInMemoryThatDontExistOnWeb];
    [_dataAccessor save];
}
- (HMLock *)parseLockInfofromJSONData:(NSDictionary *)item {
    //this will be thee working lock that ether holds an exisisting or new CoreData entity
    HMLock *lock = [_dataAccessor createNewEntityWithName:@"HMLock"];
    
    BOOL wasFound = NO;
    //NSLog(@"Cycling through the %lu locks in memory", _accessTokenObject.locks.count);
    //cycle through the locks in memory
    for (HMLock *lockAssocatedToAccessToken in _accessTokenObject.locks) {
        if ([lockAssocatedToAccessToken.id isEqualToString:[item objectForKey:@"id"]]) {
            [_dataAccessor deleteEntityObject:lock];
            lock = lockAssocatedToAccessToken;
            wasFound = YES;
        } else {
        }
    }
    if (!wasFound) {
        NSLog(@"new lock! Notiffying delegate");
        lock.id = [item objectForKey:@"id"];
        if ([_delegate respondsToSelector:@selector(lockNotificationNewID:)]) {
            [_delegate lockNotificationNewID:lock.id];
        }
    }
    
    lock.access_token = _accessTokenObject;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if ([item objectForKey:@"avr_update_progress"] != [NSNull null]) {
        lock.avr_update_progress = [item objectForKey:@"avr_update_progress"];
    }
    if ([item objectForKey:@"ble_update_progress"] != [NSNull null]) {
        lock.ble_update_progress = [item objectForKey:@"ble_update_progress"];
    }
    if ([[HMJSONParser parse:item ObjectForKey:@"button_type"] isEqualToString:@"unlock"]) {
        lock.button_type = [NSNumber numberWithInteger:LockitronSDKLockitronBuzzer];
    } else if ([[HMJSONParser parse:item ObjectForKey:@"button_type"] isEqualToString:@"slider"]) {
        lock.button_type = [NSNumber numberWithInteger:LockitronSDKLockitronNew];
    } else if ([[HMJSONParser parse:item ObjectForKey:@"button_type"] isEqualToString:@"lock-unlock"]) {
        lock.button_type = [NSNumber numberWithInteger:LockitronSDKLockitronOld];
    }
    if ([item objectForKey:@"handedness"] != [NSNull null]) {
        lock.handedness = ([[item objectForKey:@"handedness"] isEqualToString:@"unlocked"]) ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    }
    
    for (NSDictionary *itemKey in [item objectForKey:@"keys"])
    {
        [self parseKeyInfofromJSONData:itemKey associatedWithLock:lock];
    } //end of iterating through the keys
    
    lock.name = [item objectForKey:@"name"];
    if ([item objectForKey:@"next_wake"] != [NSNull null]) {
        lock.next_wake = [dateFormatter dateFromString:[item objectForKey:@"next_wake"]];
    }
    //NSLog(@"pending activity:%@", [item objectForKey:@"pending_activity"]);
    //lock.pending_activity = [item objectForKey:@"pending_activity"];
    lock.serial_number = [item objectForKey:@"serial_number"];
    if ([item objectForKey:@"sleep_period"] == [NSNull null]) {
        lock.sleep_period = 0;
    } else {
        lock.sleep_period = [item objectForKey:@"sleep_period"];
    }
    lock.sms = [HMJSONParser parse:item ObjectForKey:@"sms"];
    
    //check for a new lock state and notify the delegate if changed
    NSNumber *newState = [HMJSONParser parse:item ObjectForKey:@"state"];
    if ([newState intValue] != [lock.state intValue]) {
        NSLog(@"Lock:%@ state has changed from %@ to %@. Notifying delegate", lock.id, lock.state, newState);
        lock.state = newState;
        if ([_delegate respondsToSelector:@selector(lockNotificationLock:ChangedLockStateTo:)]) {
            [_delegate lockNotificationLock:lock ChangedLockStateTo:lock.state];
        }
    }//end of lock/unlock check
    lock.time_zone = [item objectForKey:@"time_zone"];
    lock.updated_at = [dateFormatter dateFromString:[item objectForKey:@"updated_at"]];
    
    //check if there is any pending activity
    if ([HMJSONParser parse:item ObjectForKey:@"pending_activity"]) {
        //check if it's an array of multiple activities
        if ([[item objectForKey:@"pending_activity"] isKindOfClass:[NSArray class]]) {
            //iterate through each dictionary in the array and parse it
            for (NSDictionary *pendingActivity in [item objectForKey:@"pending_activity"]) {
                [self parsePendingActivityInfofromJSONdata:pendingActivity associatedWithLock:lock];
            }
        } else { //it must be a dictionary of a single pending activity
            [self parsePendingActivityInfofromJSONdata:[item objectForKey:@"pending_activity"] associatedWithLock:lock];
        }
    } else { //pending activity must be nil/null so delete any pending activities in core data
        lock.pending_activities = nil;
    }
    return lock;
}
- (HMKey *)parseKeyInfofromJSONData:(NSDictionary *)JSONData associatedWithLock:(HMLock *)lock {
    //this will be thee working key that ether holds an exisisting or new CoreData entity
    HMKey *key = [_dataAccessor createNewEntityWithName:@"HMKey"];
    
    BOOL wasFound = NO;
    //NSLog(@"Cycling through the %lu keys in memory", lock.keys.count);
    //get the keys associated with this lock
    for (HMKey *keysAssocatedWithThisLock in lock.keys) {
        if ([[JSONData objectForKey:@"id"] isEqualToString:keysAssocatedWithThisLock.id]) {
            [_dataAccessor deleteEntityObject:key];
            key = keysAssocatedWithThisLock;
            wasFound = YES;
        } else {
        }
    }
    if (!wasFound) {
        NSLog(@"Creating new key since no key matchind id was found");
        key.id = [JSONData objectForKey:@"id"];
    }
    //NSLog(@"associating key with lock");
    key.lock = lock;
    
    if ([JSONData objectForKey:@"expiration_date"] != [NSNull null]) {
        key.expiration_date = [dateFormatter dateFromString:[JSONData objectForKey:@"expiration_date"]];
    }
    if ([JSONData objectForKey:@"role"] != [NSNull null]) {
        if ([[JSONData objectForKey:@"role"] isEqualToString:@"guest"]) {
            key.role = [NSNumber numberWithInteger:LockitronSDKUserGuest];
        } else if ([[JSONData objectForKey:@"role"] isEqualToString:@"owner"]) {
            key.role = [NSNumber numberWithInteger:LockitronSDKUserOwner];
        } else if ([[JSONData objectForKey:@"admin"] isEqualToString:@"admin"]) {
            key.role = [NSNumber numberWithInteger:LockitronSDKUserAdmin];
        }
    }
    if ([JSONData objectForKey:@"sms_pin"] != [NSNull null]) {
        key.sms_pin = [numberFormatter numberFromString:[JSONData objectForKey:@"sms_pin"]];
    }
    if ([JSONData objectForKey:@"start_date"] != [NSNull null]) {
        key.start_date = [dateFormatter dateFromString:[JSONData objectForKey:@"start_date"]];
    }
    key.valid = [JSONData objectForKey:@"valid"];
    key.visible = [JSONData objectForKey:@"visible"];
    
    if ([JSONData objectForKey:@"user"] != nil) {
        [self parseUserInfofromJSONdata:[JSONData objectForKey:@"user"] associatedWithKey:key];
    }
    
    return key;
}
- (HMUser *)parseUserInfofromJSONdata:(NSDictionary *)JSONData associatedWithKey:(HMKey *)key {
    //this will be thee working user that ether holds an exisisting or new CoreData entity
    HMUser *user = [_dataAccessor createNewEntityWithName:@"HMUser"];
    
    BOOL wasFound = NO;
    HMUser *userAssociatedWithKey = key.user;
    if ([userAssociatedWithKey.id isEqualToString:[JSONData objectForKey:@"id"]]) {
        //NSLog(@"User ID from memory matches user id from web");
        [_dataAccessor deleteEntityObject:user];
        user = userAssociatedWithKey;
        wasFound = YES;
    } else {
        //NSLog(@"User ID's don't match");
    }
    if (!wasFound) {
        NSLog(@"creating new user since no locks in memory found matching memory");
        user.id = [JSONData objectForKey:@"id"];
    }
    
    user.activated = [JSONData objectForKey:@"activated"];
    user.avatar_url = [JSONData objectForKey:@"avatar_url"];
    user.changing_email = [JSONData objectForKey:@"changing_email"];
    user.changing_phone = [JSONData objectForKey:@"changing_phone"];
    user.email = [JSONData objectForKey:@"email"];
    user.facebook = [JSONData objectForKey:@"facebook"];
    user.first_name = [JSONData objectForKey:@"first_name"];
    user.full_name = [JSONData objectForKey:@"full_name"];
    user.id = [JSONData objectForKey:@"id"];
    if ([JSONData objectForKey:@"last_name"] != [NSNull null]) {
        user.last_name = JSONData[@"last_name"];
    }
    //    if ([JSONData objectForKey:@"phone"] != [NSNull null]) {
    //        user.phone = [JSONData objectForKey:@"phone"];
    //    }
    user.phone = [HMJSONParser parse:JSONData ObjectForKey:@"phone"];
    user = key.user;
    
    return user;
}
- (HMPendingActivity *)parsePendingActivityInfofromJSONdata:(NSDictionary *)JSONData associatedWithLock:(HMLock *)lock {
    //this will be thee working key that ether holds an exisisting or new CoreData entity
    HMPendingActivity *pendingActivity = [_dataAccessor createNewEntityWithName:@"HMPendingActivity"];
    
    BOOL wasFound = NO;
    //get the keys associated with this lock
    for (HMPendingActivity *pendingActivityAssocatedWithThisLock in lock.pending_activities) {
        if ([[JSONData objectForKey:@"id"] isEqualToString:pendingActivityAssocatedWithThisLock.id]) {
            [_dataAccessor deleteEntityObject:pendingActivity];
            pendingActivity = pendingActivityAssocatedWithThisLock;
            wasFound = YES;
        }
    }
    if (!wasFound) {
        NSLog(@"Creating new pending activity since no pending activity matching id was found");
        pendingActivity.id = [JSONData objectForKey:@"id"];
    }
    //NSLog(@"associating key with lock");
    pendingActivity.lock = lock;
    
    return pendingActivity;
}
- (NSDictionary *)requestLock:(HMLock *)lock {
    return [self lockitronAPIRequestforLocksorUsers:@"locks" withRequestMethod:@"GET" andDirectory:lock.id andAruments:nil];
}
- (void)requestLock:(HMLock *)lock ChangeAttribute:(NSString *)attribute to:(NSString *)changeTo {
    NSLog(@"HMLockitronAPI lock:%@ request %@ change to %@", lock.name, attribute, changeTo);

    [self lockitronAPIRequestforLocksorUsers:@"locks" withRequestMethod:@"PUT" andDirectory:lock.id andAruments:@{attribute : changeTo}];
    NSDictionary *response = [self requestLock:lock];
    [self parseLockInfofromJSONData:response];
    [_dataAccessor save];
}
@end
