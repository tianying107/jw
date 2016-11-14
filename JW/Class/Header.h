//
//  Header.h
//  JW
//
//  Created by Star Chen on 11/13/16.
//  Copyright © 2016 Star Chen. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define basicURL @"https://jzw-bogong17.c9users.io/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define goColor1 UIColorFromRGB(0x50514F)
#define goColor2 UIColorFromRGB(0x247BA0)
#define goColor3 UIColorFromRGB(0xB5B5B7)
#define goColor4 UIColorFromRGB(0xECB363)
#define goColor5 UIColorFromRGB(0x70C1B3)
#define goBackgroundColorExtraLight UIColorFromRGB(0xFAFAFA)
#define goSeparator UIColorFromRGB(0xF2F2F2)

#define goSeperatorHeight 2

#define goFont13T [UIFont fontWithName:@"SFUIDisplay-Light" size:13]
#define goFont13S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13]
#define goFont13B [UIFont fontWithName:@"SFUIDisplay-Bold" size:13]
#define goFont13 [UIFont fontWithName:@"SFUIDisplay-Regular" size:13]

#define goFont15 [UIFont fontWithName:@"SFUIDisplay-Regular" size:15]
#define goFont15M [UIFont fontWithName:@"SFUIDisplay-Medium" size:15]
#define goFont15S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:15]
#define goFont15B [UIFont fontWithName:@"SFUIDisplay-Bold" size:15]

#define goFont18 [UIFont fontWithName:@"SFUIDisplay-Regular" size:18]
#define goFont18M [UIFont fontWithName:@"SFUIDisplay-Medium" size:18]
#define goFont18S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:18]
#define goFont18B [UIFont fontWithName:@"SFUIDisplay-Bold" size:18]

#define goFont20S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:20]
#define goFont20 [UIFont fontWithName:@"SFUIDisplay-Regular" size:20]

#define goFont30T [UIFont fontWithName:@"SFUIDisplay-Thin" size:30]
#define goFont30 [UIFont fontWithName:@"SFUIDisplay-Regular" size:30]
#define goFont30S [UIFont fontWithName:@"SFUIDisplay-Semibold" size:30]


#import "goCell.h"
#import "goPinMap.h"
#import "goSuscard.h"
#import "goTextField.h"
#endif /* Header_h */
