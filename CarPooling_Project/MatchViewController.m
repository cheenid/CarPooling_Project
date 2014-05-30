//
//  MatchViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "MatchViewController.h"
#import "ProfileViewController.h"

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

- (void)initBarButtonItem
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBarButtonItem];
}

- (void)leftBarBtnClick
{
    ProfileViewController *profileVC = [[ProfileViewController alloc]init];
    profileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
    profileVC = nil;
}



@end
