//
//  AppDelegate.m
//  TronLock
//
//  Created by Hanlon Miller on 2/22/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <HMLockitronManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    return YES;
}
- (void)showLoginVCbecauseAccessTokenIsExpiredOrNil:(NSString *)expiredOrNil {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    [(HMLockitronViewController *)[navController visibleViewController] showLoginVCbecauseAccessTokenIsExpiredOrNil:expiredOrNil];

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"tronlock"]) {
        NSArray *queryParams = [[url query] componentsSeparatedByString:@"&"];
        NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
        NSString *codeQuery = [codeParam objectAtIndex:0];
        NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        NSLog(@"My code is %@", code);
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        [HMLockitronManager authenticationCodeReceived:code];
        // Finish the OAuth flow with this code
        return YES;
    }
    
    return NO;
}
//passing the notification on to the visable controller
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    HMLockitronViewController *visableViewController = (HMLockitronViewController *)[navController visibleViewController];
    [visableViewController lockNotificationLock:lock ChangedLockStateTo:changedState];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)refreshAllLocks {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    [(HMLockitronViewController *)[navController visibleViewController] refreshAllLocks];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}
@end
