//
//  goSignUpPhone.h
//  goTalk
//
//  Created by st chen on 16/8/5.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class goSignUpPhone;
@interface goSignUpPhone : UIView<UITextFieldDelegate>{
    UILabel *phoneLabel;
    UILabel *codeLabel;
    BOOL requestCode;
    UIImageView *logoImageView;
    UIView *separator1;
    UIView *separator2;
    UIButton *verifyButton;
}
- (void)contentWithPhone:(NSString*)phone code:(NSString*)code english:(BOOL)english;
- (void)complete;
@property UITextField *phoneTextField;
@property UITextField *codeTextField;
@end
