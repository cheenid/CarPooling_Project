//
//  YZPullRefreshView.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YZRefreshType)
{
    YZPullUpToRefresh = -1,
    YZPullDownToRefresh = 1,
};

@interface YZPullRefreshView : UIView
@property (nonatomic, readonly, getter = isRefreshing) BOOL refreshing;
@end
