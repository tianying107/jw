//
//  goPinMap.m
//  goTalk
//
//  Created by st chen on 16/6/19.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import "goPinMap.h"
@interface goPinMap(){
    /**
     *search address
     */
    goSuscard *searchBarView;
    NSArray *searchResultArray;
    UITableView *resultTableView;
    UIButton *clearSearchButton;
}

@end
@implementation goPinMap
- (void)mapInit{
//    CLLocationDistance fenceDistance = 1*1000;
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = [[[regionCenterArray firstObject] firstObject] floatValue];
    region.center.longitude= [[[regionCenterArray firstObject] lastObject] floatValue];
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 0.62*1/69.0;
    region.span.longitudeDelta = 0.62*1/(scalingFactor * 69.0);
    self.delegate = self;
    [self setRegion:region];
    self.scrollEnabled = YES;
    self.zoomEnabled = YES;
    self.showsUserLocation = YES;
    self.showsBuildings = YES;
    self.pitchEnabled = YES;
    self.tintColor = goColor4;
    MapPin *userDroppedPin=[[MapPin alloc] init];
    userDroppedPin.coordinate=region.center;
    
    [self addAnnotation:userDroppedPin];
    [self selectAnnotation:userDroppedPin animated:NO];
}
- (id)initWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude{
    NSNumber *latitudeNumber = [[NSNumber alloc] initWithFloat:latitude];
    NSNumber *longitudeNumber = [[NSNumber alloc] initWithFloat:longitude];
    NSArray *array = [[NSArray alloc] initWithObjects:latitudeNumber, longitudeNumber, nil];
    regionCenterArray = [[NSMutableArray alloc] initWithObjects:array, nil];
    _movingPin = NO;
    self = [super initWithFrame:frame];
    if (self) {
        [self mapInit];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _movingPin = NO;
    }
    return self;
}
- (void)setWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude address:(BOOL)addressBool{
    NSNumber *latitudeNumber = [[NSNumber alloc] initWithFloat:latitude];
    NSNumber *longitudeNumber = [[NSNumber alloc] initWithFloat:longitude];
    NSArray *array = [[NSArray alloc] initWithObjects:latitudeNumber, longitudeNumber, nil];
    regionCenterArray = [[NSMutableArray alloc] initWithObjects:array, nil];
    
    self.frame = frame;
    
    [self mapInit];
    if (addressBool) {
    
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-270)/2, self.frame.size.height-50-20, 270, 50)];
        locationLabel.textColor = goColor1;
        locationLabel.numberOfLines = 2;
        [self firstPlaceAddressOrder:locationLabel];
        [self addSubview:locationLabel];
        locationLabel.textAlignment = NSTextAlignmentCenter;
        [locationLabel setFont:goFont13T];
        locationLabel.backgroundColor = [UIColor whiteColor];
        locationLabel.layer.cornerRadius = locationLabel.frame.size.height/2;
        locationLabel.clipsToBounds = YES;
    }
}
- (void)setLatitude:(float)latitude longitude:(float)longitude address:(BOOL)addressBool{
    _lastSelectCoordinate.longitude = longitude;
    _lastSelectCoordinate.latitude = latitude;
    NSNumber *latitudeNumber = [[NSNumber alloc] initWithFloat:latitude];
    NSNumber *longitudeNumber = [[NSNumber alloc] initWithFloat:longitude];
    NSArray *array = [[NSArray alloc] initWithObjects:latitudeNumber, longitudeNumber, nil];
    regionCenterArray = [[NSMutableArray alloc] initWithObjects:array, nil];
    
    [self mapInit];
    if (addressBool) {
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-270)/2, self.frame.size.height-50-20, 270, 50)];
        locationLabel.textColor = goColor1;
        locationLabel.numberOfLines = 2;
        [self firstPlaceAddressOrder:locationLabel];
        [self addSubview:locationLabel];
        locationLabel.textAlignment = NSTextAlignmentCenter;
        [locationLabel setFont:goFont13T];
        locationLabel.backgroundColor = [UIColor whiteColor];
        locationLabel.layer.cornerRadius = locationLabel.frame.size.height/2;
        locationLabel.clipsToBounds = YES;
    }
}
- (void)initLocalWithItem:(MKMapItem *)mapItem{
    NSLog(@"loc: %@",mapItem);
    _selelctMapItem = mapItem;
    [self setLatitude:mapItem.placemark.location.coordinate.latitude longitude:mapItem.placemark.location.coordinate.latitude address:YES];
}
- (void)setCurrentLocationWithAddress:(BOOL)addressBool{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [self setLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude address:addressBool];
}

- (void)moveToLatitude:(float)latitude longitude:(float)longitude{
    MKCoordinateRegion region = { {0.0, 0.0},{0.0,0.0}};
    region.center.latitude = latitude;
    region.center.longitude= longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    [self setRegion:region animated:YES];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)tmapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    pinView.tag = 104;
        if ([annotation isKindOfClass:[MapPin class]]){
            pinView = [MapPin createViewAnnotationForMapView:self annotation:annotation];
            pinView.image = [UIImage imageNamed:@"selectedPin"];
        }
    return pinView;
}
- (void)firstPlaceAddress:(UILabel*)label{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[regionCenterArray firstObject] firstObject] floatValue] longitude:[[[regionCenterArray firstObject] lastObject] floatValue]];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks firstObject];
//                  label.text =[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] firstObject];
                  label.text = [NSString stringWithFormat:@"%@ %@\n%@, %@\n%@",
                                        placemark.subThoroughfare, placemark.thoroughfare,
                                        placemark.locality,
                                        placemark.administrativeArea, placemark.postalCode
                                        ];
//                  returnAddress =[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
//                  [self remainderOfMethodHereUsingReturnAddress:returnAddress];
              }
     ];
}
- (void)firstPlaceAddressOrder:(UILabel*)label{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[regionCenterArray firstObject] firstObject] floatValue] longitude:[[[regionCenterArray firstObject] lastObject] floatValue]];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks firstObject];
                  label.text = [NSString stringWithFormat:@"%@ \n%@, %@",
//                                [placemark.addressDictionary valueForKey:@"Thoroughfare"],
                                [placemark.addressDictionary valueForKey:@"SubLocality"],
                                [placemark.addressDictionary valueForKey:@"City"],
                                [placemark.addressDictionary valueForKey:@"SubAdministrativeArea"]
                                ];
              }
     ];
}
- (NSArray*)firstPlaceAddress{
    self.locationSelected = [[NSMutableArray alloc] initWithObjects:(NSString *)@"0",(NSString *)@"1", (NSString *)@"2", (NSString *)@"3", nil];
    
    [self.locationSelected replaceObjectAtIndex:0 withObject:[[regionCenterArray firstObject] firstObject]];
    [self.locationSelected replaceObjectAtIndex:1 withObject:[[regionCenterArray firstObject] lastObject]];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[regionCenterArray firstObject] firstObject] floatValue] longitude:[[[regionCenterArray firstObject] lastObject] floatValue]];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks firstObject];
                  NSLog(@"placemark %@",placemark);
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                  //                  NSLog(@"addressDictionary %@", placemark.addressDictionary);
                  NSLog(@"location %@",placemark.name);
                  NSLog(@"Meeting at %@",locatedAt);
                  [self.locationSelected replaceObjectAtIndex:2 withObject:placemark.name];
                  [self.locationSelected replaceObjectAtIndex:3 withObject:locatedAt];
              }
     ];
    NSArray *array = self.locationSelected;
    return array;
}

- (void)addCircleWithDistanse:(NSInteger)tdistance{
    [self addCircleWithDistanse:tdistance constantRegion:NO];
}
- (void)addCircleWithDistanse:(NSInteger)tdistance constantRegion:(BOOL)constant{
    distance = tdistance;
    if (_movingPin && !isSearching)
        [self updateAddressWithDistance:locationLabel];
    CLLocationDistance fenceDistance = distance*1000;
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = [[[regionCenterArray firstObject] firstObject] floatValue];
    region.center.longitude= [[[regionCenterArray firstObject] lastObject] floatValue];
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 0.9*distance/69.0;
    region.span.longitudeDelta = 0.9*distance/(scalingFactor * 69.0);
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    
    [self addOverlay:circle];
    if (!constant) {
        [self setRegion:region];
    }
    
    
}

- (void)removeAnnotations{
    NSArray* existAnnotationPoints = self.annotations;
    if (existAnnotationPoints.count) {
        [self removeAnnotations:existAnnotationPoints];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay{
    MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circleR.fillColor = goColor5;
    circleR.alpha=0.3;
    return circleR;
}


- (void)mapUpdate{
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = [[[regionCenterArray firstObject] firstObject] floatValue];
    region.center.longitude= [[[regionCenterArray firstObject] lastObject] floatValue];
    region.span = self.region.span;
    [self setRegion:region];

    MapPin *userDroppedPin=[[MapPin alloc] init];
    userDroppedPin.coordinate=region.center;
    if (!_movingPin) {
        [self addAnnotation:userDroppedPin];
        [self selectAnnotation:userDroppedPin animated:NO];
    }
    
}
- (void)updateLatitude:(float)latitude longitude:(float)longitude address:(BOOL)addressBool{
    _lastSelectCoordinate.longitude = longitude;
    _lastSelectCoordinate.latitude = latitude;
    NSNumber *latitudeNumber = [[NSNumber alloc] initWithFloat:latitude];
    NSNumber *longitudeNumber = [[NSNumber alloc] initWithFloat:longitude];
    NSArray *array = [[NSArray alloc] initWithObjects:latitudeNumber, longitudeNumber, nil];
    regionCenterArray = [[NSMutableArray alloc] initWithObjects:array, nil];
    
    [self mapUpdate];
    if (addressBool) {
        if (_movingPin){
            if (!isSearching) [self updateAddressWithDistance:locationLabel];
            else [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(validSearchState) userInfo:nil repeats:NO];
        }
        else
            [self firstPlaceAddressOrder:locationLabel];
    }
}
- (IBAction)location:(id)sender{
    MKCoordinateRegion region = { {0.0, 0.0},{0.0,0.0}};
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude= self.locationManager.location.coordinate.longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    [self setRegion:region animated:YES];
}


/**
 *SHOW THE STORE LOCATION AFTER SELECT MEETING LOCATION
 */
-(void)showStoreWithItem:(MKMapItem*)mapItem{
    self.delegate = self;
    
    MKCoordinateRegion region = { {0.0, 0.0},{0.0,0.0}};
    region.center.latitude = mapItem.placemark.location.coordinate.latitude;
    region.center.longitude= mapItem.placemark.location.coordinate.longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 0.69/69.0;
    region.span.longitudeDelta = 0.69/(scalingFactor * 69.0);
    [self setRegion:region animated:YES];
    
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-270)/2, self.frame.size.height-50-20, 270, 50)];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.numberOfLines = 2;
    [self addSubview:locationLabel];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    [locationLabel setFont:goFont13B];
    locationLabel.backgroundColor = [goColor5 colorWithAlphaComponent:0.5];
    locationLabel.layer.cornerRadius = locationLabel.frame.size.height/2;
    locationLabel.clipsToBounds = YES;
    locationLabel.text = [NSString stringWithFormat:@"%@\n%@",[mapItem name],[mapItem.placemark.addressDictionary valueForKey:@"Street"]];

    [self removeAnnotations];
    MapPin *userDroppedPin=[[MapPin alloc] init];
    userDroppedPin.coordinate=region.center;
    [self addAnnotation:userDroppedPin];
    [self selectAnnotation:userDroppedPin animated:NO];
    
    
}


/**
 *fixed pin at the center of screen
 *used where tcr set active location and range
 */
-(void)setAddressCenter{
    locationLabel.frame = CGRectMake((self.frame.size.width-270)/2, self.frame.size.height/2-120, 270, 50);
    locationLabel.backgroundColor = goColor5;
    locationLabel.textColor = [UIColor whiteColor];
    [locationLabel setFont:goFont13B];
    locationLabel.numberOfLines = 0;
}
-(void)setFixedPin:(BOOL)isFixed{
    _movingPin = YES;
    [self removeAnnotations];
    _fixedPinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedPin"]];
    _fixedPinView.frame = CGRectMake((self.frame.size.width-21)/2, self.frame.size.height/2-42, 21, 42);
    [self addSubview:_fixedPinView];
    
    MKCoordinateRegion region = self.region;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 2/69.0;
    region.span.longitudeDelta = 2/(scalingFactor * 69.0);
    [self setRegion:region];
    
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (_movingPin) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.258];
        _fixedPinView.frame = CGRectMake((self.frame.size.width-21)/2, self.frame.size.height/2-42, 21, 42);
        [UIView commitAnimations];
        
        [self.pinDelegate mapView:self locateBeingChanging:NO];
        [self removeAnnotations];
        NSArray *existOverlays = self.overlays;
        [self removeOverlays:existOverlays];
        
        CGPoint centerPoint = mapView.center;
        CLLocationCoordinate2D centerMapCoordinate = [self convertPoint:centerPoint toCoordinateFromView:self];
        [self updateLatitude:centerMapCoordinate.latitude longitude:centerMapCoordinate.longitude address:YES];
        [self addCircleWithDistanse:distance constantRegion:YES];
    }
}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if (_movingPin) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.258];
        _fixedPinView.frame = CGRectMake((self.frame.size.width-21)/2, self.frame.size.height/2-62, 21, 42);
        [UIView commitAnimations];
        [self.pinDelegate mapView:self locateBeingChanging:YES];
    }
}
-(void)updateAddressWithDistance:(UILabel*)addressLabel{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[[regionCenterArray firstObject] firstObject] floatValue] longitude:[[[regionCenterArray firstObject] lastObject] floatValue]];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks firstObject];
                  addressLabel.text = [NSString stringWithFormat:@"Radius of %ld km around\n%@",
                                       (long)distance,
                                       [placemark.addressDictionary valueForKey:@"Name"]
                                       
//                                       [placemark.addressDictionary valueForKey:@"SubLocality"],
//                                       [placemark.addressDictionary valueForKey:@"City"],
//                                       [placemark.addressDictionary valueForKey:@"Thoroughfare"],
//                                       [placemark.addressDictionary valueForKey:@"Street"]
                                        //                                [placemark.addressDictionary valueForKey:@"Thoroughfare"],
                                ];
                  MKPlacemark *place = [[MKPlacemark alloc] initWithPlacemark:placemark];
                  _selelctMapItem = [[MKMapItem alloc] initWithPlacemark:place];
              }
     ];
}
-(void)updateAddressWithMapItem:(MKMapItem*)mapItem{
    _selelctMapItem = mapItem;
    locationLabel.text = [NSString stringWithFormat:@"Radius of %ld km around\n%@",
                         (long)distance,
                         mapItem.name
                         ];
}
-(void)validSearchState{
    isSearching = NO;
}





/*********************search section************************/

/*********************search section************************/
- (void)setupSearchBar{
    searchBarView = [[goSuscard alloc] initWithFullSize];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:searchBarView];
    searchBarView.hidden = YES;
    searchBarView.backButton.hidden = NO;
    searchBarView.cancelButton.hidden = YES;
    [searchBarView.backButton removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
    [searchBarView.backButton addTarget:self action:@selector(searchViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    [searchBarView.backButton setImage:[UIImage imageNamed:@"goBackShortColor5"] forState:UIControlStateNormal];
    
    _searchBar = [[goTextField alloc] initWithFrame:CGRectMake(100, 30, searchBarView.frame.size.width-120, 44)];
    _searchBar.textColor = goColor1;
    [_searchBar setFont:goFont15];
    [_searchBar addTarget:self action:@selector(searchBarContentChange) forControlEvents:UIControlEventEditingChanged];
    _searchBar.delegate = self;
    [searchBarView addSubview:_searchBar];
    
    clearSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(_searchBar.frame.origin.x+_searchBar.frame.size.width-44, _searchBar.frame.origin.y, 44, 44)];
    [clearSearchButton setImage:[UIImage imageNamed:@"cancelSmall"] forState:UIControlStateSelected];
    [clearSearchButton addTarget:self action:@selector(clearSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [searchBarView addSubview:clearSearchButton];
    
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 43, 19, 18)];
    searchIconImageView.image = [UIImage imageNamed:@"searchIconColor5"];
    [searchBarView addSubview:searchIconImageView];
    
    searchResultArray = [NSArray new];
    
    resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width, searchBarView.cardSize.height-90)];
    resultTableView.delegate = self;
    resultTableView.dataSource = self;
    resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    resultTableView.backgroundColor = goBackgroundColorExtraLight;
    [searchBarView addSubview:resultTableView];
}
- (void)searchViewShowUp{
    searchBarView.alpha = 0;
    searchBarView.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.258];
    searchBarView.alpha = 1;
    [UIView commitAnimations];
}
- (void)searchViewDismiss{
    searchBarView.hidden = YES;
    [_searchBar resignFirstResponder];
}
- (void)searchBarContentChange{
    clearSearchButton.selected = YES;
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    [searchRequest setNaturalLanguageQuery:_searchBar.text];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            searchResultArray = [response mapItems];
            [resultTableView reloadData];
        }
    }];
}
- (void)clearSearchBar{
    _searchBar.text = @"";
    clearSearchButton.selected = NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    [searchRequest setNaturalLanguageQuery:textField.text];
//    [searchRequest setRegion:mapView.region];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
//            for (MKMapItem *mapItem in [response mapItems]) {
//                [mapView addMapItemAnnotation:mapItem];
//            }
        }
    }];
    [textField resignFirstResponder];
    return YES;
}

//** the number of section and rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultArray count];
}
//** cell detail
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"resultList";
    goCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[goCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    MKMapItem *mapItem = [searchResultArray objectAtIndex:indexPath.row];
    UIView *basicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 65)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, basicView.frame.size.width-30, 20)];
    nameLabel.text =[mapItem name];
    nameLabel.textColor = goColor1;
    [nameLabel setFont:goFont15];
    [basicView addSubview:nameLabel];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 42, basicView.frame.size.width-30, 20)];
    addressLabel.text = [[[mapItem placemark] addressDictionary] valueForKey:@"Street"];
    addressLabel.textColor = goColor1;
    [addressLabel setFont:goFont15];
    [basicView addSubview:addressLabel];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(30, 65-goSeperatorHeight, basicView.frame.size.width-60, goSeperatorHeight)];
    separator.backgroundColor = goSeparator;
    [basicView addSubview:separator];
    [cell setBasicView:basicView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = goBackgroundColorExtraLight;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isSearching = YES;
    MKMapItem *mapItem = [searchResultArray objectAtIndex:indexPath.row];
    [self moveToLatitude:mapItem.placemark.location.coordinate.latitude longitude:mapItem.placemark.location.coordinate.longitude];
    [self updateAddressWithMapItem:mapItem];
    [self searchViewDismiss];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

@end
