//
//  newShareViewController.h
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "FSCalendar.h"
#import "goPriceSlider.h"
@interface newShareViewController : UIViewController<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate,FSCalendarDelegate, FSCalendarDataSource,goPriceSliderDelegate>{
    UIScrollView *mainScrollView;
    UIView *repeatBackgroundView;
    NSInteger lastRepeatTime;
    UIView *priceBackgroundView;
    NSInteger hours;
    NSInteger times;
    UIPickerView *hourPicker;
    UILabel *locationTitleLabel;
    UIView *locationBackgroundView;
    UIView *stageBackgroundView;
    UIView *categoryBackgroundView;
    UIView *messageBackgroundView;
    goPinMap *mapView;
    UIPickerView *stagePicker;
    NSArray *stageArray;
    UIView *policyBackgroundView;
    UIButton *submitButton;
    NSArray *categoryArray;
    UIPickerView *categoryPicker;
    NSArray *subcategoryArray;
    UIPickerView *subcategoryPicker;
    BOOL keyboardState;
    float offsetKeyboard;
    UIView *quickMatchBackgroundView;
    UIView *priceRateBackgroundView;
    NSString *MEID;
    UIButton *sessionDetailButton;
    goSuscard *currentSuscard;
    NSString *cateString;
    NSString *subcateString;
    FSCalendar *acalendar;
    
}

@property NSMutableDictionary *orderSummary;
//@property NSMutableArray *locationArray;
@property MKMapItem *locationItem;
@property NSString *priceString;

@end
