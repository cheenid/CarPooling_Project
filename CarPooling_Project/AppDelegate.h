//
//  AppDelegate.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabbarController;
@property (nonatomic, strong) BMKMapManager *mapManager;
@end
