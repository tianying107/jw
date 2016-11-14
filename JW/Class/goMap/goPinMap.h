//
//  goPinMap.h
//  goTalk
//
//  Created by st chen on 16/6/19.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Header.h"
#import "MapPin.h"
@class goPinMap;
@protocol goPinMapDelegate <NSObject>

- (void)mapView:(goPinMap*)mapView locateBeingChanging:(BOOL)changing;

@end
@interface goPinMap : MKMapView<CLLocationManagerDelegate, MKMapViewDelegate,UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *regionCenterArray;
    UILabel *locationLabel;
    NSInteger distance;
//    
//    /**
//     *search address
//     */
//    goSuscard *searchBarView;
//    NSArray *searchResultArray;
//    UITableView *resultTableView;
    BOOL isSearching;
}
- (id)initWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude;
- (void)firstPlaceAddress:(UILabel*)label;
- (NSArray*)firstPlaceAddress;
- (void)setWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude address:(BOOL)addressBool;
- (void)setLatitude:(float)latitude longitude:(float)longitude address:(BOOL)addressBool;
- (void)initLocalWithItem:(MKMapItem*)mapItem;
- (void)addCircleWithDistanse:(NSInteger)distance;
- (void)addCircleWithDistanse:(NSInteger)distance constantRegion:(BOOL)constant;
- (void)setCurrentLocationWithAddress:(BOOL)addressBool;
- (void)removeAnnotations;
- (void)moveToLatitude:(float)latitude longitude:(float)longitude;
- (IBAction)location:(id)sender;

@property NSArray *addressArray;
@property NSMutableArray *locationSelected;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLLocationCoordinate2D lastSelectCoordinate;

/**
 *SHOW THE STORE LOCATION AFTER SELECT MEETING LOCATION
 */
-(void)showStoreWithItem:(MKMapItem*)mapItem;
/**
 *fixed pin point
 *used in tcr set active location and range
 */
- (void)setAddressCenter;
- (void)setFixedPin:(BOOL)isFixed;
@property (nonatomic, weak) id <goPinMapDelegate> pinDelegate;
@property BOOL movingPin;
@property MKMapItem *selelctMapItem;
@property UIImageView *fixedPinView;

/**
 *search address
 */
- (void)setupSearchBar;
- (void)searchViewShowUp;
@property UITextField *searchBar;
@end
