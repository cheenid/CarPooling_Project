//
//  PointsViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "PointsViewController.h"
#import "PointsDetailViewController.h"
#import "ExchangeViewController.h"
#import "PresentViewController.h"

#import "CPHttpRequest.h"

@interface PointsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger myPoints;
@end

@implementation PointsViewController

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
        self.title = @"我的积分";
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

- (void)getMyTotalPoints
{
    [[CPHttpRequest sharedInstance]requestTotalScore:^(id responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            _myPoints = [responseObject[@"score"]integerValue];
            [self.tableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self getMyTotalPoints];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
        cell.textLabel.text = [NSString stringWithFormat:@"我的积分：%d",(int)_myPoints];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"我要充值";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"我的馈赠";
    }
    else
    {
        cell.textLabel.text = @"兑换积分";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        PointsDetailViewController *pointDetailVC = [[PointsDetailViewController alloc]init];
        [self.navigationController pushViewController:pointDetailVC animated:YES];
        pointDetailVC = nil;
    }
    else if (indexPath.row == 1)
    {
        
    }
    else if (indexPath.row == 2)
    {
        ExchangeViewController *exchangeVC = [[ExchangeViewController alloc]init];
        [self.navigationController pushViewController:exchangeVC animated:YES];
        exchangeVC = nil;
    }
    else
    {
        PresentViewController *presentVC = [[PresentViewController alloc]init];
        [self.navigationController pushViewController:presentVC animated:YES];
        presentVC = nil;
    }
}

@end
