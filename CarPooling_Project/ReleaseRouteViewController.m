//
//  ReleaseRouteViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-10.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ReleaseRouteViewController.h"

@interface ReleaseRouteViewController ()
@property (nonatomic, strong) NSMutableDictionary *paramsDic;
@end

@implementation ReleaseRouteViewController
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
- (instancetype)initWithParams:(NSMutableDictionary*)paramsDic;
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        _paramsDic = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"发布路线";
    }
    return self;
}

#pragma mark -
#pragma mark loadView

- (void)loadView
{
    [super loadView];
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.961 alpha:1.0];
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
