//
//  ViewController.m
//  TronLock
//
//  Created by Hanlon Miller on 2/22/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "ListofLocksVC.h"
#import "AccessTokenExpiredVC.h"
#import "AppDelegate.h"
#import <DejalActivityView/DejalActivityView.h>
@interface ListOfLocks () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation ListOfLocks {
    AccessTokenExpiredVC *accessTokenExpiredVCInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [HMLockitronManager startWithClientID:@"20f860c33c294c25249e4ff5b11eb973010110018f140c40b2742a17c750ada6" clientSecret:@"30ff4cd039a4d67d77ad8f9052bf9794605a010e85ad2da043bb17e4c54946ee" URIcallback:@"tronlock://uri-callback" delegate:(id<HMLockitronManagerDelegate>)[[UIApplication sharedApplication] delegate]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HMLockitronManager lockList].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMLock *lock = [HMLockitronManager lockList][indexPath.row];
    HMLockNameCell *cell = (HMLockNameCell *)[tableView dequeueReusableCellWithIdentifier:@"LockNameCell"];
    cell.tag = indexPath.row;
    cell.lockNameLabel.text = lock.name;
    [self setCellSegmentedControl:cell.lockStateSegmentedControl BasedOnLockState:lock.state];
    cell.nextWakeLabel.text = [NSString stringWithFormat:@"Awake %@",[self displayFuzzyTimeFromDate:lock.next_wake basedOnTimeZone:lock.time_zone]];
    
    return cell;
}
- (void)setCellSegmentedControl:(UISegmentedControl *)segmentedControl BasedOnLockState:(NSNumber *)lockState {
    segmentedControl.selectedSegmentIndex = [lockState integerValue];
    if (segmentedControl.selectedSegmentIndex == LockitronSDKLockOpen) {
        [segmentedControl setTitle:@"Unlocked" forSegmentAtIndex:LockitronSDKLockOpen];
        [segmentedControl setTitle:@"Lock" forSegmentAtIndex:LockitronSDKLockClosed];
    } else {
        [segmentedControl setTitle:@"Unlock" forSegmentAtIndex:LockitronSDKLockOpen];
        [segmentedControl setTitle:@"Locked" forSegmentAtIndex:LockitronSDKLockClosed];
    }

}
- (void)lockNotificationLock:(HMLock *)lock ChangedLockStateTo:(NSNumber *)changedState {
    [super lockNotificationLock:lock ChangedLockStateTo:changedState];
    
    NSArray *lockList = [HMLockitronManager lockList];
    for (int row = 0; row < lockList.count; row++) {
        HMLock *tempLock = [lockList objectAtIndex:row];
        if ([tempLock.id isEqualToString:lock.id]) {
            HMLockNameCell *cell = (HMLockNameCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [self setCellSegmentedControl:cell.lockStateSegmentedControl BasedOnLockState:lock.state];
        }
    }

}
- (void)refreshAllLocks {
    [self.tableView reloadData];
    [DejalActivityView removeView];
    
}
- (void)showLoginVCbecauseAccessTokenIsExpiredOrNil:(NSString *)expiredOrNil {
    [self.navigationController presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AccessTokenExpiredVC"] animated:YES completion:nil];
    [DejalActivityView activityViewForView:self.view withLabel:@"Loading Locks..."];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
