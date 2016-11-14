//
//  goAnnotationView.h
//  goTalk
//
//  Created by st chen on 16/10/14.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import <MapKit/MapKit.h>
//#import "goOrderBasic.h"
@interface goAnnotationView : MKAnnotationView
@property (weak, nonatomic) NSDictionary *orderDict;
@end
