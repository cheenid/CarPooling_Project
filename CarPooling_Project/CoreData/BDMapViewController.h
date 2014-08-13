//
//  BDMapViewController.h
//  BaiduMap
//
//  Created by 马远征 on 14-6-30.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKCityNodesType.h"

typedef void (^completePoiSearch)(MplcCityNode node);

@interface BDMapViewController : UIViewController
- (id)initWithCityNode:(NSDictionary*)cityNode;
- (void)setCompletePoiSearch:(completePoiSearch)poiSearch;
@end
