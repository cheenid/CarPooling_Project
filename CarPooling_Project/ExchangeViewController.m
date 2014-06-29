//
//  ExchangeViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "ExchangeViewController.h"
#import "CPHttpRequest.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController
#pragma mark -
#pragma mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"积分兑换";
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CPHttpRequest sharedInstance]requestGiftList:1 size:100 success:^(id responseObject) {
        
    } failture:^(NSError *error) {
        
    }];
}




@end
