//
//  AppDelegate.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "YZNavigationController.h"
#import "MessageViewController.h"
#import "CarPoolViewController.h"
#import "MatchViewController.h"
#import "PointsViewController.h"
#import "LoginViewController.h"
#import "CPHttpRequest.h"
#import "YZKeyChainManager.h"

@interface AppDelegate() 

@end


@implementation AppDelegate


- (void)initTabbarController
{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    YZNavigationController *YZMessageNav = [[YZNavigationController alloc]initWithRootViewController:messageVC];
    YZMessageNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的消息" image:[UIImage imageNamed:@"Tabbar_Message"] tag:0];
    
    CarPoolViewController *carPoolVC = [[CarPoolViewController alloc]init];
    YZNavigationController *YZCarPoolNav = [[YZNavigationController alloc]initWithRootViewController:carPoolVC];
    YZCarPoolNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的拼车" image:[UIImage imageNamed:@"Tabbar_Carpool"] tag:1];
    
    MatchViewController *matchVC = [[MatchViewController alloc]init];
    YZNavigationController *YZMatchNav = [[YZNavigationController alloc]initWithRootViewController:matchVC];
    YZMatchNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"匹配路线" image:[UIImage imageNamed:@"Tabbar_Match"] tag:0];
    
    PointsViewController *pointsVC = [[PointsViewController alloc]init];
    YZNavigationController *YZPointsNav = [[YZNavigationController alloc]initWithRootViewController:pointsVC];
    YZPointsNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的积分" image:[UIImage imageNamed:@"Tabbar_Points"] tag:0];
    NSArray *viewControllers = [NSArray arrayWithObjects:YZMessageNav,YZCarPoolNav,YZMatchNav,YZPointsNav, nil];
    
    [self customNavBarBg];
    
    _tabbarController = [[UITabBarController alloc]init];
    _tabbarController.viewControllers = viewControllers;
    [_tabbarController setSelectedIndex:2];
    [[UITabBar appearance]setSelectedImageTintColor:[UIColor colorWithRed:0.886 green:0.318 blue:0.259 alpha:1.0]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                       dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0.886 green:0.318 blue:0.259 alpha:1.0],
                                                       UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
    self.window .rootViewController = _tabbarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initTabbarController];
    
    NSString *mobileNo = [[YZKeyChainManager defaultManager]keychainValueForKey:KMobileNO];
    NSString *password = [[YZKeyChainManager defaultManager]keychainValueForKey:KPassword];
    
    if ( !mobileNo || !password )
    {
        [self performSelector:@selector(switchToLogin) withObject:nil afterDelay:0.1];
    }
    else
    {
        __block typeof(self) bself = self;
        [[CPHttpRequest sharedInstance]requestAutoLogin:mobileNo
                                               password:password
                                                success:^(id responseObject) {
            
        } failture:^(NSError *error) {
            // 自动登陆失败，进入登陆页面
            [bself performSelector:@selector(switchToLogin) withObject:nil afterDelay:0.1];
        }];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)switchToLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    YZNavigationController *YZNavVC = [[YZNavigationController alloc]initWithRootViewController:loginVC];
    [self.tabbarController.selectedViewController presentViewController:YZNavVC animated:NO completion:^{
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


- (void)initNavBarTitleStyle
{
    UIColor *textColor = [UIColor colorWithRed:245.0/255.0
                                         green:245.0/255.0
                                          blue:245.0/255.0 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 60000)
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               textColor, NSForegroundColorAttributeName,
                                                               shadow, NSShadowAttributeName,
                                                               font, NSFontAttributeName, nil]];
#endif
    }
    else
    {
        UIColor *shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        NSValue *value =  [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              textColor,UITextAttributeTextColor,
                              font,UITextAttributeFont,
                              shadowColor,UITextAttributeTextShadowColor,
                              value,UITextAttributeTextShadowOffset,nil];
        [[UINavigationBar appearance] setTitleTextAttributes:dict];
    }
}

- (void)customNavBarBg
{
    [self initNavBarTitleStyle];
    // 自定义导航栏标题
    NSString *imageName = iOS7 ? @"navBar_ios7" :@"navBar";
    UIImage *navBarImage = [UIImage imageNamed:imageName];
    [[UINavigationBar appearance]setBackgroundImage:navBarImage forBarMetrics: UIBarMetricsDefault];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
