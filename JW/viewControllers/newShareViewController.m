//
//  newShareViewController.m
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import "newShareViewController.h"

@interface newShareViewController ()

@end

@implementation newShareViewController
- (void)viewDidLoad{
    //    self.navigationItem.title = @"发布";
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+50)];
    mainScrollView.backgroundColor = goBackgroundColorExtraLight;
    [self.view addSubview:mainScrollView];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];//-self.navigationController.navigationBar.frame.size.height-20
    effectView.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
    [self.view insertSubview:effectView atIndex:50];
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fileName = @"stdAuthorization";
    NSString *filePath =[docPath stringByAppendingPathComponent:fileName];
    MEID = [[NSString alloc] init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        MEID = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    }
    
    _orderSummary = [NSMutableDictionary dictionaryWithObjectsAndKeys:MEID, @"MEID", @"1", @"Repeat Times", nil];
    times = 1;
    hours = 1;
    keyboardState = NO;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [self initBaseView];
    
    [center addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 32, 32);
    [backBtn setImage:[UIImage imageNamed:@"goBackWithoutBackground"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //submit&price
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*.4, [[UIScreen mainScreen] bounds].size.height-60, self.view.frame.size.width*.6, 60)];
    submitButton.backgroundColor = goColor5;
    [submitButton setTitle:@"发布" forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:goFont18M];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(priceExpendResponse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    priceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-60, self.view.frame.size.width*.4, 60)];
    priceBackgroundView.clipsToBounds = YES;
    priceBackgroundView.backgroundColor = goColor4;
    CALayer *layer = priceBackgroundView.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(2, 0);
    layer.shadowColor = [[UIColor grayColor] CGColor];
    layer.shadowRadius = 1;
    layer.shadowOpacity = .50f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    [self.view addSubview:priceBackgroundView];
    
    [self dateResponse];
}
- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    mainScrollView.delegate=self;
    self.tabBarController.tabBar.hidden = YES;
    [self scrollViewDidScroll:mainScrollView];
    //map
    if (_locationItem != nil) {
        locationBackgroundView.frame = CGRectMake(0, locationBackgroundView.frame.origin.y, mainScrollView.frame.size.width, 240);
        [self originUpdate];
        mapView.frame = CGRectMake(0, 40, locationBackgroundView.frame.size.width, locationBackgroundView.frame.size.height-40);
        [mapView showStoreWithItem:_locationItem];
        mapView.scrollEnabled = NO;
        mapView.zoomEnabled = NO;
        mapView.hidden = NO;
        
        
        UIButton *locationButton = [locationBackgroundView viewWithTag:9029];
        locationButton.selected = YES;
        locationButton.frame = CGRectMake(0, 0, locationBackgroundView.frame.size.width, locationBackgroundView.frame.size.height);
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_locationItem.placemark.location.coordinate.latitude], @"Latitude",[NSString stringWithFormat:@"%f",_locationItem.placemark.location.coordinate.longitude], @"Longitude",[_locationItem name], @"loc_name", nil];
        [_orderSummary addEntriesFromDictionary:dict];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    mainScrollView.delegate=nil;
}
-(void) viewDidAppear:(BOOL)animated{
    [mainScrollView setScrollEnabled:YES];
    //    mainScrollView.contentSize = CGSizeMake(0, 1000);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<offsetKeyboard-30 && keyboardState && scrollView == mainScrollView) {
        UITextView *messageTextView = [messageBackgroundView viewWithTag:9028];
        [messageTextView resignFirstResponder];
        keyboardState = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [self originUpdate];
        [UIView commitAnimations];
    }
}

- (void)initBaseView{
    
    float heightCount = 20;
    float originX = 20;
    float height = 80;
    float width = mainScrollView.frame.size.width-2*originX;
    
    //date
    UILabel *dateFixedLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, heightCount, 10, 20)];
    dateFixedLabel.text = @"日期";
    dateFixedLabel.textColor = goColor1;
    [dateFixedLabel setFont:goFont15];
    [dateFixedLabel sizeToFit];
    heightCount += dateFixedLabel.frame.size.height;
    [mainScrollView addSubview:dateFixedLabel];
    
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(originX+dateFixedLabel.frame.size.width, heightCount, width, 50)];
    heightCount += dateButton.frame.size.height;
    [dateButton setTitle:@"请选择日期" forState:UIControlStateNormal];
    [dateButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [dateButton setTitleColor:goColor1 forState:UIControlStateSelected];
    [dateButton addTarget:self action:@selector(dateResponse) forControlEvents:UIControlEventTouchUpInside];
    [dateButton.titleLabel setFont:goFont30T];
    dateButton.tag = 9004;
    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [mainScrollView addSubview:dateButton];
    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake(originX, dateButton.frame.origin.y+dateButton.frame.size.height, width, 1)];
    seperator1.backgroundColor = goSeparator;
    [mainScrollView addSubview:seperator1];
    
    //time
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, mainScrollView.frame.size.width-2*originX, height*2)];
    heightCount += 2*height;
    [mainScrollView addSubview:timeView];
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
    timeTitleLabel.text = @"时间";
    timeTitleLabel.textColor = goColor1;
    [timeTitleLabel setFont:goFont15];
    [timeView addSubview:timeTitleLabel];
    UIButton *startTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, timeView.frame.size.width, 50)];
    [startTimeButton setTitle:@"从 -" forState:UIControlStateNormal];
    [startTimeButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [startTimeButton setTitleColor:goColor1 forState:UIControlStateSelected];
    startTimeButton.tag = 9005;
    [startTimeButton.titleLabel setFont:goFont15];
    [startTimeButton addTarget:self action:@selector(startTimeResponse) forControlEvents:UIControlEventTouchUpInside];
    startTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [timeView addSubview:startTimeButton];
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1)];
    seperator2.backgroundColor = goSeparator;
    [timeView addSubview:seperator2];
    UILabel *longTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height+10, 100, 20)];
    longTitleLabel.text = @"时长";
    longTitleLabel.textColor = goColor1;
    [longTitleLabel setFont:goFont15];
    [timeView addSubview:longTitleLabel];
    UIButton *endTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height+30, timeView.frame.size.width, 50)];
    [endTimeButton setTitle:@"- 小时" forState:UIControlStateNormal];
    [endTimeButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [endTimeButton setTitleColor:goColor1 forState:UIControlStateSelected];
    endTimeButton.tag = 9006;
    [endTimeButton.titleLabel setFont:goFont15];
    [endTimeButton addTarget:self action:@selector(endTimeResponse) forControlEvents:UIControlEventTouchUpInside];
    endTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [timeView addSubview:endTimeButton];
    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake(0, 2*height, width, 1)];
    seperator3.backgroundColor = goSeparator;
    [timeView addSubview:seperator3];
    
    
    //repeat
    repeatBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, mainScrollView.frame.size.width-2*originX, height)];
    heightCount += repeatBackgroundView.frame.size.height;
    [mainScrollView addSubview:repeatBackgroundView];
    UILabel *repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
    repeatLabel.text = @"会面次数";
    repeatLabel.textColor = goColor1;
    [repeatLabel setFont:goFont15];
    [repeatBackgroundView addSubview:repeatLabel];
    UIButton *repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, width, 50)];
    [repeatBackgroundView addSubview:repeatButton];
    [repeatButton setTitle:@"请选择会面次数" forState:UIControlStateNormal];
    [repeatButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [repeatButton setTitleColor:goColor1 forState:UIControlStateSelected];
    [repeatButton.titleLabel setFont:goFont15];
    repeatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [repeatButton addTarget:self action:@selector(sessionResponse:) forControlEvents:UIControlEventTouchUpInside];
    repeatButton.tag = 9007;
    UIView *seperator4 = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1)];
    seperator4.backgroundColor = goSeparator;
    [repeatBackgroundView addSubview:seperator4];
    
    
    /*
     //极速推荐
     quickMatchBackgroundView =[[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, mainScrollView.frame.size.width-2*originX, 40)];
     [mainScrollView addSubview:quickMatchBackgroundView];
     UILabel *quickLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 120, 20)];
     quickLabel.text = @"goTalk极速推荐";
     quickLabel.textColor = goColor1;
     [quickLabel setFont:goFont15];
     [quickMatchBackgroundView addSubview:quickLabel];
     UISwitch *quickSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(quickMatchBackgroundView.frame.size.width-30-50, 5, 40, 30)];
     [quickSwitch setOnTintColor:goColor4];
     [quickSwitch addTarget:self action:@selector(quickSwitchResponse:) forControlEvents:UIControlEventValueChanged];
     quickSwitch.tag = 9031;
     [quickMatchBackgroundView addSubview:quickSwitch];
     UILabel *quickNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, quickMatchBackgroundView.frame.size.height, quickMatchBackgroundView.frame.size.width-30, 40)];
     quickNoteLabel.text = @"goTalk会优先为您推荐最佳的候选人来满足您的需求。\n注：此选项未收费项目，选择会产生额外费用。";
     quickNoteLabel.tag = 9032;
     quickNoteLabel.numberOfLines = 0;
     quickNoteLabel.textColor = goColor3;
     [quickNoteLabel setFont:goFont13];
     [quickMatchBackgroundView addSubview:quickNoteLabel];
     */
    
    
    //price rate
    priceRateBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, mainScrollView.frame.size.width-2*originX, 1.7*height)];
    heightCount += priceRateBackgroundView.frame.size.height;
    [mainScrollView addSubview:priceRateBackgroundView];
    UILabel *priceRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 10, 20)];
    priceRateTitleLabel.text = @"价格(￥/小时)";
    priceRateTitleLabel.textColor = goColor1;
    [priceRateTitleLabel setFont:goFont15];
    [priceRateTitleLabel sizeToFit];
    [priceRateBackgroundView addSubview:priceRateTitleLabel];
    goPriceSlider *priceSlider = [[goPriceSlider alloc] initWithFrame:CGRectMake(0, .5*height+30-6.5, priceRateBackgroundView.frame.size.width, 50) type:goPriceSliderSingle];
    priceSlider.delegate = self;
    [priceRateBackgroundView addSubview:priceSlider];
    
    /*
     UIImageView *sliderTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, .5*height+30+25-6.5, priceRateBackgroundView.frame.size.width-30, 13)];
     sliderTrackImageView.image = [UIImage imageNamed:@"sliderTrackImage"];
     [priceRateBackgroundView addSubview:sliderTrackImageView];
     for (int i = 0; i<5; i++) {
     UILabel *sliderIndicater = [[UILabel alloc] initWithFrame:CGRectMake(0, .7*height, 60, 20)];
     sliderIndicater.text = [NSString stringWithFormat:@"%d",100+i*50];
     sliderIndicater.textAlignment = NSTextAlignmentCenter;
     sliderIndicater.textColor = goColor1;
     [sliderIndicater setFont:[UIFont fontWithName:@"SFUIDisplay-Regular" size:10]];
     sliderIndicater.center = CGPointMake(20+i*(sliderTrackImageView.frame.size.width-10)/4, sliderIndicater.center.y);
     [priceRateBackgroundView addSubview:sliderIndicater];
     }
     UISlider *priceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, .5*height+30, priceRateBackgroundView.frame.size.width, 50)];
     [priceRateBackgroundView addSubview:priceSlider];
     [priceSlider setMinimumValue:100];
     [priceSlider setMaximumValue:300];
     [priceSlider setValue:200];
     [priceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
     [priceSlider setThumbImage:[UIImage imageNamed:@"sliderThumbImage"] forState:UIControlStateNormal];
     [priceSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
     [priceSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
     _priceString = [NSString stringWithFormat:@"%.f",priceSlider.value];
     */
    _priceString = [NSString stringWithFormat:@"%ld",priceSlider.priceInteger];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_priceString, @"Hour Price", nil];
    [_orderSummary addEntriesFromDictionary:dict];
    
    
    UIView *seperator5 = [[UIView alloc] initWithFrame:CGRectMake(0, 1.7*height, width, 1)];
    seperator5.backgroundColor = goSeparator;
    [priceRateBackgroundView addSubview:seperator5];
    
    
    //location
    locationBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, width, height)];
    heightCount += locationBackgroundView.frame.size.height;
    [mainScrollView addSubview:locationBackgroundView];
    UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, 10, 20)];
    addressTitleLabel.text = @"地址";
    addressTitleLabel.textColor = goColor1;
    [addressTitleLabel setFont:goFont15];
    [addressTitleLabel sizeToFit];
    [locationBackgroundView addSubview:addressTitleLabel];
    mapView = [[goPinMap alloc] initWithFrame:CGRectMake(-originX, 40, mainScrollView.frame.size.width, locationBackgroundView.frame.size.height-40)];
    mapView.hidden = YES;
    [locationBackgroundView addSubview:mapView];
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 30, width, 50)];
    locationButton.tag = 9029;
    [locationButton addTarget:self action:@selector(locationReponse) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setTitle:@"选择见面地点" forState:UIControlStateNormal];
    [locationButton setTitle:@"" forState:UIControlStateSelected];
    [locationButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [locationButton setTitleColor:goColor1 forState:UIControlStateSelected];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [locationButton.titleLabel setFont:goFont15];
    [locationBackgroundView addSubview:locationButton];
    
    
    //stage
    stageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, width, height)];
    heightCount += stageBackgroundView.frame.size.height;
    [mainScrollView addSubview:stageBackgroundView];
    UIView *seperator6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    seperator6.backgroundColor = goSeparator;
    [stageBackgroundView addSubview:seperator6];
    UILabel *stageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 10, 20)];
    stageTitleLabel.text = @"阶段";
    stageTitleLabel.textColor = goColor1;
    [stageTitleLabel setFont:goFont15];
    [stageTitleLabel sizeToFit];
    [stageBackgroundView addSubview:stageTitleLabel];
    UIButton *stageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, width, 50)];
    [stageButton addTarget:self action:@selector(stageReponse) forControlEvents:UIControlEventTouchUpInside];
    [stageButton setTitle:@"选择阶段" forState:UIControlStateNormal];
    [stageButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [stageButton setTitleColor:goColor1 forState:UIControlStateSelected];
    [stageButton.titleLabel setFont:goFont15];
    stageButton.tag = 9025;
    stageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [stageBackgroundView addSubview:stageButton];
    UIView *seperator7 = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1)];
    seperator7.backgroundColor = goSeparator;
    [stageBackgroundView addSubview:seperator7];
    
    //category
    
    categoryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(originX, heightCount, mainScrollView.frame.size.width-2*originX, height)];
    heightCount += categoryBackgroundView.frame.size.height;
    [mainScrollView addSubview:categoryBackgroundView];
    UILabel *categoryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 10, 20)];
    categoryTitleLabel.text = @"类别";
    categoryTitleLabel.textColor = goColor1;
    [categoryTitleLabel setFont:goFont15];
    [categoryTitleLabel sizeToFit];
    [categoryBackgroundView addSubview:categoryTitleLabel];
    UIButton *cateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, width, 50)];
    [cateButton addTarget:self action:@selector(cateResponse) forControlEvents:UIControlEventTouchUpInside];
    [cateButton setTitle:@"选择类别" forState:UIControlStateNormal];
    [cateButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [cateButton setTitleColor:goColor1 forState:UIControlStateSelected];
    [cateButton.titleLabel setFont:goFont15];
    cateButton.tag = 9030;
    cateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [categoryBackgroundView addSubview:cateButton];
    UIView *seperator8 = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, goSeperatorHeight)];
    seperator8.backgroundColor = goSeparator;
    [categoryBackgroundView addSubview:seperator8];
    
    
    //message
    
    
    messageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, heightCount, mainScrollView.frame.size.width, 140)];
    messageBackgroundView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:messageBackgroundView];
    UILabel *messageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, 10, 20)];
    messageTitleLabel.text = @"描述（简单描述目标和要求）";
    messageTitleLabel.textColor = goColor1;
    [messageTitleLabel setFont:goFont15];
    [messageTitleLabel sizeToFit];
    [messageBackgroundView addSubview:messageTitleLabel];
    UITextView *messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(originX, 40, width, messageBackgroundView.frame.size.height-40)];
    messageTextView.backgroundColor = [UIColor whiteColor];
    messageTextView.textColor = goColor1;
    [messageTextView setFont:goFont15];
    messageTextView.tag = 9028;
    messageTextView.delegate = self;
    messageTextView.layer.cornerRadius = 2;
    messageTextView.clipsToBounds = YES;
    [messageBackgroundView addSubview:messageTextView];
    
    
    
    //policy
    policyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(originX, 0, mainScrollView.frame.size.width-2*originX, 180)];
    [mainScrollView addSubview:policyBackgroundView];
    
    UILabel *thirdPolicyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 50)];
    thirdPolicyLabel.text = @"如果继续完成订单，及代表您已仔细阅读并同意 Glopats平台服务协议 和 隐私政策。";
    thirdPolicyLabel.textColor = goColor1;
    [thirdPolicyLabel setFont:goFont13T];
    thirdPolicyLabel.numberOfLines = 0;
    [policyBackgroundView addSubview:thirdPolicyLabel];
    
    //    //submit
    //    //price
    //
    //    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*.4, policyBackgroundView.frame.size.height+policyBackgroundView.frame.origin.y, self.view.frame.size.width*.6, 60)];
    //    submitButton.backgroundColor = goColor5;
    //    [submitButton setTitle:@"发布" forState:UIControlStateNormal];
    //    [submitButton.titleLabel setFont:goFont18M];
    //    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [submitButton addTarget:self action:@selector(priceExpendResponse) forControlEvents:UIControlEventTouchUpInside];
    //    [mainScrollView addSubview:submitButton];
    //    priceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, policyBackgroundView.frame.size.height+policyBackgroundView.frame.origin.y, self.view.frame.size.width*.4, 60)];
    //    priceBackgroundView.clipsToBounds = YES;
    //    priceBackgroundView.backgroundColor = goColor4;
    //    CALayer *layer = priceBackgroundView.layer;
    //    layer.masksToBounds = NO;
    //    layer.shadowOffset = CGSizeMake(2, 0);
    //    layer.shadowColor = [[UIColor grayColor] CGColor];
    //    layer.shadowRadius = 1;
    //    layer.shadowOpacity = .50f;
    //    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    //    [mainScrollView addSubview:priceBackgroundView];
    
    
    
    [self originUpdate];
}

- (void)dateResponse{
    [self pickerConfirmResponse];
    //    UIDatePicker *startTimePicker = [self.view viewWithTag:9002];
    //    startTimePicker.hidden = YES;
    UIDatePicker *picker = [self.view viewWithTag:9001];
    //    UIDatePicker *endTimePicker = [self.view viewWithTag:9003];
    //    endTimePicker.hidden = YES;
    UIView *confirmBackground =[self.view viewWithTag:9013];
    if (picker == nil) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        //    [comps setDay:1];
        //    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [datePicker setMinimumDate:currentDate];
        [comps setDay:1];
        NSDate *nowDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [datePicker setDate:nowDate];
        [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.tag = 9001;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE yyyy年 MM月dd日"];
        NSString *dtrDate = [dateFormatter stringFromDate:nowDate];
        UIButton *button = [mainScrollView viewWithTag:9004];
        button.selected = YES;
        [button setTitle:dtrDate forState:UIControlStateSelected];
        [self.view addSubview:datePicker];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dtrDate, @"Starting Date String", nil];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:nowDate, @"Starting Date NSDate", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        [_orderSummary addEntriesFromDictionary:dict2];
        if (confirmBackground == nil) {
            //comfirm button
            UIView *confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
            confirmBackgroundView.backgroundColor = [UIColor whiteColor];
            confirmBackgroundView.tag = 9013;
            [self.view addSubview:confirmBackgroundView];
            UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [confirmButton setTitleColor:goColor4 forState:UIControlStateNormal];
            [confirmButton.titleLabel setFont:goFont15M];
            [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
            [confirmBackgroundView addSubview:confirmButton];
            CALayer *layer = confirmBackgroundView.layer;
            layer.masksToBounds = NO;
            layer.shadowOffset = CGSizeMake(0, -2);
            layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
            layer.shadowRadius = 2;
            layer.shadowOpacity = .25f;
            layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        }
        else{
            confirmBackground.hidden = NO;
        }
    }
    else{
        picker.hidden = NO;
        confirmBackground.hidden = NO;
    }
}
- (void)startTimeResponse{
    [self pickerConfirmResponse];
    UIDatePicker *picker = [self.view viewWithTag:9002];
    UIView *confirmBackground =[self.view viewWithTag:9013];
    if (picker == nil) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.minuteInterval = 15;
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour|NSCalendarUnitMinute fromDate:currentDate];
        NSInteger minutes = [comps minute];
        float minuteUnit = ceil((float) minutes / 15.0);
        minutes = minuteUnit * 15.0;
        [comps setMinute: minutes];
        
        NSDate *selectedDate = [_orderSummary objectForKey:@"Starting Date NSDate"];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
        NSDate *today = [cal dateFromComponents:components];
        
        NSDateComponents *selectComponents = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:selectedDate];
        [comps setYear:[selectComponents year]];
        [comps setMonth:[selectComponents month]];
        [comps setDay:[selectComponents day]];
        
        //        NSString *startingString = [_orderSummary objectForKey:@"Starting Date String"];
        //        // convert to date
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEEE yyyy年 MM月dd日"];
        //        NSDate *selectedDate = [dateFormat dateFromString:startingString];
        NSDateComponents *minTime = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:selectedDate];
        selectedDate = [cal dateFromComponents:minTime];
        if ([today isEqualToDate:selectedDate]) {
            minTime = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:selectedDate];
            
            [minTime setHour:06];
            [minTime setMinute:00];
            NSDate *minDate =[cal dateFromComponents:minTime];
            [datePicker setMinimumDate:minDate];
        }
        else{
            
        }
        
        NSDate *nowDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:nowDate, @"Starting Time NSDate", nil];
        [_orderSummary addEntriesFromDictionary:dict2];
        [datePicker setDate:nowDate];
        [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.tag = 9002;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"a hh:mm"];
        NSString *dtrDate = [dateFormatter stringFromDate:nowDate];
        UIButton *button = [mainScrollView viewWithTag:9005];
        NSString *displayString = [NSString stringWithFormat:@"%@",dtrDate];
        button.selected = YES;
        [button setTitle:displayString forState:UIControlStateSelected];
        [self.view addSubview:datePicker];
        NSDateFormatter *saveFormat = [[NSDateFormatter alloc] init];
        [saveFormat setDateFormat:@"HH:mm"];
        NSString *saveDate = [saveFormat stringFromDate:nowDate];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:saveDate, @"Starting Time", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        if (confirmBackground == nil) {
            //comfirm button
            UIView *confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
            confirmBackgroundView.backgroundColor = [UIColor whiteColor];
            confirmBackgroundView.tag = 9013;
            [self.view addSubview:confirmBackgroundView];
            UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [confirmButton setTitleColor:goColor4 forState:UIControlStateNormal];
            [confirmButton.titleLabel setFont:goFont15M];
            [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
            [confirmBackgroundView addSubview:confirmButton];
            CALayer *layer = confirmBackgroundView.layer;
            layer.masksToBounds = NO;
            layer.shadowOffset = CGSizeMake(0, -2);
            layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
            layer.shadowRadius = 2;
            layer.shadowOpacity = .25f;
            layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        }
        else{
            confirmBackground.hidden = NO;
        }
    }
    else{
        picker.hidden = NO;
        confirmBackground.hidden = NO;
    }
    NSString *startingString = [_orderSummary objectForKey:@"Ending Time"];
    //    if (priceBackgroundView == nil && startingString != nil) {
    //        priceBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, repeatBackgroundView.frame.size.height+repeatBackgroundView.frame.origin.y+20, mainScrollView.frame.size.width-20, 44)];
    //        [mainScrollView addSubview:priceBackgroundView];
    //    }
}
- (void)endTimeResponse{
    [self pickerConfirmResponse];
    UIView *confirmBackground =[self.view viewWithTag:9013];
    if (hourPicker == nil) {
        hourPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        hourPicker.delegate = self;
        hourPicker.dataSource = self;
        hourPicker.tag = 9003;
        hourPicker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:hourPicker];
        UIButton *button = [mainScrollView viewWithTag:9006];
        NSString *displayString = [NSString stringWithFormat:@"%ld 小时",hours];
        [button setTitle:displayString forState:UIControlStateSelected];
        button.selected = YES;
        
        if (confirmBackground == nil) {
            //comfirm button
            UIView *confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
            confirmBackgroundView.backgroundColor = [UIColor whiteColor];
            confirmBackgroundView.tag = 9013;
            [self.view addSubview:confirmBackgroundView];
            UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [confirmButton setTitleColor:goColor4 forState:UIControlStateNormal];
            [confirmButton.titleLabel setFont:goFont15M];
            [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
            [confirmBackgroundView addSubview:confirmButton];
            CALayer *layer = confirmBackgroundView.layer;
            layer.masksToBounds = NO;
            layer.shadowOffset = CGSizeMake(0, -2);
            layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
            layer.shadowRadius = 2;
            layer.shadowOpacity = .25f;
            layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        }
        else{
            confirmBackground.hidden = NO;
        }
    }
    else{
        [hourPicker reloadAllComponents];
        hourPicker.hidden = NO;
        confirmBackground.hidden = NO;
    }
    NSString *startingString = [_orderSummary objectForKey:@"Starting Time"];
    if (startingString != nil) {
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, priceBackgroundView.frame.size.height)];
        priceLabel.text = @"总计";
        priceLabel.textColor = [UIColor whiteColor];
        [priceLabel setFont:goFont13];
        [priceBackgroundView addSubview:priceLabel];
        [self originUpdate];
        
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, priceBackgroundView.frame.size.width-80, priceBackgroundView.frame.size.height)];
        totalPriceLabel.tag = 9015;
        totalPriceLabel.textColor = [UIColor whiteColor];
        [totalPriceLabel setFont:goFont30];
        totalPriceLabel.textAlignment = NSTextAlignmentCenter;
        [priceBackgroundView addSubview:totalPriceLabel];
        
        UILabel *yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceBackgroundView.frame.size.width-40, 0, 30, priceBackgroundView.frame.size.height)];
        yuanLabel.text = @"元";
        yuanLabel.textColor = [UIColor whiteColor];
        yuanLabel.textAlignment = NSTextAlignmentRight;
        [yuanLabel setFont:goFont13];
        [priceBackgroundView addSubview:yuanLabel];
        
        
        [self priceUpdate];
    }
    [self hoursUpdate];
}

- (void)datePickerChanged:(UIDatePicker *)adatePicker{
    if (adatePicker.tag == 9001) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE yyyy年 MM月dd日"];
        NSString *dtrDate = [dateFormatter stringFromDate:adatePicker.date];
        UIButton *button = [mainScrollView viewWithTag:9004];
        [button setTitle:dtrDate forState:UIControlStateSelected];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:dtrDate, @"Starting Date String", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:adatePicker.date, @"Starting Date NSDate", nil];
        [_orderSummary addEntriesFromDictionary:dict2];
        
    }
    else if (adatePicker.tag == 9002) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *saveDate = [dateFormat stringFromDate:adatePicker.date];
        NSDateFormatter *displayFormat = [[NSDateFormatter alloc] init];
        [displayFormat setDateFormat:@"a hh:mm"];
        NSString *dtrDate = [displayFormat stringFromDate:adatePicker.date];
        UIButton *button = [mainScrollView viewWithTag:9005];
        NSString *displayString = [NSString stringWithFormat:@"%@",dtrDate];
        [button setTitle:displayString forState:UIControlStateSelected];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:saveDate, @"Starting Time", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:adatePicker.date, @"Starting Time NSDate", nil];
        [_orderSummary addEntriesFromDictionary:dict2];
    }
    [self hoursUpdate];
    [self priceUpdate];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    float result;
    if (pickerView.tag == 9003) {
        NSDate *startingTime = [_orderSummary objectForKey:@"Starting Time NSDate"];
        NSDateComponents *compS = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startingTime];
        NSInteger startingHour = [compS hour];
        result = 24-startingHour;
    }
    else if (pickerView.tag == 9024){
        result = stageArray.count;
    }
    else if (pickerView.tag == 9026){
        result = categoryArray.count;
    }
    else if (pickerView.tag == 9027){
        NSString *categoryString = [_orderSummary objectForKey:@"Category"];
        if (categoryString != nil) {
            NSInteger index = [categoryString integerValue];
            result = [(NSArray *)[subcategoryArray objectAtIndex:index] count];
        }
    }
    return result;
}
- (void)priceSlider:(UISlider *)slider priceChangeToValue:(NSInteger)price{
    _priceString = [NSString stringWithFormat:@"%ld",price];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_priceString, @"Hour Price", nil];
    [_orderSummary addEntriesFromDictionary:dict];
    [self priceUpdate];
}
/*
 - (IBAction)sliderValueChanged:(id)sender{
 UISlider *priceSlider = sender;
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
 _priceString = [NSString stringWithFormat:@"%.f",priceSlider.value];
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_priceString, @"Hour Price", nil];
 [_orderSummary addEntriesFromDictionary:dict];
 [self priceUpdate];
 }
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    NSString *resultString = [[NSString alloc] init];
    if (pickerView.tag == 9003) {
        resultString = [NSString stringWithFormat:@"%ld 小时", row+1];
    }
    else if (pickerView.tag == 9024){
        resultString = [stageArray objectAtIndex:row];
    }
    else if (pickerView.tag == 9026){
        resultString = [categoryArray objectAtIndex:row];
    }
    else if (pickerView.tag == 9027){
        NSString *categoryString = [_orderSummary objectForKey:@"Category"];
        if (categoryString != nil) {
            NSInteger index = [categoryString integerValue];
            resultString = [(NSArray *)[subcategoryArray objectAtIndex:index] objectAtIndex:row];
        }
    }
    return resultString;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 9003) {
        hours = row+1;
        UIButton *button = [mainScrollView viewWithTag:9006];
        NSString *displayString = [NSString stringWithFormat:@"%ld 小时",hours];
        [button setTitle:displayString forState:UIControlStateSelected];
        [self priceUpdate];
        [self hoursUpdate];
    }
    else if (pickerView.tag == 9024){
        UIButton *stageButton = [stageBackgroundView viewWithTag:9025];
        [stageButton setTitle:[stageArray objectAtIndex:row] forState:UIControlStateSelected];
        NSString *stageIndex = [NSString stringWithFormat:@"%ld",row];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:stageIndex, @"Stage", nil];
        [_orderSummary addEntriesFromDictionary:dict];
    }
    else if (pickerView.tag == 9026){
        UIButton *categoryButton = [currentSuscard viewWithTag:9022];
        cateString = [categoryArray objectAtIndex:row];
        [categoryButton setTitle:[categoryArray objectAtIndex:row] forState:UIControlStateSelected];
        NSString *categoryIndex = [NSString stringWithFormat:@"%ld",row];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:categoryIndex, @"Category", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        subcategoryPicker = nil;
        UIButton *subcategoryButton = [currentSuscard viewWithTag:9023];
        subcategoryButton.selected = NO;
        if ([_orderSummary objectForKey:@"Subcategory"] != nil) {
            [_orderSummary removeObjectForKey:@"Subcategory"];
        }
        subcateString = @"-";
    }
    else if (pickerView.tag == 9027){
        NSString *categoryString = [_orderSummary objectForKey:@"Category"];
        if (categoryString != nil) {
            NSInteger index = [categoryString integerValue];
            UIButton *subcategoryButton = [currentSuscard viewWithTag:9023];
            subcateString = [(NSArray *)[subcategoryArray objectAtIndex:index] objectAtIndex:row];
            [subcategoryButton setTitle:[(NSArray *)[subcategoryArray objectAtIndex:index] objectAtIndex:row] forState:UIControlStateSelected];
            NSString *subcategoryIndex = [NSString stringWithFormat:@"%ld",row];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subcategoryIndex, @"Subcategory", nil];
            [_orderSummary addEntriesFromDictionary:dict];
        }
    }
    
}


- (IBAction)sessionResponse:(id)sender{
    [self pickerConfirmResponse];
    NSDate *selectedDate = [_orderSummary objectForKey:@"Starting Date NSDate"];
    if (selectedDate != nil) {
        goSuscard *baseView = [[goSuscard alloc] initWithFullSize];
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:baseView];
        baseView.cancelButton.hidden = NO;
        baseView.backButton.hidden = YES;
        baseView.cardBackgroundView.backgroundColor = goColor5;
        [baseView.cancelButton setImage:[UIImage imageNamed:@"cancelWhite"] forState:UIControlStateNormal];
        [baseView.cancelButton addTarget:self action:@selector(sessionComplete) forControlEvents:UIControlEventTouchUpInside];
        baseView.alpha = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.258];
        baseView.alpha = 1;
        [UIView commitAnimations];
        [self pickerConfirmResponse];
        /*********************** setup base view ***********************/
        float originX = 20;
        UILabel *sessionTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 200, 35)];
        sessionTitle.text = @"课程次数";
        sessionTitle.textColor = [UIColor whiteColor];
        [sessionTitle setFont:goFont30S];
        [baseView addGoSubview:sessionTitle];
        
        UIButton *minorButton = [[UIButton alloc] initWithFrame:CGRectMake(baseView.cardSize.width-30-108, 120+3, 24, 24)];
        [minorButton setImage:[UIImage imageNamed:@"deleteIconCircleWhiteLarge"] forState:UIControlStateNormal];
        [minorButton addTarget:self action:@selector(sessionDecrease) forControlEvents:UIControlEventTouchUpInside];
        [baseView addGoSubview:minorButton];
        
        sessionDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(baseView.cardSize.width-30-108+24, 120, 60, 30)];
        [sessionDetailButton setTitle:[_orderSummary objectForKey:@"Repeat Times"] forState:UIControlStateNormal];
        [sessionDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sessionDetailButton.titleLabel setFont:goFont30T];
        //        [sessionDetailButton addTarget:self action:@selector(sessionIncrease) forControlEvents:UIControlEventTouchUpInside];
        [baseView addGoSubview:sessionDetailButton];
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(baseView.cardSize.width-30-24, 120+3, 24, 24)];
        [addButton setImage:[UIImage imageNamed:@"addCircleWhiteLarge"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(sessionIncrease) forControlEvents:UIControlEventTouchUpInside];
        [baseView addGoSubview:addButton];
        
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(originX, 170, baseView.cardSize.width-2*originX, goSeperatorHeight)];
        seperator.backgroundColor = goSeparator;
        [baseView addGoSubview:seperator];
        
        //calander
        //    UIColor *selectedColor =[UIColor blueColor];
        acalendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, seperator.frame.origin.y+2, baseView.cardSize.width, baseView.cardSize.height-seperator.frame.origin.y-2-40)];
        acalendar.appearance.headerTitleColor = [UIColor whiteColor];
        acalendar.appearance.weekdayTextColor = [UIColor whiteColor];
        
        acalendar.appearance.weekdayFont = goFont13;
        acalendar.appearance.headerTitleFont = goFont15;
        acalendar.appearance.titleFont = goFont13;
        acalendar.selectedColor = [UIColor whiteColor];
        acalendar.selectedTextColor = goColor5;
        acalendar.defaultTextColor = [UIColor whiteColor];
        acalendar.backgroundColor = [UIColor clearColor];
        acalendar.dataSource = self;
        acalendar.delegate = self;
        acalendar.showsPlaceholders = NO;
        acalendar.pagingEnabled = NO; // important
        acalendar.allowsMultipleSelection = YES;
        acalendar.firstWeekday = 1;
        acalendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase|FSCalendarCaseOptionsHeaderUsesUpperCase;
        acalendar.clipsToBounds = YES;
        [baseView addGoSubview:acalendar];
        
        UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(originX, baseView.cardSize.height-40, baseView.cardSize.width-2*originX, goSeperatorHeight)];
        seperator2.backgroundColor = [UIColor whiteColor];
        [baseView addGoSubview:seperator2];
        
        [self calendarUpdate];
        [self priceUpdate];
        
    }
}
//- (IBAction)quickSwitchResponse:(id)sender{
//    UISwitch *quickSwitch = sender;
//
//}
- (void)calendarUpdate{
    NSDate *selectedDate = [_orderSummary objectForKey:@"Starting Date NSDate"];
    acalendar.allowsSelection = YES;
    acalendar.allowsMultipleSelection = YES;
    [acalendar selectDate:selectedDate];
    NSDate *lastDate = selectedDate;
    for (int i = 1; i<times; i++) {
        NSDate *date = [lastDate dateByAddingTimeInterval:60*60*24*7*i];
        [acalendar selectDate:date];
    }
    NSDate *date = [lastDate dateByAddingTimeInterval:60*60*24*7*times];
    [acalendar deselectDate:date];
    acalendar.allowsSelection = NO;
    [acalendar reloadData];
}

- (void)pickerConfirmResponse{
    UIView *confirmBackground =[self.view viewWithTag:9013];
    confirmBackground.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    UIView *confirmWindow =[currentWindow viewWithTag:9033];
    [confirmWindow removeFromSuperview];
    UIDatePicker *datePicker = [self.view viewWithTag:9001];
    datePicker.hidden = YES;
    UIDatePicker *startTimePicker = [self.view viewWithTag:9002];
    startTimePicker.hidden = YES;
    //    UIDatePicker *picker = [self.view viewWithTag:9003];
    hourPicker.hidden = YES;
    stagePicker.hidden = YES;
    categoryPicker.hidden = YES;
    subcategoryPicker.hidden = YES;
    //    if (keyboardState) {
    //        UITextView *messageTextView = [messageBackgroundView viewWithTag:9028];
    //        [messageTextView resignFirstResponder];
    //        keyboardState = NO;
    //        [self originUpdate];
    //    }
}

- (void)sessionComplete{
    UIButton *sessionButton = [repeatBackgroundView viewWithTag:9007];
    sessionButton.selected = YES;
    [sessionButton setTitle:[NSString stringWithFormat:@"1次/周 (共%@周)",[_orderSummary objectForKey:@"Repeat Times"]] forState:UIControlStateSelected];
    [self priceUpdate];
}
- (void)sessionIncrease{
    NSInteger sessionInteger = [[_orderSummary objectForKey:@"Repeat Times"] integerValue];
    if (sessionInteger<12) {
        sessionInteger++;
        times = sessionInteger;
        NSString *sessionString = [NSString stringWithFormat:@"%ld",sessionInteger];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sessionString, @"Repeat Times", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        [sessionDetailButton setTitle:[_orderSummary objectForKey:@"Repeat Times"] forState:UIControlStateNormal];
        [self calendarUpdate];
    }
    
}
- (void)sessionDecrease{
    NSInteger sessionInteger = [[_orderSummary objectForKey:@"Repeat Times"] integerValue];
    if (sessionInteger>1) {
        sessionInteger--;
        times = sessionInteger;
        NSString *sessionString = [NSString stringWithFormat:@"%ld",sessionInteger];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sessionString, @"Repeat Times", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        [sessionDetailButton setTitle:[_orderSummary objectForKey:@"Repeat Times"] forState:UIControlStateNormal];
        [self calendarUpdate];
    }
    
}

- (void)priceUpdate{
    UILabel *priceLabel = [priceBackgroundView viewWithTag:9015];
    NSInteger rate = [self.priceString integerValue];
    NSInteger price = rate * hours * times;
    NSString *priceString = [NSString stringWithFormat:@"%ld",price];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:priceString, @"Price String", nil];
    [_orderSummary addEntriesFromDictionary:dict];
    priceLabel.text = [NSString stringWithFormat:@"%ld",price];
    
    UILabel *hoursLabel = [priceBackgroundView viewWithTag:9020];
    hoursLabel.text = [NSString stringWithFormat:@"%ld 小时",hours];
    UILabel *timesLabel = [priceBackgroundView viewWithTag:9021];
    timesLabel.text = [NSString stringWithFormat:@"%ld 次",times];
}
- (void)hoursUpdate{
    NSString *priceString = [NSString stringWithFormat:@"%ld",hours];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:priceString, @"Hours String", nil];
    [_orderSummary addEntriesFromDictionary:dict];
}

- (void)priceExpendResponse{
    [self pickerConfirmResponse];
    UITextView *messageTextView = [messageBackgroundView viewWithTag:9028];
    [messageTextView resignFirstResponder];
    //current date
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *orderPlaceDateString = [currentDateFormatter stringFromDate:currentDate];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:orderPlaceDateString, @"Order Placed Date", nil];
    [_orderSummary addEntriesFromDictionary:dict];
    //message
    NSString *messageString = messageTextView.text;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:messageString, @"Message", nil];
    [_orderSummary addEntriesFromDictionary:dict];
    if (_orderSummary.count > 16) {
        goSuscard *baseView = [[goSuscard alloc] initWithFullSize];
        currentSuscard = baseView;
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:baseView];
        baseView.cancelButton.hidden = YES;
        baseView.backButton.hidden = NO;
        baseView.cardBackgroundView.backgroundColor = goColor5;
        [baseView whiteButton];
        //        [baseView.cancelButton setImage:[UIImage imageNamed:@"cancelWhite"] forState:UIControlStateNormal];
        //        [baseView.cancelButton addTarget:self action:@selector(sessionComplete) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmOrderButton.bounds = CGRectMake(0, 0, 36, 36);
        [confirmOrderButton setImage:[UIImage imageNamed:@"confirmWhite"] forState:UIControlStateNormal];
        [confirmOrderButton addTarget:self action:@selector(submitResponse:) forControlEvents:UIControlEventTouchUpInside];
        confirmOrderButton.frame = baseView.rightButtonFrame;
        [baseView addSubview:confirmOrderButton];
        
        baseView.alpha = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.258];
        baseView.alpha = 1;
        [UIView commitAnimations];
        /*********************** setup base view ***********************/
        
        float originX = 20;
        float height = 50;
        float width = baseView.cardSize.width-2*originX;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 80, width, 35)];
        titleLabel.text = @"订单详情";
        [titleLabel setFont:goFont30S];
        titleLabel.textColor = [UIColor whiteColor];
        [baseView addGoSubview:titleLabel];
        
        UILabel *priceRateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, titleLabel.frame.size.height+titleLabel.frame.origin.y+40, width, height)];
        priceRateTitleLabel.text = @"每小时费用";
        priceRateTitleLabel.textColor = [UIColor whiteColor];
        [priceRateTitleLabel setFont:goFont15];
        [baseView addGoSubview:priceRateTitleLabel];
        UILabel *priceRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, titleLabel.frame.size.height+titleLabel.frame.origin.y+40, width, height)];
        priceRateLabel.text = [NSString stringWithFormat:@"￥%@.00",_priceString];
        priceRateLabel.textColor = [UIColor whiteColor];
        [priceRateLabel setFont:goFont15];
        priceRateLabel.textAlignment = NSTextAlignmentRight;
        [baseView addGoSubview:priceRateLabel];
        
        //separator1
        UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(originX, titleLabel.frame.size.height+titleLabel.frame.origin.y+40+height, width, goSeperatorHeight)];
        separator1.backgroundColor = goSeparator;
        [baseView addGoSubview:separator1];
        UILabel *hoursTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, separator1.frame.origin.y, width, height)];
        hoursTitleLabel.text = @"小时/次";
        hoursTitleLabel.textColor = [UIColor whiteColor];
        [hoursTitleLabel setFont:goFont15];
        [baseView addGoSubview:hoursTitleLabel];
        UILabel *hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, hoursTitleLabel.frame.origin.y, width, height)];
        hoursLabel.textColor = [UIColor whiteColor];
        hoursLabel.textAlignment = NSTextAlignmentRight;
        hoursLabel.text = [NSString stringWithFormat:@"%ld",hours];
        [hoursLabel setFont:goFont15];
        hoursLabel.tag = 9020;
        [baseView addGoSubview:hoursLabel];
        
        //separator2
        UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(originX, titleLabel.frame.size.height+titleLabel.frame.origin.y+40+2*height, width, goSeperatorHeight)];
        separator2.backgroundColor = goSeparator;
        [baseView addGoSubview:separator2];
        UILabel *timesTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, separator2.frame.origin.y, 100, height)];
        timesTitleLabel.text = @"总次数";
        timesTitleLabel.textColor = [UIColor whiteColor];
        [timesTitleLabel setFont:goFont15];
        [baseView addGoSubview:timesTitleLabel];
        UILabel *timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, timesTitleLabel.frame.origin.y, width, height)];
        timesLabel.textColor = [UIColor whiteColor];
        timesLabel.textAlignment = NSTextAlignmentRight;
        timesLabel.text = [NSString stringWithFormat:@"%ld",times];
        [timesLabel setFont:goFont15];
        timesLabel.tag = 9021;
        [baseView addGoSubview:timesLabel];
        
        //separator3
        UIView *separator3 = [[UIView alloc] initWithFrame:CGRectMake(originX, titleLabel.frame.size.height+titleLabel.frame.origin.y+40+3*height, width, goSeperatorHeight)];
        separator3.backgroundColor = goSeparator;
        [baseView addGoSubview:separator3];
        UILabel *totalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, separator3.frame.origin.y, width, height+10)];
        totalTitleLabel.text = @"总计金额";
        totalTitleLabel.textColor = [UIColor whiteColor];
        [totalTitleLabel setFont:goFont15];
        [baseView addGoSubview:totalTitleLabel];
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, totalTitleLabel.frame.origin.y, width-30, height+10)];
        totalLabel.textColor = [UIColor whiteColor];
        totalLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.text = [NSString stringWithFormat:@"%@.00",[_orderSummary valueForKey:@"Price String"]];
        [totalLabel setFont:goFont30];
        [baseView addGoSubview:totalLabel];
        UILabel *yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, totalTitleLabel.frame.origin.y, width, height+10)];
        yuanLabel.textColor = [UIColor whiteColor];
        yuanLabel.textAlignment = NSTextAlignmentRight;
        yuanLabel.text = @"元";
        [yuanLabel setFont:goFont15];
        [baseView addGoSubview:yuanLabel];
        
        //separator4
        UIView *separator4 = [[UIView alloc] initWithFrame:CGRectMake(originX, titleLabel.frame.size.height+titleLabel.frame.origin.y+40+10+4*height, width, goSeperatorHeight)];
        separator4.backgroundColor = goSeparator;
        [baseView addGoSubview:separator4];
        UILabel *pricePolicyLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, separator4.frame.origin.y, width, 50)];
        pricePolicyLabel.text = @"请仔细核对订单金额，费用只会在双方完成每一次会面后按单次会面金额扣出。";
        pricePolicyLabel.textColor = [UIColor whiteColor];
        [pricePolicyLabel setFont:goFont13];
        pricePolicyLabel.numberOfLines = 2;
        [baseView addGoSubview:pricePolicyLabel];
        originX = 22;
        width = baseView.cardSize.width-2*originX;
        UILabel *policyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, pricePolicyLabel.frame.origin.y+pricePolicyLabel.frame.size.height+10, width, 25)];
        policyTitleLabel.text = @"服务条款和退款协议";
        policyTitleLabel.textColor = [UIColor whiteColor];
        [policyTitleLabel setFont:goFont15];
        [policyTitleLabel sizeToFit];
        [baseView addGoSubview:policyTitleLabel];
        UILabel *firstPolicyLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, policyTitleLabel.frame.origin.y+policyTitleLabel.frame.size.height+10, width, 50)];
        firstPolicyLabel.text = @"如任何情况或任何原因订单无法完成，用户可根据剩余订单数量申请无条件退款。";
        firstPolicyLabel.textColor = [UIColor whiteColor];
        [firstPolicyLabel setFont:goFont13];
        firstPolicyLabel.numberOfLines = 2;
        [baseView addGoSubview:firstPolicyLabel];
        UILabel *secondPolicyLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, firstPolicyLabel.frame.origin.y+firstPolicyLabel.frame.size.height+10, width, 60)];
        secondPolicyLabel.text = @"订单一旦通过双方同意并开始计时收费，系统将无法完成退款。本公司可提供解决方案，但并不对造成的损失负任何法律责任。";
        secondPolicyLabel.textColor = [UIColor whiteColor];
        [secondPolicyLabel setFont:goFont13];
        secondPolicyLabel.numberOfLines = 0;
        [baseView addGoSubview:secondPolicyLabel];
    }
}

- (void)originUpdate{
    stageBackgroundView.frame = CGRectMake(stageBackgroundView.frame.origin.x, locationBackgroundView.frame.size.height+locationBackgroundView.frame.origin.y, stageBackgroundView.frame.size.width, stageBackgroundView.frame.size.height);
    categoryBackgroundView.frame = CGRectMake(categoryBackgroundView.frame.origin.x, stageBackgroundView.frame.size.height+stageBackgroundView.frame.origin.y, categoryBackgroundView.frame.size.width, categoryBackgroundView.frame.size.height);
    messageBackgroundView.frame = CGRectMake(messageBackgroundView.frame.origin.x, categoryBackgroundView.frame.size.height+categoryBackgroundView.frame.origin.y, messageBackgroundView.frame.size.width, messageBackgroundView.frame.size.height);
    /*
     priceBackgroundView.frame = CGRectMake(priceBackgroundView.frame.origin.x, messageBackgroundView.frame.size.height+messageBackgroundView.frame.origin.y+20, priceBackgroundView.frame.size.width, priceBackgroundView.frame.size.height);
     priceNoteLabel.frame = CGRectMake(0, priceBackgroundView.frame.origin.y+priceBackgroundView.frame.size.height, self.view.frame.size.width, priceNoteLabel.frame.size.height);*/
    policyBackgroundView.frame = CGRectMake(policyBackgroundView.frame.origin.x, messageBackgroundView.frame.size.height+messageBackgroundView.frame.origin.y+40, policyBackgroundView.frame.size.width, policyBackgroundView.frame.size.height);
    //    submitButton.frame =CGRectMake(submitButton.frame.origin.x, policyBackgroundView.frame.origin.y+policyBackgroundView.frame.size.height, submitButton.frame.size.width, submitButton.frame.size.height);
    //    priceBackgroundView.frame = CGRectMake(priceBackgroundView.frame.origin.x, submitButton.frame.origin.y, priceBackgroundView.frame.size.width, priceBackgroundView.frame.size.height);
    
    mainScrollView.contentSize = CGSizeMake(0, policyBackgroundView.frame.origin.y+policyBackgroundView.frame.size.height);
    
}

- (void)locationReponse{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    MapViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewInvite"];
//    viewController.activeRange = NO;
//    if (_locationItem) viewController.selectedItem = _locationItem;
//    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)stageReponse{
    [self pickerConfirmResponse];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    mainScrollView.contentOffset = CGPointMake(0, stageBackgroundView.frame.origin.y-1.2*self.view.frame.size.height/3);
    [UIView commitAnimations];
    UIButton *stageButton = [stageBackgroundView viewWithTag:9025];
    stageButton.selected = YES;
    UIView *confirmBackground =[self.view viewWithTag:9013];
    if (stagePicker == nil) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"stageList"
                                                             ofType:@"txt"];
        NSString *cityString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        stageArray = [[NSArray alloc] init];
        stageArray = [cityString componentsSeparatedByString:@","];
        [stageButton setTitle:[stageArray firstObject] forState:UIControlStateSelected];
        stagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        stagePicker.delegate = self;
        stagePicker.dataSource = self;
        stagePicker.tag = 9024;
        stagePicker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:stagePicker];
        NSString *stageIndex = @"0";
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:stageIndex, @"Stage", nil];
        [_orderSummary addEntriesFromDictionary:dict];
        
        if (confirmBackground == nil) {
            //comfirm button
            UIView *confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
            confirmBackgroundView.backgroundColor = [UIColor whiteColor];
            confirmBackgroundView.tag = 9013;
            [self.view addSubview:confirmBackgroundView];
            UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
            [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [confirmButton setTitleColor:goColor4 forState:UIControlStateNormal];
            [confirmButton.titleLabel setFont:goFont15M];
            [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
            [confirmBackgroundView addSubview:confirmButton];
            CALayer *layer = confirmBackgroundView.layer;
            layer.masksToBounds = NO;
            layer.shadowOffset = CGSizeMake(0, -2);
            layer.shadowColor = [UIColorFromRGB(0xBBBBBB) CGColor];
            layer.shadowRadius = 2;
            layer.shadowOpacity = .25f;
            layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        }
        else{
            confirmBackground.hidden = NO;
        }
    }
    else{
        stagePicker.hidden = NO;
        confirmBackground.hidden = NO;
    }
}
- (void)cateComplete{
    [self pickerConfirmResponse];
    UIButton *cateButton = [categoryBackgroundView viewWithTag:9030];
    if (cateString != nil) {
        cateButton.selected = YES;
        [cateButton setTitle:[NSString stringWithFormat:@"%@ | %@", cateString, subcateString] forState:UIControlStateSelected];
    }
    
}
- (void)cateResponse{
    [self pickerConfirmResponse];//CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
    goSuscard *baseView = [[goSuscard alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) withCardSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-40, 150) keyboard:NO];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:baseView];
    [baseView.cancelButton addTarget:self action:@selector(cateComplete) forControlEvents:UIControlEventTouchUpInside];
    currentSuscard = baseView;
    baseView.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    baseView.alpha = 1;
    mainScrollView.contentOffset = CGPointMake(0, categoryBackgroundView.frame.origin.y-self.view.frame.size.height/2.5);
    [UIView commitAnimations];
    /*********************** setup base view ***********************/
    UILabel *categoryFixedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, baseView.cardSize.width/2, 20)];
    categoryFixedLabel.text = @"主类别";
    categoryFixedLabel.textColor = goColor1;
    categoryFixedLabel.textAlignment = NSTextAlignmentCenter;
    [categoryFixedLabel setFont:goFont13];
    [baseView addGoSubview:categoryFixedLabel];
    UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, categoryFixedLabel.frame.size.height+categoryFixedLabel.frame.origin.y, baseView.cardSize.width/2, 60)];
    [categoryButton setTitle:@"-" forState:UIControlStateNormal];
    [categoryButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [categoryButton setTitle:cateString forState:UIControlStateSelected];
    [categoryButton setTitleColor:goColor1 forState:UIControlStateSelected];
    categoryButton.tag = 9022;
    [categoryButton.titleLabel setFont:goFont15];
    [categoryButton addTarget:self action:@selector(categoryResponse) forControlEvents:UIControlEventTouchUpInside];
    if (cateString == nil){
        categoryButton.selected = NO;
    }
    else categoryButton.selected = YES;
    [baseView addGoSubview:categoryButton];
    UILabel *subcategoryFixedLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseView.cardSize.width/2, 30, baseView.cardSize.width/2, 20)];
    subcategoryFixedLabel.text = @"次类别";
    subcategoryFixedLabel.textColor = goColor1;
    subcategoryFixedLabel.textAlignment = NSTextAlignmentCenter;
    [subcategoryFixedLabel setFont:goFont13];
    [baseView addGoSubview:subcategoryFixedLabel];
    UIButton *subcategoryButton = [[UIButton alloc] initWithFrame:CGRectMake(baseView.cardSize.width/2, subcategoryFixedLabel.frame.size.height+subcategoryFixedLabel.frame.origin.y, baseView.cardSize.width/2, 60)];
    [subcategoryButton setTitle:@"-" forState:UIControlStateNormal];
    [subcategoryButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [subcategoryButton setTitle:subcateString forState:UIControlStateSelected];
    [subcategoryButton setTitleColor:goColor1 forState:UIControlStateSelected];
    subcategoryButton.tag = 9023;
    [subcategoryButton.titleLabel setFont:goFont15];
    [subcategoryButton addTarget:self action:@selector(subcategoryResponse) forControlEvents:UIControlEventTouchUpInside];
    if (subcateString == nil || [subcateString isEqualToString:@"-"]){
        subcategoryButton.selected = NO;
    }
    else subcategoryButton.selected = YES;
    [baseView addGoSubview:subcategoryButton];
}
- (void)categoryResponse{
    [self pickerConfirmResponse];
    UIButton *categoryButton = [currentSuscard viewWithTag:9022];
    categoryButton.selected = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    //    UIView *confirmBackground =[currentWindow viewWithTag:9033];
    if (categoryPicker == nil) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"categoryList"
                                                             ofType:@"txt"];
        NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        categoryArray = [[NSArray alloc] init];
        categoryArray = [categoryString componentsSeparatedByString:@","];
        cateString = [categoryArray firstObject];
        [categoryButton setTitle:[categoryArray firstObject] forState:UIControlStateSelected];
        categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
        categoryPicker.delegate = self;
        categoryPicker.dataSource = self;
        categoryPicker.tag = 9026;
        categoryPicker.backgroundColor = [UIColor whiteColor];
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:categoryPicker];
        NSString *categoryIndex = @"0";
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:categoryIndex, @"Category", nil];
        [_orderSummary addEntriesFromDictionary:dict];
    }
    else{
        categoryPicker.hidden = NO;
        [currentWindow bringSubviewToFront:categoryPicker];
        
    }
    UIView *confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
    confirmBackgroundView.backgroundColor = [UIColor whiteColor];
    confirmBackgroundView.tag = 9033;
    [currentWindow addSubview:confirmBackgroundView];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:goColor4 forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:goFont15];
    [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
    [confirmBackgroundView addSubview:confirmButton];
}
- (void)subcategoryResponse{
    [self pickerConfirmResponse];
    UIButton *subcategoryButton = [currentSuscard viewWithTag:9023];
    subcategoryButton.selected = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    
    if (subcategoryPicker == nil && categoryArray != nil) {
        if (subcategoryArray.count == 0) {
            subcategoryArray = [[NSArray alloc] init];
            for (NSInteger i = 0; i<categoryArray.count; i++) {
                NSString *fileName = [NSString stringWithFormat:@"subcategory%ld",i];
                NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName
                                                                     ofType:@"txt"];
                NSString *categoryString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                NSArray *array = [[NSArray alloc] init];
                array = [categoryString componentsSeparatedByString:@","];
                subcategoryArray = [subcategoryArray arrayByAddingObject:array];
            }
        }
        NSString *categoryString = [_orderSummary objectForKey:@"Category"];
        if (categoryString != nil) {
            NSInteger index = [categoryString integerValue];
            subcateString = [[subcategoryArray objectAtIndex:index] firstObject];
            [subcategoryButton setTitle:[[subcategoryArray objectAtIndex:index] firstObject] forState:UIControlStateSelected];
            subcategoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216)];
            subcategoryPicker.delegate = self;
            subcategoryPicker.dataSource = self;
            subcategoryPicker.tag = 9027;
            subcategoryPicker.backgroundColor = [UIColor whiteColor];
            [currentWindow addSubview:subcategoryPicker];
            NSString *subcategoryIndex = @"0";
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subcategoryIndex, @"Subcategory", nil];
            [_orderSummary addEntriesFromDictionary:dict];
        }
    }
    else{
        subcategoryPicker.hidden = NO;
        [subcategoryPicker reloadAllComponents];
        [currentWindow bringSubviewToFront:subcategoryPicker];
    }
    if (categoryArray != nil) {
        UIView *confirmBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216-30, self.view.frame.size.width, 30)];
        confirmBackgroundView.backgroundColor = [UIColor whiteColor];
        confirmBackgroundView.tag = 9033;
        [currentWindow addSubview:confirmBackgroundView];
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmBackgroundView.frame.size.width-60, 0, 40, 30)];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:goColor4 forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:goFont15];
        [confirmButton addTarget:self action:@selector(pickerConfirmResponse) forControlEvents:UIControlEventTouchUpInside];
        [confirmBackgroundView addSubview:confirmButton];
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self pickerConfirmResponse];
}

- (void)keyboardDidChange:(NSNotification *)note
{
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    offsetKeyboard =messageBackgroundView.frame.origin.y+messageBackgroundView.frame.size.height-self.view.frame.size.height+kbSize.height+10;
    keyboardState = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    mainScrollView.contentOffset = CGPointMake(0,offsetKeyboard);//-1.2*self.view.frame.size.height/3);
    mainScrollView.contentSize = CGSizeMake(0, offsetKeyboard+self.view.frame.size.height);
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(keyboardReady) userInfo:nil repeats:NO];
}
- (void)keyboardReady{
    keyboardState = YES;
}
- (IBAction)submitResponse:(id)sender{
    UIButton *button = sender;
    button.enabled = NO;
    //sendingdate
    NSDate *selectedDate = [_orderSummary objectForKey:@"Starting Date NSDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *sendingDateString = [dateFormatter stringFromDate:selectedDate];
    //current date
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    [currentDateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *orderPlaceDateString = [currentDateFormatter stringFromDate:currentDate];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:orderPlaceDateString, @"Order Placed Date", nil];
    [_orderSummary addEntriesFromDictionary:dict];
    
    //Ending Time
    NSDate *startingTime = [_orderSummary objectForKey:@"Starting Time NSDate"];
    NSDateComponents *compS = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:startingTime];
    NSInteger startingHour = [compS hour];
    NSUInteger endingHour = startingHour + hours;
    [compS setHour:endingHour];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate * endingTime = [gregorianCalendar dateFromComponents:compS];
    NSDateFormatter *endingTimeFormatter = [[NSDateFormatter alloc] init];
    [endingTimeFormatter setDateFormat:@"HH:mm"];
    NSString *endingTimeString = [endingTimeFormatter stringFromDate:endingTime];
    if (_orderSummary.count > 16) {
        NSString *requestBody = [NSString stringWithFormat:@"cook_id=%@&share_type=%d&date=%@&start_time=%@&end_time=%@&hours=%@&share_price=%@&latitude=%@&longitude=%@&times=%@&category=%@,%@&message=%@&stage=%@&loc_name=%@",[_orderSummary objectForKey:@"MEID"],1,sendingDateString, [_orderSummary objectForKey:@"Starting Time"], endingTimeString, [_orderSummary objectForKey:@"Hours String"], _priceString,[_orderSummary objectForKey:@"Latitude"],[_orderSummary objectForKey:@"Longitude"],[_orderSummary objectForKey:@"Repeat Times"],[_orderSummary objectForKey:@"Category"],[_orderSummary objectForKey:@"Subcategory"], [_orderSummary objectForKey:@"Message"],[_orderSummary objectForKey:@"Stage"],[_orderSummary objectForKey:@"loc_name"]];
        NSLog(@"%@/n",requestBody);
        
        
        /*改上面的 query 和 URLstring 就好了*/
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@postorder",basicURL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                NSLog(@"server said: %@",string);
                                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:kNilOptions error:&error];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    UINavigationController * navigationController = self.navigationController;
                                                    [navigationController popToRootViewControllerAnimated:NO];
//                                                    [currentSuscard cancelResponse];
//                                                    /*show the comfirm at here*/
//                                                    [self orderDetailResponse:dic];
//                                                    orderPendingViewController *viewController = [[orderPendingViewController alloc] init];
//                                                    viewController.controllerType = goControllerSTD;
//                                                    viewController.hidesBottomBarWhenPushed = YES;
//                                                    [navigationController pushViewController:viewController animated:YES];
                                                });
                                            }];
        [task resume];
    }
    else{
        NSLog(@"Error: Component Lack");
    }
}
- (void)orderDetailResponse:(NSDictionary*)infoDict{
//    NSLog(@"%@",infoDict);
//    goSuscard *baseView = [[goSuscard alloc] initWithFullSize];
//    baseView.cancelButton.hidden = YES;
//    baseView.backButton.hidden = YES;
//    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
//    [currentWindow addSubview:baseView];
//    baseView.alpha = 0;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.258];
//    baseView.alpha = 1;
//    [UIView commitAnimations];
//    
//    /*Content setup*/
//    float heightCount = 30;
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, baseView.cardSize.width, 30)];
//    titleLabel.text = @"订单详情";
//    titleLabel.textColor = goColor1;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [titleLabel setFont:goFont18M];
//    [baseView addGoSubview:titleLabel];
//    heightCount += titleLabel.frame.size.height;
//    
//    goOrderSummary *orderSummary = [[goOrderSummary alloc] initWithFrame:CGRectMake(20, heightCount, baseView.cardSize.width-40, 0) orderDict:infoDict type:goControllerSTD];
//    [baseView addGoSubview:orderSummary];
//    heightCount += orderSummary.frame.size.height;
//    
//    UILabel *reciptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, heightCount, baseView.cardSize.width, 44)];
//    reciptLabel.text = @"订单明细";
//    reciptLabel.textColor = goColor3;
//    [reciptLabel setFont:goFont13];
//    reciptLabel.textAlignment = NSTextAlignmentCenter;
//    reciptLabel.backgroundColor = goBackgroundColorLight;
//    [baseView addGoSubview:reciptLabel];
//    heightCount += reciptLabel.frame.size.height;
//    
//    goReciptStd *recipt = [[goReciptStd alloc] initWithFrame:CGRectMake(0, heightCount, baseView.cardSize.width, 0) order:infoDict];
//    [baseView addGoSubview:recipt];
//    
//    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, baseView.frame.size.height-60, baseView.frame.size.width, 60)];
//    [yesButton setTitle:@"确认" forState:UIControlStateNormal];
//    [yesButton.titleLabel setFont:goFont20S];
//    [yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [yesButton addTarget:baseView action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:yesButton];
}

@end
