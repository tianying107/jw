//
//  FirstViewController.h
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Header.h"
#import "homePageViewController.h"
@interface shareListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, UISearchBarDelegate>{
    /**view relavent**/
    NSArray *idList;
    NSMutableArray *basicViewArray;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *shareList;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *homePageEditButton;

@end

