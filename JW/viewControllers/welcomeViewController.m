//
//  welcomeViewController.m
//  JW
//
//  Created by Star Chen on 11/18/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import "welcomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation welcomeViewController
@synthesize emailTextField, passwordTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30-48, self.view.frame.size.height-48-30-216, 48, 48)];
    loginButton.hidden = YES;
    [loginButton setImage:[UIImage imageNamed:@"confirmCircle"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(logInResponse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowUp:) name:UIKeyboardWillShowNotification object:nil];
    passwordTextField.secureTextEntry = YES;
    
//    _fbLoginButton = [[FBSDKLoginButton alloc] init];
    _fbLoginButton.readPermissions =@[@"public_profile",@"email"];
    _fbLoginButton.center = self.view.center;
    _fbLoginButton.delegate = self;
    [self.view addSubview:_fbLoginButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    loginButton.hidden = YES;
}
- (void)keyboardShowUp:(NSNotification *)notification{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    float height = keyboardFrameBeginRect.size.height;
    
    loginButton.frame = CGRectMake(loginButton.frame.origin.x, self.view.frame.size.height-30-loginButton.frame.size.height-height, loginButton.frame.size.width, loginButton.frame.size.height);
    loginButton.hidden = NO;
}
- (void)logInResponse{
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@",emailTextField.text, passwordTextField.text];
    NSLog(@"%@/n",requestBody);
    
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@login",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"server said: %@",string);
                                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:kNilOptions
                                                                                                  error:&error];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self handleSubmit:dic];
                                            });
                                        }];
    [task resume];
}
- (void)fbSignUpWithEmail:(NSString*)emailString imageURL:(NSString*)imageURL name:(NSString*)nameString{
    NSString *requestBody = [NSString stringWithFormat:@"email=%@&avatar=%@&name=%@",emailString, imageURL,nameString];
    NSLog(@"%@/n",requestBody);
    
    /*改上面的 query 和 URLstring 就好了*/
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@fbregister",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            
                                            
                                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:kNilOptions
                                                                                                   error:&error];
                                            NSLog(@"server said: %@",string);
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self handleSubmit:dict];
                                            });
                                        }];
    [task resume];
}
- (void)handleSubmit:(NSDictionary*)dictionary{
    BOOL success = [[dictionary valueForKey:@"success"] boolValue];
    if (success) {
        UITabBarController *viewController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabBarViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
        //        [self updateToken:viewController idString:[[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"]];
    }
    else if ([[dictionary valueForKey:@"message"] isEqualToString:@"You've already registered, please verify your email!"]){
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"verificationWarningPage"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
        NSLog(@"wrong!");
}
- (void)goToWelcome{
    welcomeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginEntryNavi"];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"name, picture, email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *name = [NSString stringWithFormat:@"%@",[result objectForKey:@"name"]];
             NSString *email = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
             NSString *picurl = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
             [self fbSignUpWithEmail:email imageURL:picurl name:name];
//             NSLog(@"email is %@", [result objectForKey:@"email"]);
//             NSLog(@"picture is %@", [result objectForKey:@"picture"]);
//             NSLog(@"token :%@",[FBSDKAccessToken currentAccessToken]);
         }
         else{
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
@end
