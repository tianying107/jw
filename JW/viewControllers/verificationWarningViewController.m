//
//  verificationWarningViewController.m
//  JW
//
//  Created by Star Chen on 11/19/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import "verificationWarningViewController.h"

@interface verificationWarningViewController ()

@end

@implementation verificationWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_verifyDoneButton addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [_verifySkipButton addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) jump{
    UITabBarController *viewController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabBarViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
