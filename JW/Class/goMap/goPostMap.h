//
//  goPostMap.h
//  goTalk
//
//  Created by st chen on 16/10/21.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Header.h"
#import "MapPin.h"
#import "goAnnotationView.h"
@class goPostMap;
@protocol goPostMapDelegate <NSObject>

-(void)postMap:(goPostMap*)postMap didSelectedJobPin:(MKAnnotationView*)placemarkPin mapItem:(MKMapItem*)mapItem;
-(void)postMap:(goPostMap*)postMap didDeselectedJobPin:(MKAnnotationView*)placemarkPin mapItem:(MKMapItem*)mapItem;

@end
@interface goPostMap : MKMapView<CLLocationManagerDelegate, MKMapViewDelegate>{
    NSMutableArray *regionCenterArray;
    UILabel *locationLabel;
    float distance;
    NSInteger pinIndex;
    NSMutableArray *placemarkArray;
    
    UIImage *selectedPin;
    UIImage *normalPin;
    
    MKAnnotationView *previousSelectedPin;
}


///**
// * This method used to init this class and set the location as the center point.
// * No annotation will be add to the center point.
// */
//- (id)initWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude;
- (void)addMapItemAnnotation:(MKMapItem*)mapItem;
- (IBAction)location:(id)sender;
- (void)setLocationWithLatitude:(float)latitude longitude:(float)longitude;
- (void)removeAnnotations;
- (void)addCircleWithDistanse:(float)tdistance latitude:(float)latitude longitude:(float)longitude;
- (void)removeCircles;

@property (nonatomic, weak) id <goPostMapDelegate> goDelegate;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end
