//
//  eatSignUpViewController.h
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "signUpHeader.h"
@interface eatSignUpViewController : UIViewController{
    goSuscard *currentSuscard;
    id firstView;
    NSMutableArray *viewArray;
    NSMutableArray *cardArray;
    NSMutableDictionary *infoSummary;
}

@end
