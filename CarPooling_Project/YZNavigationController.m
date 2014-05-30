//
//  YZNavigationController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZNavigationController.h"

@interface YZNavigationController ()

@end

@implementation YZNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark 屏幕旋转

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

#endif

@end
