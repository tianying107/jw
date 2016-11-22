//
//  accountViewController.m
//  JW
//
//  Created by Star Chen on 11/19/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import "accountViewController.h"

@interface accountViewController ()

@end

@implementation accountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 30)];
    [logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [logoutButton setTitleColor:goColor1 forState:UIControlStateNormal];
    [logoutButton.titleLabel setFont:goFont15];
    [logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logOut{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    welcomeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginEntryNavi"];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
