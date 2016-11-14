//
//  launchScreenViewController.m
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import "launchScreenViewController.h"

@interface launchScreenViewController ()

@end

@implementation launchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"]) {
        [self logInWithID:[[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"] password:[[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"password"]];
    }
    else{
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginEntryNavi"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)logInWithID:(NSString*)MEID password:(NSString*)password{
    if (!([MEID isEqualToString:@""]||[password isEqualToString:@""])) {
        NSString *requestBody = [NSString stringWithFormat:@"id=%@&password=%@",MEID, password];
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
    
}
- (void)handleSubmit:(NSDictionary*)dictionary{
    BOOL success = [[dictionary valueForKey:@"success"] boolValue];
    if (success) {
        UITabBarController *viewController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabBarViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
//        [self updateToken:viewController idString:[[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"admin"] valueForKey:@"id"]];
    }
    else{
        NSLog(@"Authen FAILED");
    }
}
- (void) updateToken:(UITabBarController*)viewController idString:(NSString*)idString;{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fileName = @"deviceToken";
    NSString *filePath =[docPath stringByAppendingPathComponent:fileName];
    NSString *tokenString = [[NSString alloc] init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        tokenString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    }
    
    NSString *requestBody = [NSString stringWithFormat:@"token=%@&id=%@",tokenString,idString];
    NSLog(@"%@/n",requestBody);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@updatetoken",basicURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                            NSLog(@"update token: %@",string);
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self presentViewController:viewController animated:YES completion:nil];
                                            });
                                        }];
    [task resume];
}
@end
