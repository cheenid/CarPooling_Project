//
//  SwitchRouteViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-19.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "SwitchRouteViewController.h"
#import "NewRouteViewController.h"

@interface SwitchRouteViewController ()

@end

@implementation SwitchRouteViewController

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"切换路线";
    }
    return self;
}

#pragma mark -
#pragma mark loadView

- (void)loadView
{
    [super loadView];
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)initRightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 34)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:@"新建路线" forState:UIControlStateNormal];
    [button setTitle:@"新建路线" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToNewCreate) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)initCenterButton
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(20, 40, 280, 34)];
    [button1 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button1 setTitle:@"上班路线" forState:UIControlStateNormal];
    [button1 setTitle:@"上班路线" forState:UIControlStateHighlighted];
    [button1.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [button1.layer setBorderWidth:1.0];
    [button1 addTarget:self action:@selector(clickOnWorkRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(20, 90, 280, 34)];
    [button2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button2 setTitle:@"下班路线" forState:UIControlStateNormal];
    [button2 setTitle:@"下班路线" forState:UIControlStateHighlighted];
    [button2.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [button2.layer setBorderWidth:1.0];
    [button2 addTarget:self action:@selector(clickoffWorkRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setFrame:CGRectMake(20, 140, 280, 34)];
    [button3 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button3 setTitle:@"当天路线" forState:UIControlStateNormal];
    [button3 setTitle:@"当天路线" forState:UIControlStateHighlighted];
    [button3.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [button3.layer setBorderWidth:1.0];
    [button3 addTarget:self action:@selector(clickToDayRoute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtonItem];
    [self initCenterButton];
}

#pragma mark -
#pragma mark UIButton 点击

- (void)clickToNewCreate
{
    NewRouteViewController *newRouteVC = [[NewRouteViewController alloc]init];
    [self.navigationController pushViewController:newRouteVC animated:YES];
    newRouteVC = nil;
}

- (void)clickOnWorkRoute
{
    
}
- (void)clickoffWorkRoute
{
    
}
- (void)clickToDayRoute
{
    
}
@end
