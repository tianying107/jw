//
//  goPriceSlider.m
//  goTalk
//
//  Created by ual-laptop on 8/7/16.
//  Copyright © 2016 st chen. All rights reserved.
//

#import "goPriceSlider.h"

@implementation goPriceSlider
@synthesize priceSlider, price2Slider, delegate;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicSetup];
    }
    return self;
}
- (void)basicSetup{
    [self setUserInteractionEnabled:YES];
    _priceInteger = 200;
    _priceString = [NSString stringWithFormat:@"%ld",_priceInteger];
    UIImageView *sliderTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14+25-6.5, self.frame.size.width-30, 13)];
    sliderTrackImageView.image = [UIImage imageNamed:@"sliderTrackImage"];
    [self addSubview:sliderTrackImageView];
    for (int i = 0; i<5; i++) {
        UILabel *sliderIndicater = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        sliderIndicater.text = [NSString stringWithFormat:@"%d",100+i*50];
        sliderIndicater.textAlignment = NSTextAlignmentCenter;
        sliderIndicater.textColor = goColor1;
        [sliderIndicater setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:10]];
        sliderIndicater.center = CGPointMake(20+i*(sliderTrackImageView.frame.size.width-10)/4, sliderIndicater.center.y);
        [self addSubview:sliderIndicater];
    }
    priceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 14, self.frame.size.width, 50)];
    priceSlider.userInteractionEnabled = YES;
    [self addSubview:priceSlider];
    [priceSlider setMinimumValue:100];
    [priceSlider setMaximumValue:300];
    [priceSlider setValue:_priceInteger];
    [priceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [priceSlider setThumbImage:[UIImage imageNamed:@"sliderThumbImage"] forState:UIControlStateNormal];
    [priceSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [priceSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, priceSlider.frame.size.height+priceSlider.frame.origin.y);
}
- (void)setPriceWithString:(NSString*)priceString{
    if (priceString) {
        _priceString = priceString;
        _priceInteger = [_priceString integerValue];
        [priceSlider setValue:_priceInteger];
    }
}
- (void)setPriceWithInteger:(NSInteger)priceInteger{
    _priceInteger = priceInteger;
    _priceString = [NSString stringWithFormat:@"%ld",_priceInteger];
    [priceSlider setValue:_priceInteger];
}
- (IBAction)sliderValueChanged:(id)sender{
//    UISlider *priceSlider = sender;
    if (priceSlider.value<125) {
        [priceSlider setValue:100];
    }
    else if (priceSlider.value>=125 && priceSlider.value<175){
        [priceSlider setValue:150];
    }
    else if (priceSlider.value>=175 && priceSlider.value<225){
        [priceSlider setValue:200];
    }
    else if (priceSlider.value>=225 && priceSlider.value<275){
        [priceSlider setValue:250];
    }
    else{
        [priceSlider setValue:300];
    }
    NSLog(@"%lf",priceSlider.value);
    _priceInteger = (NSInteger)priceSlider.value;
    _priceString = [NSString stringWithFormat:@"%.f",priceSlider.value];
}

/*******************************NEW VERSION SLIDER**************************************/
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        _sliderType = type;
        switch (_sliderType) {
            case goPriceSliderSingle:
                [self singleSliderSetup];
                break;
            case goPriceSliderDouble:
                [self doubleSliderSetup];
                break;
            case goPriceSliderSingleColor5:
                [self singleSliderSetup];
                break;
                
            default:
                break;
        }
    }
    return self;
}
- (void)singleSliderSetup{
    _priceInteger = 400;
    _priceString = @"400";
    _price2Integer = 1000;
    UIImageView *sliderTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14+25-6.5, self.frame.size.width-30, 13)];
    sliderTrackImageView.image = [UIImage imageNamed:@"sliderTrackImage2"];
    sliderTrackImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:sliderTrackImageView];
    for (int i = 0; i<19; i++) {
        UILabel *sliderIndicater = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        sliderIndicater.text = [NSString stringWithFormat:@"￥%d",100+i*50];
        sliderIndicater.textAlignment = NSTextAlignmentCenter;
        sliderIndicater.textColor = goColor1;
        [sliderIndicater setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:10]];
        sliderIndicater.center = CGPointMake(15+i*(sliderTrackImageView.frame.size.width-10)/18, sliderIndicater.center.y);
        if (_sliderType == goPriceSliderSingleColor5) {
            sliderIndicater.textColor = [UIColor whiteColor];
            [sliderIndicater setFont:[UIFont fontWithName:@"SFUIDisplay-Bold" size:13]];
        }
        sliderIndicater.tag = 500+i;
        if (i!=(_priceInteger-100)/50) sliderIndicater.hidden=YES;
        [self addSubview:sliderIndicater];
    }
    priceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 14, self.frame.size.width, 50)];
    priceSlider.userInteractionEnabled = YES;
    [self addSubview:priceSlider];
    [priceSlider setMinimumValue:100];
    [priceSlider setMaximumValue:1000];
    [priceSlider setValue:_priceInteger];
    [priceSlider addTarget:self action:@selector(slider1ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [priceSlider setThumbImage:[UIImage imageNamed:@"sliderThumbImage"] forState:UIControlStateNormal];
    [priceSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [priceSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    priceSlider.tag = 1;
    if (_sliderType == goPriceSliderSingleColor5) {
        [priceSlider setThumbImage:[UIImage imageNamed:@"sliderThumbImageWhite"] forState:UIControlStateNormal];
    }
}
- (void)doubleSliderSetup{
    _priceInteger = 100;
    _price2Integer = 1000;
    UIImageView *sliderTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14+25-6.5, self.frame.size.width-20, 13)];
    sliderTrackImageView.image = [UIImage imageNamed:@"sliderTrackImage2"];
    [self addSubview:sliderTrackImageView];
    
    rangeSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(10, 14+25-6.5, self.frame.size.width-20, 13) withLower:100 upper:1000];
    rangeSlider.minimumValue=100;
    rangeSlider.maximumValue = 1000;
    rangeSlider.lowerValue = _priceInteger;
    rangeSlider.upperValue = _price2Integer;
    rangeSlider.minimumRange=50;
    rangeSlider.stepValueContinuously = NO;
    rangeSlider.stepValue = 50;
    [rangeSlider addTarget:self action:@selector(slider2ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:rangeSlider];
    
    lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [lowerLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:10]];
    lowerLabel.textColor = goColor1;
    [self addSubview:lowerLabel];
    upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [upperLabel setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:10]];
    upperLabel.textColor = goColor1;
    [self addSubview:upperLabel];
    for (int i = 0; i<2; i++) {
        UILabel *sliderIndicater = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        sliderIndicater.text = [NSString stringWithFormat:@"%d",100+i*900];
        sliderIndicater.tag = 30+i;
        sliderIndicater.textAlignment = NSTextAlignmentCenter;
        sliderIndicater.textColor = goColor1;
        [sliderIndicater setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:10]];
        sliderIndicater.center = CGPointMake(20+i*(sliderTrackImageView.frame.size.width-10), sliderIndicater.center.y);
        [self addSubview:sliderIndicater];
    }
}
- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (rangeSlider.lowerCenter.x + rangeSlider.frame.origin.x+5);
    lowerCenter.y = (rangeSlider.center.y - 30.0f);
    lowerLabel.center = lowerCenter;
    lowerLabel.text = [NSString stringWithFormat:@"%d", (int)rangeSlider.lowerValue];
    if (rangeSlider.lowerValue<150) {
        lowerLabel.hidden = YES;
        [[self viewWithTag:30] setHidden:NO];
    }
    else{
        [[self viewWithTag:30] setHidden:YES];
        lowerLabel.hidden = NO;
    }
    
    CGPoint upperCenter;
    upperCenter.x = (rangeSlider.upperCenter.x + rangeSlider.frame.origin.x+5);
    upperCenter.y = (rangeSlider.center.y - 30.0f);
    upperLabel.center = upperCenter;
    upperLabel.text = [NSString stringWithFormat:@"%d", (int)rangeSlider.upperValue];
    if (rangeSlider.upperValue>950) {
        upperLabel.hidden = YES;
        [[self viewWithTag:31] setHidden:NO];
    }
    else {
        upperLabel.hidden = NO;
        [[self viewWithTag:31] setHidden:YES];
    }
}


- (IBAction)slider1ValueChanged:(id)sender{
    if ([sender isEqual:priceSlider]) {
        if (priceSlider.value<125) {
            [priceSlider setValue:100];
        }
        else if (priceSlider.value>=125 && priceSlider.value<175){
            [priceSlider setValue:150];
        }
        else if (priceSlider.value>=175 && priceSlider.value<225){
            [priceSlider setValue:200];
        }
        else if (priceSlider.value>=225 && priceSlider.value<275){
            [priceSlider setValue:250];
        }
        else if (priceSlider.value>=275 && priceSlider.value<325){
            [priceSlider setValue:300];
        }
        else if (priceSlider.value>=325 && priceSlider.value<375){
            [priceSlider setValue:350];
        }
        else if (priceSlider.value>=375 && priceSlider.value<425){
            [priceSlider setValue:400];
        }
        else if (priceSlider.value>=425 && priceSlider.value<475){
            [priceSlider setValue:450];
        }
        else if (priceSlider.value>=475 && priceSlider.value<525){
            [priceSlider setValue:500];
        }
        else if (priceSlider.value>=525 && priceSlider.value<575){
            [priceSlider setValue:550];
        }
        else if (priceSlider.value>=575 && priceSlider.value<625){
            [priceSlider setValue:600];
        }
        else if (priceSlider.value>=625 && priceSlider.value<675){
            [priceSlider setValue:650];
        }
        else if (priceSlider.value>=675 && priceSlider.value<725){
            [priceSlider setValue:700];
        }
        else if (priceSlider.value>=725 && priceSlider.value<775){
            [priceSlider setValue:750];
        }
        else if (priceSlider.value>=775 && priceSlider.value<825){
            [priceSlider setValue:800];
        }
        else if (priceSlider.value>=825 && priceSlider.value<875){
            [priceSlider setValue:850];
        }
        else if (priceSlider.value>=875 && priceSlider.value<925){
            [priceSlider setValue:900];
        }
        else if (priceSlider.value>=925 && priceSlider.value<975){
            [priceSlider setValue:950];
        }
        else{
            [priceSlider setValue:1000];
        }
        if (_priceInteger != (int)priceSlider.value) {
            _priceInteger = (int)priceSlider.value;
            _priceString = [NSString stringWithFormat:@"%ld",_priceInteger];
            [self.delegate priceSlider:priceSlider priceChangeToValue:_priceInteger];
        }
        
    }
    else if ([sender isEqual:price2Slider]){
        if (price2Slider.value<125) {
            [price2Slider setValue:100];
        }
        else if (price2Slider.value>=125 && price2Slider.value<175){
            [price2Slider setValue:150];
        }
        else if (price2Slider.value>=175 && price2Slider.value<225){
            [price2Slider setValue:200];
        }
        else if (price2Slider.value>=225 && price2Slider.value<275){
            [price2Slider setValue:250];
        }
        else if (price2Slider.value>=275 && price2Slider.value<325){
            [price2Slider setValue:300];
        }
        else if (price2Slider.value>=325 && price2Slider.value<375){
            [price2Slider setValue:350];
        }
        else if (price2Slider.value>=375 && price2Slider.value<425){
            [price2Slider setValue:400];
        }
        else if (price2Slider.value>=425 && price2Slider.value<475){
            [price2Slider setValue:450];
        }
        else if (price2Slider.value>=475 && price2Slider.value<525){
            [price2Slider setValue:500];
        }
        else if (price2Slider.value>=525 && price2Slider.value<575){
            [price2Slider setValue:550];
        }
        else if (price2Slider.value>=575 && price2Slider.value<625){
            [price2Slider setValue:600];
        }
        else if (price2Slider.value>=625 && price2Slider.value<675){
            [price2Slider setValue:650];
        }
        else if (price2Slider.value>=675 && price2Slider.value<725){
            [price2Slider setValue:700];
        }
        else if (price2Slider.value>=725 && price2Slider.value<775){
            [price2Slider setValue:750];
        }
        else if (price2Slider.value>=775 && price2Slider.value<825){
            [price2Slider setValue:800];
        }
        else if (price2Slider.value>=825 && price2Slider.value<875){
            [price2Slider setValue:850];
        }
        else if (price2Slider.value>=875 && price2Slider.value<925){
            [price2Slider setValue:900];
        }
        else if (price2Slider.value>=925 && price2Slider.value<975){
            [price2Slider setValue:950];
        }
        else{
            [price2Slider setValue:1000];
        }
        if (_price2Integer != (int)price2Slider.value) {
            _price2Integer = (int)price2Slider.value;
            [self.delegate priceSlider:price2Slider priceChangeToValue:_price2Integer];
        }
        
    }
    for (int i = 0; i<19; i++) {
        UILabel *indicater = [self viewWithTag:500+i];
        if (i==(_priceInteger-100)/50) {// || i==(_price2Integer-100)/50
            indicater.hidden = NO;
        }
        else indicater.hidden = YES;
    }
    
}
- (IBAction)slider2ValueChanged:(NMRangeSlider*)sender{
    _priceInteger = sender.lowerValue;
    _price2Integer = sender.upperValue;
    [self updateSliderLabels];
    [self.delegate lowerPriceChangeToValue:_priceInteger upperToValue:_price2Integer];
}
@end
