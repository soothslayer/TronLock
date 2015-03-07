//
//  HMLockitronManager.m
//  TronLock
//
//  Created by Hanlon Miller on 2/23/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "HMLockitronManager.h"
#import "HMLockitron.h"
#import "HMAuthenticator.h"
#import "HMAccessToken.h"
#import "HMDataAccessor.h"
#import "HMLock.h"
#import "HMKey.h"
#import "HMUser.h"
#import "HMDataAccessor.h"
#import "HMJSONParser.h"
#import "HMLockitronAPI.h"

@interface HMLockitronManager () <HMAuthenticatorDelegate, HMLockitronAPIDelegate>

@property (strong) HMAuthenticator *authenticator;
@property (strong) HMDataAccessor *dataAccessor;
@property (strong) NSOperationQueue *queue;
@property (assign) BOOL isReady;
@property (weak) id<HMLockitronManagerDelegate> delegate;
//@property (strong) NSArray *locksStoredInCoreData;
//@property (strong) LTUser *user;
@property (strong) HMUser *user;
@property (strong) NSUserDefaults *sharedDefaults;
//@property (copy) id JSONdata;
@property NSString *clientID;
@property NSString *URIcallback;
@property NSString *clientSecret;
@property HMAccessToken *accessTokenObject;
@property HMLockitronAPI *lockitronAPIinstance;

@end

@implementation HMLockitronManager {
    NSDateFormatter *dateFormatter;
}

static HMLockitronManager *_instance = nil;

//set up authenticator and dataacessor and then start authentication
+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret URIcallback:(NSString *)URIcallback delegate:(id<HMLockitronManagerDelegate>)delegate {
    if (_instance == nil)
    {
        _instance = [HMLockitronManager new];
        
        //creating new instances of HMDataAccessor and Auuthenticator
        HMDataAccessor *dataAccessor = [HMDataAccessor new];
        _instance.dataAccessor = dataAccessor;
        HMAuthenticator *authenticator = [[HMAuthenticator alloc] initWithURIcallback:URIcallback];
        authenticator.clientID = clientID;
        authenticator.clientSecret = clientSecret;
        _instance.authenticator = authenticator;
        _instance.authenticator.delegate = _instance;
        HMLockitronAPI *lockitronAPIinstance = [HMLockitronAPI new];
        _instance.lockitronAPIinstance = lockitronAPIinstance;
        _instance.lockitronAPIinstance.delegate = _instance;
        _instance.delegate = delegate;
    }
    NSLog(@"Client is starting");
    NSLog(@"HMLockitronAccount:Checking if access Token is Epired Or NIL");
    [_instance.authenticator checkIfAccessTokenIsExpiredOrNil];
}

//authentication is done, either because access token was reteived from memory and was valid or was recently downloaded from the web
- (void)accessTokenIsValid {
    #pragma You should think about having only one instance pull and save the access token from/to memory
    
    //pull the access token from memory
    NSArray *accessTokensInMemory = [_dataAccessor fetchEntitiesWithName:@"HMAccessToken"];
    _accessTokenObject = accessTokensInMemory[0];
    NSLog(@"accessToken is valid and was received from memory:%@", _accessTokenObject);
    
    //load it into LockitronAPI
    [self loadAllLocksFromLockitronAPI];
    [_delegate refreshAllLocks];
}
- (void)accessTokenIsExpiredOrNil:(NSString *)expiredOrNil {
    [_delegate showLoginVCbecauseAccessTokenIsExpiredOrNil:expiredOrNil];
}
- (NSArray *)loadAllLocksFromCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"HMLock"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    return [_dataAccessor fetchEntitiesUsingFetchRequest:fetchRequest];
}
- (void)loadAllLocksFromLockitronAPI {
    #pragma It would be better if you requested all locks async and then had a seperate call for response
    id JSONresponseAllLocks = [_lockitronAPIinstance requestAllLocksFromLockitronAPI];
    [_lockitronAPIinstance parseAllLocksFromJSON:JSONresponseAllLocks];
}
+ (void)requestLock:(HMLock *)lock ChangeAttribute:(NSString *)attribute to:(NSString *)changeTo {
    NSLog(@"HMLockitronManager lock:%@ request %@ change to %@", lock.name, attribute, changeTo);
    [_instance.lockitronAPIinstance requestLock:lock ChangeAttribute:attribute to:changeTo];
}
//HMLockitronAPI Delegate Methods that need to be forwarded to HMLockitronManager's Delegate
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState {
    [_delegate lockNotificationLock:lock ChangedLockStateTo:changedState];
}
+ (NSArray *)lockList {
    return [_instance loadAllLocksFromCoreData];
}
+ (NSURL *)provideAuthenticationCodeURL {
    return [_instance.authenticator generateAuthenticationCodeURL];
}
+ (void)authenticationCodeReceived:(NSString *)code {
    [_instance.authenticator authenticationCodeReceived:code];
}
+ (void)refreshLocks {
    [_instance loadAllLocksFromLockitronAPI];
}
@end
