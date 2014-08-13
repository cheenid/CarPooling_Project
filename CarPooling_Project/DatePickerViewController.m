//
//  ReleaseRouteViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-19.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "DatePickerViewController.h"
#import "ReleaseRouteViewController.h"
#import "RepeatCyclePickerView.h"
#import "YZDatePicker.h"
#import "YZProgressHUD.h"

@interface DatePickerViewController ()
@property (nonatomic, strong) NSMutableDictionary *paramsDic;
@property (nonatomic, strong) UILabel *leaveTimeLabel;
@property (nonatomic, strong) UILabel *leaveDateLabel;
@property (nonatomic, strong) UILabel *backTimeLabel;
@property (nonatomic, strong) RepeatCyclePickerView *repeatCircleView;
@end

@implementation DatePickerViewController

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    _paramsDic = nil;
    _leaveDateLabel = nil;
    _leaveTimeLabel = nil;
    _backTimeLabel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark init

- (id)initWithPostParams:(NSDictionary*)params
{
    self = [super init];
    if (self)
    {
        self.paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"日期设置";
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

- (void)initRightBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 80, 34)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToNextStep) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}


- (void)initheaderlabels
{
    if (_paramsDic && [_paramsDic[@"routeType"]integerValue] == 3)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 34)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:18];
        label.text = @"出发时间";
        [self.view addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 34)];
        label1.backgroundColor = [UIColor clearColor];
        label1.font = [UIFont fontWithName:@"Helvetica" size:18];
        label1.text = @"返回时间";
        [self.view addSubview:label1];
        
        _leaveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 34)];
        _leaveTimeLabel.backgroundColor = [UIColor whiteColor];
        _leaveTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _leaveTimeLabel.userInteractionEnabled = YES;
        [self.view addSubview:_leaveTimeLabel];
        
        _backTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 34)];
        _backTimeLabel.backgroundColor = [UIColor whiteColor];
        _backTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _backTimeLabel.userInteractionEnabled = YES;
        [self.view addSubview:_backTimeLabel];
        
        CGRect frame = CGRectMake(10, 90, KScreenWidth-20, 150);
        _repeatCircleView = [[RepeatCyclePickerView alloc]initWithFrame:frame];
        [self.view addSubview:_repeatCircleView];
        
    }
    else
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 34)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:18];
        label.text = @"出发日期";
        [self.view addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 34)];
        label1.backgroundColor = [UIColor clearColor];
        label1.font = [UIFont fontWithName:@"Helvetica" size:18];
        label1.text = @"出发时间";
        [self.view addSubview:label1];
        
        _leaveDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 34)];
        _leaveDateLabel.backgroundColor = [UIColor whiteColor];
        _leaveDateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _leaveDateLabel.userInteractionEnabled = YES;
        [self.view addSubview:_leaveDateLabel];
        
        _leaveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 50, 200, 34)];
        _leaveTimeLabel.backgroundColor = [UIColor whiteColor];
        _leaveTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _leaveTimeLabel.userInteractionEnabled = YES;
        [self.view addSubview:_leaveTimeLabel];
    }
}

- (void)initTapGuesture
{
    if (_leaveDateLabel)
    {
        UITapGestureRecognizer *tapGueture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPickLeaveDate)];
        tapGueture.numberOfTapsRequired = 1;
        [_leaveDateLabel addGestureRecognizer:tapGueture];
        tapGueture = nil;
    }
    
    if (_leaveTimeLabel)
    {
        UITapGestureRecognizer *tapGueture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPickLeaveTime)];
        tapGueture.numberOfTapsRequired = 1;
        [_leaveTimeLabel addGestureRecognizer:tapGueture];
        tapGueture = nil;
    }
    
    if (_backTimeLabel)
    {
        UITapGestureRecognizer *tapGueture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPickBackTime)];
        tapGueture.numberOfTapsRequired = 1;
        [_backTimeLabel addGestureRecognizer:tapGueture];
        tapGueture = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtonItem];
    [self initheaderlabels];
    [self initTapGuesture];
}

#pragma mark -
#pragma mark UITapGestureRecognizer

- (void)tapToPickLeaveDate
{
    WEAKSELF;
    YZDatePicker *datePicker = [[YZDatePicker alloc]initWithDatePickerMode:UIDatePickerModeDate];
    [datePicker show:^(NSString *result) {
        NSLog(@"--result--%@",result);
        STRONGSELF;
        strongSelf.leaveDateLabel.text = result;
    }];
    datePicker = nil;
}

- (void)tapToPickLeaveTime
{
    WEAKSELF;
    YZDatePicker *datePicker = [[YZDatePicker alloc]initWithDatePickerMode:UIDatePickerModeTime];
    [datePicker show:^(NSString *result) {
        NSLog(@"--result--%@",result);
        STRONGSELF;
        strongSelf.leaveTimeLabel.text = result;
    }];
    datePicker = nil;
}

- (void)tapToPickBackTime
{
    WEAKSELF;
    YZDatePicker *datePicker = [[YZDatePicker alloc]initWithDatePickerMode:UIDatePickerModeTime];
    [datePicker show:^(NSString *result) {
        NSLog(@"--result--%@",result);
        STRONGSELF;
        strongSelf.backTimeLabel.text = result;
    }];
    datePicker = nil;
}

#pragma mark -
#pragma mark 下一步

- (void)clickToNextStep
{
    if (_paramsDic && [_paramsDic[@"routeType"]integerValue] == 3)
    {
        if (_leaveTimeLabel.text.length <= 0  || _backTimeLabel.text <= 0)
        {
            [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择行程时间"];
            return;
        }
    }
    else
    {
        if (_leaveDateLabel.text.length <= 0 || _leaveTimeLabel.text.length <= 0)
        {
             [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择行程时间"];
            return;
        }
    }
    
    if (_repeatCircleView)
    {
        NSString *repeat = [_repeatCircleView repeatCycle];
        DEBUG_METHOD(@"--repeat--%@",repeat);
        [_paramsDic setObject:repeat forKey:@"repeat"];
    }
    
    [_paramsDic setObject:_leaveTimeLabel.text forKey:@"leaveTime"];
    
    if (_leaveDateLabel)
    {
        [_paramsDic setObject:_leaveDateLabel.text forKey:@"leaveDate"];
    }
    
    if (_backTimeLabel)
    {
        [_paramsDic setObject:_backTimeLabel.text forKey:@"backTime"];
    }
    LogFUNC;
    ReleaseRouteViewController *releaseRouteVC = [[ReleaseRouteViewController alloc]initWithParams:_paramsDic];
    [self.navigationController pushViewController:releaseRouteVC animated:YES];
    releaseRouteVC = nil;
}

@end
