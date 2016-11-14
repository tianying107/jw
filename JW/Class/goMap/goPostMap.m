//
//  goPostMap.m
//  goTalk
//
//  Created by st chen on 16/10/21.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import "goPostMap.h"
@implementation goPostMap
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
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
        [self mapInit];
    }
    return self;
}
- (void)mapInit{
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude= self.locationManager.location.coordinate.longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    self.delegate = self;
    [self setRegion:region];
    self.scrollEnabled = YES;
    self.zoomEnabled = YES;
    self.showsUserLocation = YES;
    self.showsBuildings = YES;
    self.pitchEnabled = YES;
    self.tintColor = goColor4;
    pinIndex = 0;
    placemarkArray = [NSMutableArray new];
    normalPin =[UIImage imageNamed:@"mapPoint"];
    selectedPin = [UIImage imageNamed:@"selectedPin"];
}
- (goAnnotationView *)mapView:(MKMapView *)tmapView viewForAnnotation:(id <MKAnnotation>)annotation{
    goAnnotationView *pinView = nil;
    if ([annotation isKindOfClass:[MapPin class]]){
        MapPin *mapPin = annotation;
        pinView = (goAnnotationView*)[MapPin createViewAnnotationForMapView:self annotation:annotation height:20];
        pinView.image = normalPin;
        pinView.canShowCallout = NO;
        pinView.tag = mapPin.index;
        
//        pinIndex++;
    }
    return pinView;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [self.goDelegate postMap:self didSelectedJobPin:view mapItem:[placemarkArray objectAtIndex:view.tag]];
    view.image = selectedPin;
    if (previousSelectedPin) {
        previousSelectedPin.image = normalPin;
    }
    previousSelectedPin = view;
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self.goDelegate postMap:self didDeselectedJobPin:view mapItem:[placemarkArray objectAtIndex:view.tag]];
    if (previousSelectedPin) {
        previousSelectedPin.image = normalPin;
        previousSelectedPin = nil;
    }
}

- (void)addMapItemAnnotation:(MKMapItem*)mapItem{
    float latitude = [[mapItem placemark] location].coordinate.latitude;
    float longitude = [[mapItem placemark] location].coordinate.longitude;
    
    MapPin *localPin=[[MapPin alloc] init];
    localPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    localPin.index = pinIndex;
//    jobPin.orderDict = placemark;
    [placemarkArray insertObject:mapItem atIndex:pinIndex];
    [self addAnnotation:localPin];
    //    [self selectAnnotation:jobPin animated:NO];
    pinIndex++;
}
- (void)removeAnnotations{
    NSArray* existAnnotationPoints = self.annotations;
    if (existAnnotationPoints.count) {
        [self removeAnnotations:existAnnotationPoints];
    }
    pinIndex = 0;
    placemarkArray = [NSMutableArray new];
}
- (void)addCircleWithDistanse:(float)tdistance latitude:(float)latitude longitude:(float)longitude{
    distance = tdistance;
    CLLocationDistance fenceDistance = distance*1000;
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = latitude;
    region.center.longitude= longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    
    [self addOverlay:circle];
}
- (void)removeCircles{
    NSArray *existOverlays = self.overlays;
    [self removeOverlays:existOverlays];
}
- (void)setLocationWithLatitude:(float)latitude longitude:(float)longitude{
    MKCoordinateRegion region = { {0.0, 0.0},{0.0,0.0}};
    region.center.latitude = latitude;
    region.center.longitude= longitude;
    double scalingFactor = ABS( (cos(2 * M_PI * region.center.latitude / 360.0) ));
    region.span.latitudeDelta = 5/69.0;
    region.span.longitudeDelta = 5/(scalingFactor * 69.0);
    [self setRegion:region animated:YES];
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circleR.fillColor = goColor5;
    circleR.alpha=0.3;
    return circleR;
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
@end
