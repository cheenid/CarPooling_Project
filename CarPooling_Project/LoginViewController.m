//
//  LoginViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "LoginViewController.h"
#import "YZTextField.h"
#import "CPHttpRequest.h"
#import "YZKeyChainManager.h"
#import "YZProgressHUD.h"
#import "CPASIHttpRequest.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) YZTextField *textField;
@property (nonatomic, strong) YZTextField *codeTextField;
@end

@implementation LoginViewController

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
        self.title = @"拼车助手";
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

- (void)initRightBarButtomItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 60, 34)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitle:@"下一步" forState:UIControlStateHighlighted];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (YZTextField*)textField
{
    if (_textField == nil)
    {
        _textField = [[YZTextField alloc]initWithFrame:CGRectMake(10, 30, 200, 30)];
        _textField.placeholder = @"手机号码";
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor blackColor];
        _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
    }
    return _textField;
}

- (YZTextField*)codeTextField
{
    if (_codeTextField == nil)
    {
        _codeTextField = [[YZTextField alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
        _codeTextField.placeholder = @"验证码";
        _codeTextField.backgroundColor = [UIColor clearColor];
        _codeTextField.textColor = [UIColor blackColor];
        _codeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}

- (void)registerTapGestureRecognizer
{
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapToDismissKeyBoard)];
    tapGuesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGuesture];
}

- (void)initAuthCodeButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(220, 27.5, 70, 33.5)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    UIColor *normalColor = [UIColor whiteColor];
    UIColor *highlightColor = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.0];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"login_get_authcode"] forState:UIControlStateNormal];
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToGetAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtomItem];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.codeTextField];
    [self initAuthCodeButton];
    [self registerTapGestureRecognizer];
}


#pragma mark -
#pragma mark KeyBoard

- (void)resignKeyBoard
{
    if ([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
    if ([_codeTextField isFirstResponder])
    {
        [_codeTextField resignFirstResponder];
    }
}

- (void)TapToDismissKeyBoard
{
    [self resignKeyBoard];
}

#pragma mark -
#pragma mark UIControl Action

- (void)clickToGetAuthCode
{
    [self resignKeyBoard];
    
    if (_textField.text.length <= 0)
    {
        return;
    }
    
    [[YZProgressHUD progressHUD]showOnWindow:self.view.window labelText:@"请稍后" detailText:nil];
    void (^Success) (id responseObject) = ^(id responseObject){
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSInteger statusCode = [[responseObject objectForKey:@"statusCode"]integerValue];
            if (statusCode == -1)
            {
                [[YZProgressHUD progressHUD]hideWithError:@"请重试" detailText:@"验证码获取错误"];
            }
            else
            {
                [[YZProgressHUD progressHUD]hideWithSuccess:nil detailText:@"验证码已发送"];
            }
        }
        else
        {
            [[YZProgressHUD progressHUD]hideWithError:@"请重试" detailText:@"验证码获取错误"];
        }
    };
    
    void (^Failture)(NSError *error) = ^(NSError *error){
        
        [[YZProgressHUD progressHUD]hideWithError:@"请重试" detailText:@"验证码获取错误"];
    };
    
    // 验证手机号码的正确性
    [[CPHttpRequest sharedInstance]requestSMS:_textField.text
                                      success:Success
                                     failture:Failture];
}

/*
 * 1.发生错误，返回状态码：-1
 * 2.账号不存在，返回状态码：-21
 * 3.密码错误，返回状态吗：-22
 * 4.登陆成功，返回状态码：1
 */

- (void)rightBarBtnClick
{
    [self resignKeyBoard];
    // 手机号码为空
    if (_textField.text.length <= 0 )
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请输入手机号"];
        return;
    }
    // 验证码为空
    if (_codeTextField.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请输入验证码"];
        return;
    }
    
    [[YZProgressHUD progressHUD]showOnWindow:self.view.window labelText:@"正在登录" detailText:nil];
    
    WEAKSELF;
    void (^Success)(id responseObject) = ^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSInteger statusCode = [[responseObject objectForKey:@"statusCode"]integerValue];
            if (statusCode == 2 || statusCode == 1)
            {
                [[YZProgressHUD progressHUD]hide];
                
                NSString *password = [responseObject objectForKey:@"password"];
                [[YZKeyChainManager defaultManager]setKeychainValue:_textField.text forKey:KMobileNO];
                [[YZKeyChainManager defaultManager]setKeychainValue:password forKey:KPassword];
                
                [weakSelf performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0];
            }
            else if (statusCode == -11)
            {
                [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"注册失败"];
            }
            else
            {
                [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"登录失败"];
            }
        }
        else
        {
            [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"登录失败"];
        }
    };
    
//    [[CPHttpRequest sharedInstance]requestLoginOrRegister:_textField.text
//                                                     code:_codeTextField.text
//                                                  success:Success
//                                                 failture:^(NSError *error) {
//         [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"登录失败"];
//    }];
    
    [[CPASIHttpRequest shared]requestLoginOrRegister:_textField.text
                                                code:_codeTextField.text
                                             success:Success
                                            failture:^(NSError *error) {
    [[YZProgressHUD progressHUD]hideWithError:nil detailText:@"登录失败"];
                                             }];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"EVENT_LOGIN_OK_NOTIFY" object:nil];
    }];
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _textField)
    {
        if ([string isEqualToString:@"\n"]||[string isEqualToString:@""])
        {
            return YES;
        }
        
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length >= 11)
        {
            _textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}


@end
