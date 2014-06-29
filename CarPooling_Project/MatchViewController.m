//
//  MatchViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "MatchViewController.h"
#import "ProfileViewController.h"
#import "SwitchRouteViewController.h"

@interface MatchViewController ()

@end

@implementation MatchViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"匹配路线";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)initleftBarButtonItem
{
    UIImage *leftBtnImage = [UIImage imageNamed:@"btn_profile_image"];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 35, 35)];
    [leftButton setBackgroundImage:leftBtnImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    leftBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)initBarButtonItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 34)];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [leftButton setTitle:@"个人资料" forState:UIControlStateNormal];
    [leftButton setTitle:@"个人资料" forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 80, 34)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"切换路线" forState:UIControlStateNormal];
    [rightButton setTitle:@"切换路线" forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickToSwitchRoute) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBarButtonItem];
}

#pragma mark -
#pragma mark UIButton Action

- (void)leftBarBtnClick
{
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    profileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
    profileVC = nil;
}

- (void)clickToSwitchRoute
{
    SwitchRouteViewController *switchRouteVC = [[SwitchRouteViewController alloc]init];
    [self.navigationController pushViewController:switchRouteVC animated:YES];
    switchRouteVC = nil;
}

@end
