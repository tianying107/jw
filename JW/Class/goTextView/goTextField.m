//
//  goTextField.m
//  goTalk
//
//  Created by st chen on 16/7/7.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import "goTextField.h"

@implementation goTextField
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = goColor1;
        [self setFont:goFont15];
        self.tintColor = goColor1;
        self.backgroundColor = [UIColor clearColor];
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColorFromRGB(0xDEDEDE) CGColor];
//        self.layer.cornerRadius = 2;
//        self.clipsToBounds = YES;
        UIView *seperater = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-goSeperatorHeight, self.frame.size.width, goSeperatorHeight)];
        seperater.backgroundColor = goSeparator;
        [self addSubview:seperater];
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 2);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 2);
}
@end
