//
//  BuyPointsViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-16.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "BuyPointsViewController.h"
#import "CPHttpRequest.h"
#import "YZTextField.h"
#import "YZProgressHUD.h"

@interface BuyPointsViewController ()
@property (nonatomic ,strong) YZTextField *sumTextField;
@property (nonatomic, strong) UILabel *marklabel;
@end

@implementation BuyPointsViewController
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
        self.title = @"积分充值";
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

- (YZTextField*)sumTextField
{
    if (_sumTextField == nil)
    {
        _sumTextField = [[YZTextField alloc]initWithFrame:CGRectMake(80, 57, 210, 30)];
        _sumTextField.placeholder = @"充值金额";
        _sumTextField.backgroundColor = [UIColor clearColor];
        _sumTextField.textColor = [UIColor blackColor];
        _sumTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _sumTextField.leftViewMode = UITextFieldViewModeAlways;
        _sumTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _sumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _sumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _sumTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _sumTextField;
}

- (UILabel*)marklabel
{
    if (_marklabel == nil)
    {
        _marklabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 80, 24)];
        _marklabel.backgroundColor = [UIColor clearColor];
        _marklabel.textAlignment = NSTextAlignmentCenter;
        _marklabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _marklabel.text = @"金额";
    }
    return _marklabel;
}

- (void)initBuyButton
{
    UIImage *normalImage = [UIImage imageNamed:@"carpool_logout_normal"];
    UIImage *pressImage = [UIImage imageNamed:@"carpool_logout_press"];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:86 topCapHeight:22];
    pressImage = [pressImage stretchableImageWithLeftCapWidth:86 topCapHeight:22];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame: CGRectMake(10, 110, 300, 44)];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:pressImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToBuy) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:@"充值" forState:UIControlStateNormal];
    [button setTitle:@"充值" forState:UIControlStateHighlighted];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.marklabel];
    [self.view addSubview:self.sumTextField];
    [self initBuyButton];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyViewDidTap)];
    tapGuesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGuesture];
    
    
}

- (void)clickToBuy
{
    [self.view endEditing:YES];
    if (_sumTextField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请输入购买金额"];
        return;
    }
    
    [[YZProgressHUD progressHUD]showOnWindow:self.view.window labelText:@"请稍后" detailText:@"正在购买"];
    [[CPHttpRequest sharedInstance]requestBuyScore:100
                                           success:^(id responseObject) {
                                               NSInteger statusCode = [responseObject[@"statusCode"]integerValue];
                                               if (statusCode == 1)
                                               {
                                                   [[YZProgressHUD progressHUD]hideWithSuccess:@"充值成功" detailText:nil];
                                               }
                                               else if (statusCode == -2)
                                               {
                                                   [[YZProgressHUD progressHUD]hide];
                                               }
                                               else
                                               {
                                                   [[YZProgressHUD progressHUD]hideWithError:@"充值失败" detailText:nil];
                                               }
                                               
    } failture:^(NSError *error) {
        [[YZProgressHUD progressHUD]hideWithError:@"充值失败" detailText:nil];
    }];
}

#pragma mark -
#pragma mark UITapGestureRecognizer

- (void)buyViewDidTap
{
    [self.view endEditing:YES];
}



@end
