//
//  goSignUpPhone.m
//  goTalk
//
//  Created by st chen on 16/8/5.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import "goSignUpPhone.h"
@implementation goSignUpPhone
@synthesize phoneTextField,codeTextField;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetup];
    }
    return self;
}
- (void)basicSetup{
    
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-16, 33, 32, 32)];
    logoImageView.image = [UIImage imageNamed:@"logoSmallColor5"];
    [self addSubview:logoImageView];
    requestCode =NO;
    
    float originX = 30, heightCount = 120, weight = self.frame.size.width-2*originX;
    
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 20)];
    heightCount += phoneLabel.frame.size.height+10;
    [self addSubview:phoneLabel];
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 40)];
    heightCount += phoneTextField.frame.size.height;
    
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:phoneTextField];
    separator1 = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, self.frame.size.width-2*originX, goSeperatorHeight)];
    heightCount += separator1.frame.size.height+10;
    [self addSubview:separator1];
    codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 20)];
    heightCount += codeLabel.frame.size.height+10;
    [self addSubview:codeLabel];
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX, heightCount, weight, 40)];
    heightCount += codeTextField.frame.size.height;
    
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:codeTextField];
    separator2 = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, self.frame.size.width-2*originX, goSeperatorHeight)];
    [self addSubview:separator2];
}

- (void)contentWithPhone:(NSString*)phone code:(NSString*)code english:(BOOL)english{
    UIColor *textColor = [UIColor new];
    UIFont *texttFont = [UIFont new];
    verifyButton = [UIButton new];
    UIFont *tittletFont = goFont15B;
    if (english) {
        texttFont = goFont15B;
        textColor = [UIColor whiteColor];
        phoneLabel.text = @"What is your mobile number?";
        codeLabel.text = @"Code";
        [verifyButton setTitle:@"Verification Code" forState:UIControlStateNormal];
        [verifyButton.titleLabel setFont:goFont15B];
        logoImageView.image = [UIImage imageNamed:@"logo"];
        separator1.backgroundColor = goSeparator;
        separator2.backgroundColor = goSeparator;
        phoneTextField.tintColor = [UIColor whiteColor];
        codeTextField.tintColor = [UIColor whiteColor];
        UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, separator2.frame.origin.y+15, separator2.frame.size.width, 60)];
        explanationLabel.text = @"We use your mobile number to send you job\nconfirmations and receipts.";
        explanationLabel.textAlignment = NSTextAlignmentCenter;
        explanationLabel.textColor = [UIColor whiteColor];
        [explanationLabel setFont:goFont13];
        explanationLabel.numberOfLines = 0;
        [self addSubview:explanationLabel];
    }
    else{
        texttFont = goFont15;
        textColor = goColor1;
        phoneLabel.text = @"手机号码";
        codeLabel.text = @"请输入6位验证码";
        [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [verifyButton.titleLabel setFont:goFont13];
        separator1.backgroundColor = goSeparator;
        separator2.backgroundColor = goSeparator;
    }
    phoneLabel.textColor = textColor;
    [phoneLabel setFont:tittletFont];
    phoneTextField.text = phone;
    phoneTextField.textColor = textColor;
    [phoneTextField setFont:texttFont];
    
    codeLabel.textColor = textColor;
    [codeLabel setFont:tittletFont];
    codeTextField.text = code;
    codeTextField.textColor = textColor;
    [codeTextField setFont:texttFont];
    
    
    NSDictionary *attributes = @{NSFontAttributeName: texttFont};
    CGSize stringsize = [verifyButton.titleLabel.text sizeWithAttributes:attributes];
    verifyButton.frame = CGRectMake(self.frame.size.width-30-stringsize.width-20, codeTextField.frame.origin.y, stringsize.width+20, 30);
    [verifyButton setTitleColor:textColor forState:UIControlStateNormal];
    verifyButton.layer.cornerRadius = verifyButton.frame.size.height/2;
    verifyButton.clipsToBounds = YES;
    verifyButton.layer.borderColor = [textColor CGColor];
    verifyButton.layer.borderWidth = 1;
    [self addSubview:verifyButton];
}
- (void)complete{
    [phoneTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
}
@end
