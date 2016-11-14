//
//  FirstViewController.m
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import "shareListViewController.h"

@interface shareListViewController ()

@end

@implementation shareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    idList = [[NSArray alloc] init];
    basicViewArray = [NSMutableArray new];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  [self requestShareListWithCondition:@""];
              }
     ];

    _shareList.delegate = self;
    _shareList.dataSource = self;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestShareListWithCondition:(NSString*)conditionString{
    NSString *requestQuery = [NSString stringWithFormat:@"%@latitude=%f&longitude=%f",conditionString,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude];
    NSString *urlString = [NSString stringWithFormat:@"%@tcrlist?%@",basicURL,requestQuery];
    NSLog(@"%@",requestQuery);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        NSLog(@"server said: %@",string);
                                        idList = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:kNilOptions
                                                                                   error:&error];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            idList = [NSArray arrayWithObjects:@"1",@"2", nil];
                                            [_shareList reloadData];
//                                            goSuscard *baseView = [currentWindow viewWithTag:3360];
//                                            [baseView cancelResponse];
                                        });
                                    }];
    [task resume];
    
}
//** the number of section and rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [idList count];
}
//** cell detail
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tcrList";
    goCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[goCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [NSString stringWithFormat:@"Share %ld",indexPath.row];
//    cell.backgroundColor = goBackgroundColorExtraLight;
//
//    if ((indexPath.row+1)>basicViewArray.count) {
//        goTCRBasic *basicView = [[goTCRBasic alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100) basic:[idList objectAtIndex:indexPath.row]];
//        [basicViewArray addObject:basicView];
//        [cell setBasicView:basicView];
//    }
//    else{
//        [cell setBasicView:[basicViewArray objectAtIndex:indexPath.row]];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    homePageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
    
//    NSString*teacherID = [(NSDictionary*)[idList objectAtIndex:indexPath.row] valueForKey:@"id"];
//    //        TeacherPersonalViewController* selectedTeacherPersonalView = [self.storyboard instantiateViewControllerWithIdentifier:@"tcrDetail"];
//    //    selectedTeacherPersonalView.selectedTeacherID = teacherID;
//    //    [self.navigationController pushViewController:selectedTeacherPersonalView animated:YES];
//    goPersonMajorViewController *viewController = [goPersonMajorViewController new];
//    viewController.selectedTeacherID = teacherID;
//    viewController.clearNavigationBar = NO;
//    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
