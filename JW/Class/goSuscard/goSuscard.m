//
//  goSuscard.m
//  goTalk
//
//  Created by st chen on 16/6/15.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import "goSuscard.h"

@implementation goSuscard
@synthesize cardSize, leftButtonFrame, rightButtonFrame;
@synthesize scrollView, cancelButton, cardBackgroundView, backButton, effectView;
- (void)initSuscard{
    hasKeyboard = NO;
    cardArray = [[NSMutableArray alloc] init];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.frame;
    [self addSubview:effectView];
    
    cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardSize.width, cardSize.height)];
    cardBackgroundView.center = self.center;
    
    leftButtonFrame =CGRectMake(cardBackgroundView.frame.origin.x-14, cardBackgroundView.frame.origin.y-14, 36, 36);
    rightButtonFrame =CGRectMake(cardBackgroundView.frame.origin.x+cardBackgroundView.frame.size.width-22, cardBackgroundView.frame.origin.y-14, 36, 36);
    
    [self initCommon];
    cardBackgroundView.layer.cornerRadius = 5;
    cardBackgroundView.clipsToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        cardSize = CGSizeMake(self.frame.size.width-60, self.frame.size.height-140);
        [self initSuscard];
    }
    
    return self;
}

- (void)initCommon{
    cardBackgroundView.backgroundColor = goBackgroundColorExtraLight;
    
    [self addSubview:cardBackgroundView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, cardBackgroundView.frame.size.width, cardBackgroundView.frame.size.height)];
    [cardBackgroundView addSubview:scrollView];
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    [cardArray addObject:scrollView];
    
    cancelButton = [[UIButton alloc] initWithFrame:rightButtonFrame];
    [cancelButton setImage:[UIImage imageNamed:@"cancelButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    backButton = [[UIButton alloc] initWithFrame:leftButtonFrame];
    [backButton setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPreviousCard) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithFrame:(CGRect)frame withCardSize:(CGSize)size keyboard:(BOOL)keyboard {
    self = [super initWithFrame:frame];
    if (self) {
        cardSize = size;
        hasKeyboard = keyboard;
        cardArray = [[NSMutableArray alloc] init];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.frame;
        [self addSubview:effectView];
        
        cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardSize.width, cardSize.height)];
        if (keyboard) {
            cardBackgroundView.center = CGPointMake(self.center.x, frame.size.height-216-cardSize.height/2-50);//(50+cardSize.height/2);
        }
        else{
            cardBackgroundView.center = self.center;
        }
        
        leftButtonFrame =CGRectMake(cardBackgroundView.frame.origin.x-14, cardBackgroundView.frame.origin.y-14, 35, 36);
        rightButtonFrame =CGRectMake(cardBackgroundView.frame.origin.x+cardBackgroundView.frame.size.width-22, cardBackgroundView.frame.origin.y-14, 35, 36);
        
        [self initCommon];
        cardBackgroundView.layer.cornerRadius = 5;
        cardBackgroundView.clipsToBounds = YES;
        
    }
    
    return self;
}
- (id)initWithFullSize {
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    if (self) {
        cardSize = self.frame.size;
        hasKeyboard = NO;
        cardArray = [[NSMutableArray alloc] init];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.frame;
        [self addSubview:effectView];
        
        cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardSize.width, cardSize.height)];
        cardBackgroundView.center = self.center;
        
        leftButtonFrame =CGRectMake(cardBackgroundView.frame.origin.x+21, cardBackgroundView.frame.origin.y+32, 35, 36);
        rightButtonFrame =CGRectMake(cardBackgroundView.frame.origin.x+cardBackgroundView.frame.size.width-56, cardBackgroundView.frame.origin.y+32, 35, 36);
        
        [self initCommon];
        [cancelButton setImage:[UIImage imageNamed:@"cancelClearColor5"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"goBackShort"] forState:UIControlStateNormal];
        backButton.hidden = YES;
        [self addSubview:backButton];
        [backButton addTarget:self action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}
- (void)cancelResponse{
    if (hasKeyboard) {
        NSArray *subviews = [scrollView subviews];
        for (UIView *subview in subviews) {
            [subview resignFirstResponder];
        }
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    self.alpha = 0;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:.258 target:self selector:@selector(removeResponse) userInfo:self repeats:NO];
}
- (void)removeResponse{
    [self removeFromSuperview];
}
- (void)addGoSubview:(UIView *)view{
    [[cardArray lastObject] addSubview:view];
    scrollSize = MAX(scrollSize, view.frame.size.height+view.frame.origin.y);
    [self scrollViewLayout];
}

- (void)setMultiButtonMode:(UIButton*)additionalButton{
    secondButton = additionalButton;
    cancelButton.frame = leftButtonFrame;
    secondButton.frame = rightButtonFrame;
    [self addSubview:secondButton];
}

- (void)pushInOneCard{
    UIScrollView *currentScrollView = [cardArray lastObject];
    UIView *backgroundCardView = [currentScrollView superview];
    UIScrollView *nextScrollView = [[UIScrollView alloc] initWithFrame:currentScrollView.frame];
    [backgroundCardView addSubview:nextScrollView];
    [currentScrollView removeFromSuperview];
    [cardArray addObject:nextScrollView];
    if (cardArray.count == 2) {
        [self addSubview:backButton];
    }
    
}

- (void)resetCard{
    NSArray *subviews = [scrollView subviews];
    for (UIView *view in subviews){
        [view removeFromSuperview];
    }
}

- (void)backPreviousCard{
    UIScrollView *currentScrollView = [cardArray lastObject];
    UIView *backgroundCardView = [currentScrollView superview];
    [cardArray removeLastObject];
    [currentScrollView removeFromSuperview];
    UIScrollView *previousScrollView = [cardArray lastObject];
    [backgroundCardView addSubview:previousScrollView];
    if (cardArray.count == 1) {
        [backButton removeFromSuperview];
    }

}

- (void)whiteButton{
    [cancelButton setImage:[UIImage imageNamed:@"cancelWhite"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"goBackShortWhite"] forState:UIControlStateNormal];
    
}
#pragma mark UIScrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)ascrollView{
    UITextView *textView = [ascrollView viewWithTag:999];
    [textView resignFirstResponder];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    }
- (void)scrollViewLayout{
    [[cardArray lastObject] setContentSize:CGSizeMake(0, scrollSize)];
}
@end
