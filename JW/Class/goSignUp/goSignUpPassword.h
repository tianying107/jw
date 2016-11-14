//
//  goSignUpPassword.h
//  goTalk
//
//  Created by st chen on 16/8/5.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class goSignUpPassword;
@interface goSignUpPassword : UIView<UITextFieldDelegate>{
    UILabel *label1;
    UILabel *label2;
    UIImageView *logoImageView;
    UIView *separator1;
    UIView *separator2;
    UIButton *showButton;
}
- (void)contentWithPassword:(NSString*)password english:(BOOL)english;
- (void)complete;
@property UITextField *textField1;
@property UITextField *textField2;

@end
