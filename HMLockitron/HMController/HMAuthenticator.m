//
//  HMAuthenticator.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HMAuthenticator.h"
#import "HMLockitronManager.h"
#import "HMDataAccessor.h"
#import "HMAccessToken.h"
#import "HMLockitronAPI.h"

@interface HMAuthenticator ()
@property (strong) NSString *URIcallback;
@property (strong) HMDataAccessor *dataAccessor;
@end

@implementation HMAuthenticator {
    NSOperationQueue *_queue;
    NSUserDefaults *_sharedDefaults;
    NSURL *url;
}

- (id)initWithURIcallback:(NSString *)URIcallback {
    self = [super init];
    _queue = [NSOperationQueue new];
    _sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:[NSString stringWithFormat:@"%@", suiteName]];
    _URIcallback = URIcallback;
    _dataAccessor = [HMDataAccessor new];
    //NSLog(@"data accessor in auuthenticator is:%@", _dataAccessor);
    return self;
}

- (void)checkIfAccessTokenIsExpiredOrNil {
    NSArray *accessTokensInCoreData = [_dataAccessor fetchEntitiesWithName:@"HMAccessToken"];
    if (accessTokensInCoreData.count == 0) {
        NSLog(@"No access token ffound in memeory. Creating a new one");
        _accessTokenObject = [_dataAccessor createNewEntityWithName:@"HMAccessToken"];
    } else {
        _accessTokenObject = accessTokensInCoreData[0];
        //NSLog(@"access token found in memory:%@", _accessTokenObject);
    }
    //first check to see if the access Token from DataAccessor is not nil and not expired
    //NSLog(@"expiration date:%@ today's date:%@", _accessTokenObject.expiration_date, [NSDate date]);
    NSComparisonResult result = [_accessTokenObject.expiration_date compare:[NSDate date]];
    
    if (result == NSOrderedAscending || result == NSOrderedSame)
    {
        NSLog(@"Access token expired");
        _accessTokenObject.access_token = nil;
        if ([_delegate respondsToSelector:@selector(accessTokenIsExpiredOrNil:)]) {
            [_delegate accessTokenIsExpiredOrNil:@"expired"];
        }
    } else if (_accessTokenObject == nil) {
        NSLog(@"access Token is nil");
        if ([_delegate respondsToSelector:@selector(accessTokenIsExpiredOrNil:)]) {
            [_delegate accessTokenIsExpiredOrNil:@"nil"];
        }
    } else {
        NSLog(@"access token is not expired or null.. Sending authentication is done.");
        [_delegate accessTokenIsValid];
    }
}
- (void)startAuthentication {
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/authorize?client_id=%@&response_type=code&redirect_uri=%@", lockitronURL, _clientID, _URIcallback]];
    NSLog(@"Access token is nil. Requesting one from:%@", url);
    [[UIApplication sharedApplication] openURL:url];

}
- (NSURL *)generateAuthenticationCodeURL {
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/authorize?client_id=%@&response_type=code&redirect_uri=%@", lockitronURL, _clientID, _URIcallback]];
    NSLog(@"Access token is nil. Requesting one from:%@", url);
    return url;
    
}
- (void)authenticationCodeReceived:(NSString *)code {
    NSLog(@"Authentication code:%@ received by HMLockitronAccount. Requesting accessToken", code);
    NSString *urlString = [NSString stringWithFormat:@"%@oauth/token?client_id=%@&client_secret=%@&code=%@&grant_type=authorization_code&redirect_uri=%@", lockitronURL, _clientID, _clientSecret, code, _URIcallback];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [urlRequest setHTTPMethod:@"POST"];
    NSOperationQueue *quere = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:quere completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"Raw JSON:%@", JSON);
        if ([JSON objectForKey:@"access_token"]) {

            _accessTokenObject.access_token = [JSON objectForKey:@"access_token"];
            NSLog(@"Setting access token to:%@", _accessTokenObject.access_token);
            _accessTokenObject.expiration_date = [NSDate dateWithTimeIntervalSinceNow:7776000];
            if (_accessTokenObject) {
                NSLog(@"accessTokenObject:%@ is not nil", _accessTokenObject);
            } else {
                NSLog(@"access tokenObject:%@ is nil", _accessTokenObject);
            }
            [_dataAccessor save];
            NSLog(@"affer save accessToken In memory:%@", [_dataAccessor fetchEntitiesWithName:@"HMAccessToken"]);
        if ([_delegate respondsToSelector:@selector(accessTokenIsValid)]) {
            NSLog(@"HMAuthenticator sending authenticator is done");
            [_delegate accessTokenIsValid];
        } 
        } else {
            NSLog(@"Not able to obtain access_token from website");
        }

    }];
    
}

@end
