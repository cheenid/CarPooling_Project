//
//  CityNodeViewController.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-7.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKCityNodesType.h"

typedef void (^completeCitySelect)(MplcCityNode node);

@interface CityNodeViewController : UIViewController
- (void)setCompleteCitySelect:(completeCitySelect)citySelect;
@end
