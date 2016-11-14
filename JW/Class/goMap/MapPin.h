//
//  MapPin.h
//  Sgolar
//
//  Created by st chen on 15/9/30.
//  Copyright © 2015年 st chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapPin : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString* title;
    NSString* subtitle;
//    UIButton* agree
}
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSString* subtitle;

@property(nonatomic, weak) NSDictionary *orderDict;
//@property (nonatomic, retain) UIButton *agreeButton;
//@property
@property NSInteger index;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;
+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation height:(float)height;
@end
