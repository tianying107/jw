//
//  welcomeViewController.h
//  JW
//
//  Created by Star Chen on 11/18/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface welcomeViewController : UIViewController<UITextFieldDelegate,FBSDKLoginButtonDelegate>{
    UIButton *loginButton;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;

@end
