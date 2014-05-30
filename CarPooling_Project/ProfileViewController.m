//
//  ProfileViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProfileViewController

#pragma mark -
#pragma mark dealloc

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
        self.title = @"个人信息";
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

- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        
        CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 114);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}



#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"个人信息";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"身份认证";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"头像认证";
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"驾驶证认证";
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"行驶证认证";
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"我的爱车";
    }
    else
    {
        cell.textLabel.text = @"关于";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
