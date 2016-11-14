//
//  MapPin.m
//  Sgolar
//
//  Created by st chen on 15/9/30.
//  Copyright © 2015年 st chen. All rights reserved.
//

#import "MapPin.h"
@implementation MapPin
@synthesize coordinate,title,subtitle;
+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([MapPin class])];
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation
                                     reuseIdentifier:NSStringFromClass([MapPin class])];
        
        returnedAnnotationView.canShowCallout = YES;
        
        // offset the flag annotation so that the flag pole rests on the map coordinate
        returnedAnnotationView.centerOffset = CGPointMake( returnedAnnotationView.centerOffset.x, returnedAnnotationView.centerOffset.y - 24);// - returnedAnnotationView.image.size.height/2
    }
    else
    {
        returnedAnnotationView.annotation = annotation;
    }
    return returnedAnnotationView;
}
+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation height:(float)height
{
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([MapPin class])];
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation
                                     reuseIdentifier:NSStringFromClass([MapPin class])];
        
        returnedAnnotationView.canShowCallout = YES;
        
        // offset the flag annotation so that the flag pole rests on the map coordinate
        returnedAnnotationView.centerOffset = CGPointMake( returnedAnnotationView.centerOffset.x, returnedAnnotationView.centerOffset.y - height);// - returnedAnnotationView.image.size.height/2
    }
    else
    {
        returnedAnnotationView.annotation = annotation;
    }
    return returnedAnnotationView;
}
@end
