//
//  ProfileViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyInfoViewController.h"
#import "IdentityCerViewController.h"
#import "AvatarCerViewController.h"
#import "DrivelicenceViewController.h"
#import "MyCarViewController.h"
#import "AboutViewController.h"
#import "CarlicenceViewController.h"
#import "CPHttpRequest.h"
#import "CoreData/DataBase/YZDataBaseMgr.h"


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
        self.title = @"我的资料";
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
        CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)initTableFooterView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    
    UIImage *normalImage = [UIImage imageNamed:@"carpool_logout_normal"];
    UIImage *pressImage = [UIImage imageNamed:@"carpool_logout_press"];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:86 topCapHeight:22];
    pressImage = [pressImage stretchableImageWithLeftCapWidth:86 topCapHeight:22];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame: CGRectMake(10, 5, 300, 44)];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:pressImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToLogout) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:@"注销" forState:UIControlStateNormal];
    [button setTitle:@"注销" forState:UIControlStateHighlighted];
    
    [footerView addSubview:button];
    [self.tableView.tableFooterView setFrame:footerView.frame];
    [self.tableView setTableFooterView:footerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestMyInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self initTableFooterView];
}

#pragma mark -
#pragma mark 获取个人信息
- (void)enumerationDic:(NSDictionary*)retDic withDic:(NSMutableDictionary*)paramsDic
{
    if (paramsDic == nil || retDic == nil)
    {
        return;
    }
    
    for (id key in [retDic allKeys])
    {
        id object = retDic[key];
        if ([object isKindOfClass:[NSDictionary class]])
        {
             [self enumerationDic:object withDic:paramsDic];
        }
        else
        {
            [paramsDic setObject:object forKey:key];
        }
    }
}

- (NSMutableDictionary*)enumerationDictionary:(NSDictionary*)retDic
{
    if (retDic == nil)
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self enumerationDic:retDic withDic:params];
    return params;
}

- (void)requestMyInfo
{
    [[CPHttpRequest sharedInstance]requestMyInfo:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSInteger statusCode = [responseObject[@"statusCode"]integerValue];
            if (statusCode == 1)
            {
                NSDictionary *user = responseObject[@"user"];
                if (user)
                {
                    NSMutableDictionary *parmas = [self enumerationDictionary:user];
                    if (parmas)
                    {
                        NSLog(@"---params---%@",parmas);
                        YZDataBaseMgr *dbMgr = [YZDataBaseMgr sharedManager];
                        [dbMgr insertOrUpdatePersonalData:parmas
                                                 complete:^(NSManagedObject *object, BOOL ret) {
                                                     if (ret)
                                                     {
                                                         NSLog(@"----插入/更新成功--");
                                                     }
                        }];
                    }
                }
            }
        }
        
    } failture:^(NSError *error) {
        
    }];
}


- (void)clickToLogout
{
    
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
    if (indexPath.row == 0)
    {
        MyInfoViewController *myInfoVC = [[MyInfoViewController alloc]init];
        [self.navigationController pushViewController:myInfoVC animated:YES];
        myInfoVC = nil;
    }
    else if (indexPath.row == 1)
    {
        IdentityCerViewController *identifyCerVC = [[IdentityCerViewController alloc]init];
        [self.navigationController pushViewController:identifyCerVC animated:YES];
        identifyCerVC = nil;
    }
    else if (indexPath.row == 2)
    {
        AvatarCerViewController *avatarCerVC = [[AvatarCerViewController alloc]init];
        [self.navigationController pushViewController:avatarCerVC animated:YES];
        avatarCerVC = nil;
    }
    else if (indexPath.row == 3)
    {
        DrivelicenceViewController *drivelicenceVC = [[DrivelicenceViewController alloc]init];
        [self.navigationController pushViewController:drivelicenceVC animated:YES];
        drivelicenceVC = nil;
    }
    else if (indexPath.row == 4)
    {
        CarlicenceViewController *carLicenceVC = [[CarlicenceViewController alloc]init];
        [self.navigationController pushViewController:carLicenceVC animated:YES];
        carLicenceVC = nil;
    }
    else if (indexPath.row == 5)
    {
        MyCarViewController *myCarVC = [[MyCarViewController alloc]init];
        [self.navigationController pushViewController:myCarVC animated:YES];
        myCarVC = nil;
    }
    else
    {
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        aboutVC = nil;
    }
}

@end
