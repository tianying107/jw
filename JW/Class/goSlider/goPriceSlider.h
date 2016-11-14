//
//  goPriceSlider.h
//  goTalk
//
//  Created by ual-laptop on 8/7/16.
//  Copyright © 2016 st chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "NMRangeSlider.h"
#define goPriceSliderSingle 331
#define goPriceSliderDouble 332
#define goPriceSliderSingleColor5 333
@class goPriceSlider;
@protocol goPriceSliderDelegate <NSObject>

- (void)priceSlider:(UISlider*)slider priceChangeToValue:(NSInteger)price;
- (void)lowerPriceChangeToValue:(NSInteger)lowerPrice upperToValue:(NSInteger)upperPrice;

@end
@interface goPriceSlider : UIView{
    UILabel *lowerLabel;
    UILabel *upperLabel;
    NMRangeSlider *rangeSlider;

}
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;

- (void)setPriceWithString:(NSString*)priceString;
- (void)setPriceWithInteger:(NSInteger)priceInteger;
@property (nonatomic, weak) id <goPriceSliderDelegate> delegate;
@property UISlider *priceSlider;
@property UISlider *price2Slider;
@property NSString *priceString;
@property NSInteger priceInteger;
@property NSInteger price2Integer;

@property NSInteger sliderType;
@end
