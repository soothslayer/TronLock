//
//  HMLockNameCell.m
//  TronLock
//
//  Created by Hanlon Miller on 3/2/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "HMLockNameCell.h"

@implementation HMLockNameCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)lockStateSegmentDidTouch:(UISegmentedControl *)sender {
    NSLog(@"touched segment:%lu", sender.selectedSegmentIndex);
    HMLock *lock = (HMLock *)[HMLockitronManager lockList][self.tag];
    [lock changeLockStateTo:[NSNumber numberWithInteger:sender.selectedSegmentIndex]];
}

- (IBAction)lockStateSegmentDidChange:(UISegmentedControl *)sender {
    NSLog(@"segment changed to:%lu", sender.selectedSegmentIndex);
    HMLock *lock = (HMLock *)[HMLockitronManager lockList][self.tag];
    [lock changeLockStateTo:[NSNumber numberWithInteger:sender.selectedSegmentIndex]];
}
@end
