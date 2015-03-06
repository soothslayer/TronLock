//
//  AccessTokenExpiredVC.m
//  TronLock
//
//  Created by Hanlon Miller on 2/26/15.
//  Copyright (c) 2015 Hanlon Miller Inc. All rights reserved.
//

#import "AccessTokenExpiredVC.h"
#import <HMLockitron/HMLockitron.h>

@interface AccessTokenExpiredVC () <UIPopoverControllerDelegate>

@end

@implementation AccessTokenExpiredVC {
    UIViewController *viewController;
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewController = [[UIViewController alloc] init];
    viewController.view.bounds = self.view.bounds;
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [viewController.view addSubview:webView];
    self.modalPresentationStyle = UIModalTransitionStylePartialCurl;
    [webView loadRequest:[NSURLRequest requestWithURL:[HMLockitronManager provideAuthenticationCodeURL]]];
    // Do any additional setup after loading the view.
}
- (IBAction)presentWebViewButton:(UIButton *)sender {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
