//
//  MyCarViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-31.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "MyCarViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "CPHttpRequest.h"
#import "YZTextField.h"
#import "YZProgressHUD.h"

@interface MyCarViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) YZTextField *carTypeTextField;
@property (nonatomic, strong) YZTextField *carColorsTextField;
@property (nonatomic, strong) YZTextField *carNumberTextField;
@property (nonatomic, strong) YZTextField *carSeatsTextField;
@end

@implementation MyCarViewController

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
        self.title = @"我的爱车";
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

- (TPKeyboardAvoidingTableView*)tableView
{
    if (_tableView == nil)
    {
        CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (YZTextField*)carTypeTextField
{
    if (_carTypeTextField == nil)
    {
        _carTypeTextField = [[YZTextField alloc]initWithFrame:CGRectMake(80, 7, 210, 30)];
        _carTypeTextField.placeholder = @"爱车型号";
        _carTypeTextField.backgroundColor = [UIColor clearColor];
        _carTypeTextField.textColor = [UIColor blackColor];
        _carTypeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _carTypeTextField.leftViewMode = UITextFieldViewModeAlways;
        _carTypeTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _carTypeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carTypeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _carTypeTextField;
}

- (YZTextField*)carColorsTextField
{
    if (_carColorsTextField == nil)
    {
        _carColorsTextField = [[YZTextField alloc]initWithFrame:CGRectMake(80, 7, 210, 30)];
        _carColorsTextField.placeholder = @"爱车颜色";
        _carColorsTextField.backgroundColor = [UIColor clearColor];
        _carColorsTextField.textColor = [UIColor blackColor];
        _carColorsTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _carColorsTextField.leftViewMode = UITextFieldViewModeAlways;
        _carColorsTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _carColorsTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carColorsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _carColorsTextField;
}

- (YZTextField*)carNumberTextField
{
    if (_carNumberTextField == nil)
    {
        _carNumberTextField = [[YZTextField alloc]initWithFrame:CGRectMake(80, 7, 210, 30)];
        _carNumberTextField.placeholder = @"爱车车牌号";
        _carNumberTextField.backgroundColor = [UIColor clearColor];
        _carNumberTextField.textColor = [UIColor blackColor];
        _carNumberTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _carNumberTextField.leftViewMode = UITextFieldViewModeAlways;
        _carNumberTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _carNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _carNumberTextField;
}

- (YZTextField*)carSeatsTextField
{
    if (_carSeatsTextField == nil)
    {
        _carSeatsTextField = [[YZTextField alloc]initWithFrame:CGRectMake(80, 7, 210, 30)];
        _carSeatsTextField.placeholder = @"爱车座位数";
        _carSeatsTextField.backgroundColor = [UIColor clearColor];
        _carSeatsTextField.textColor = [UIColor blackColor];
        _carSeatsTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _carSeatsTextField.leftViewMode = UITextFieldViewModeAlways;
        _carSeatsTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _carSeatsTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _carSeatsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _carSeatsTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _carSeatsTextField;
}


- (void)initRightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 34)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:@"更新" forState:UIControlStateNormal];
    [button setTitle:@"更新" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToUpload) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self initRightBarButtonItem];
    [self updateContentView];
}

#pragma mark -
#pragma mark updateContentView

- (void)updateContentView
{
    NSString *mobileNo = [[YZKeyChainManager defaultManager]keychainValueForKey:KMobileNO];
    PersonalData *personalData =  [[YZDataBaseMgr sharedManager]personalDataSortByAccountID:mobileNo];
    if (personalData.carType)
    {
        self.carTypeTextField.text = [NSString stringWithFormat:@"%@",personalData.carType];
    }
    if (personalData.carColor)
    {
        self.carColorsTextField.text = [NSString stringWithFormat:@"%@",personalData.carColor];
    }
    if (personalData.carNumber)
    {
        self.carNumberTextField.text = [NSString stringWithFormat:@"%@",personalData.carNumber];
    }
    if (personalData.carSeats)
    {
        self.carSeatsTextField.text = [NSString stringWithFormat:@"%@",personalData.carSeats];
    }
}


#pragma mark -
#pragma mark UIControl Action

- (void)clickToUpload
{
    [self.view endEditing:YES];
    
    if (_carTypeTextField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window
                                        labelText:nil
                                       detailText:@"请输入爱车类型"];
        return;
    }
    
    if (_carColorsTextField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window
                                        labelText:nil
                                       detailText:@"请输入爱车颜色"];
        return;
    }
    
    if (_carNumberTextField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window
                                        labelText:nil
                                       detailText:@"请输入爱车车牌"];
        return;
    }
    
    if (_carSeatsTextField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window
                                        labelText:nil
                                       detailText:@"请输入爱车座位"];
        return;
    }
    
    [[YZProgressHUD progressHUD]showOnWindow:self.view.window labelText:@"正在上传" detailText:nil];
    
    WEAKSELF;
    [[CPHttpRequest sharedInstance]requestUploadCarProfile:_carTypeTextField.text
                                                 carColors:_carColorsTextField.text
                                                 carNumber:_carNumberTextField.text
                                                  carSeats:_carSeatsTextField.text
                                                   success:^(id responseObject) {
                                                       
                                                       if ([responseObject isKindOfClass:[NSDictionary class]])
                                                       {
                                                           NSInteger statusCode = [[responseObject objectForKey:@"statusCode"]integerValue];
                                                           if (statusCode == 1)
                                                           {
                                                               [weakSelf hideWithSuccess];
                                                           }
                                                           
                                                           if (statusCode == -1)
                                                           {
                                                               //上传失败
                                                               [weakSelf hideWithError];
                                                           }
                                                           
                                                           if (statusCode == -2)
                                                           {
                                                               // session过期
                                                                [weakSelf restartLogin];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           [weakSelf hideWithError];
                                                       }
        
    } failture:^(NSError *error) {
        
        [weakSelf hideWithError];
        
    }];
}

- (void)hideWithError
{
     [[YZProgressHUD progressHUD]hideWithError:@"上传失败" detailText:nil];
}

- (void)hideWithSuccess
{
    [[YZProgressHUD progressHUD]hideWithSuccess:@"上传成功" detailText:nil];
}

- (void)restartLogin
{
    NSString *mobileNo = [[YZKeyChainManager defaultManager]keychainValueForKey:KMobileNO];
    NSString *password = [[YZKeyChainManager defaultManager]keychainValueForKey:KPassword];
    WEAKSELF;
    [[CPHttpRequest sharedInstance]requestAutoLogin:mobileNo password:password success:^(id responseObject) {
        
        NSInteger statusCode = [[responseObject objectForKey:@"statusCode"]integerValue];
        if (statusCode == 1)
        {
            [[YZProgressHUD progressHUD]hide];
            [weakSelf clickToUpload];
        }
        else
        {
            [weakSelf hideWithError];
        }
        
    } failture:^(NSError *error) {
        
        [weakSelf hideWithError];
        
    }];
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
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"型号";
        [cell.contentView addSubview:self.carTypeTextField];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"颜色";
        [cell.contentView addSubview:self.carColorsTextField];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"车牌";
        [cell.contentView addSubview:self.carNumberTextField];
    }
    else
    {
        cell.textLabel.text = @"座位数";
        [cell.contentView addSubview:self.carSeatsTextField];
    }
    return cell;
}
@end
