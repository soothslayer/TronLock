//
//  HMLockNameCell.h
//  TronLock
//
//  Created by Hanlon Miller on 3/2/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMLockitron/HMLockitron.h>

@interface HMLockNameCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lockNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nextWakeLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *lockStateSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *pendingCommandLabel;
- (IBAction)lockStateSegmentDidTouch:(UISegmentedControl *)sender;
- (IBAction)lockStateSegmentDidChange:(UISegmentedControl *)sender;
@end