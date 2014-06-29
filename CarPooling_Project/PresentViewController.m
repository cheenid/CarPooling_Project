//
//  PresentViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-5-27.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "PresentViewController.h"
#import <TPKeyboardAvoidingTableView.h>

@interface PresentViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITextField *contactTextField;
@property (nonatomic, strong) UITextField *pointsTextField;
@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@end

@implementation PresentViewController

#pragma mark -
#pragma mark dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

#pragma mark -
#pragma mark init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"积分馈赠";
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
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)
                                                 style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UITextField*)contactTextField
{
    if (_contactTextField == nil)
    {
        _contactTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 210, 24)];
        _contactTextField.placeholder = @"联系人";
        _contactTextField.backgroundColor = [UIColor clearColor];
        _contactTextField.textColor = [UIColor blackColor];
        _contactTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _contactTextField.leftViewMode = UITextFieldViewModeAlways;
        _contactTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _contactTextField.enabled = NO;
    }
    return _contactTextField;
}

- (UITextField*)pointsTextField
{
    if (_pointsTextField == nil)
    {
        _pointsTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 210, 24)];
        _pointsTextField.placeholder = @"积分数";
        _pointsTextField.backgroundColor = [UIColor clearColor];
        _pointsTextField.textColor = [UIColor blackColor];
        _pointsTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
        _pointsTextField.leftViewMode = UITextFieldViewModeAlways;
        _pointsTextField.font = [UIFont fontWithName:@"Helvetica" size:16];
        _pointsTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _pointsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pointsTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _pointsTextField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"对象";
        [cell.contentView addSubview:self.contactTextField];
    }
    else
    {
        cell.textLabel.text = @"积分";
        [cell.contentView addSubview:self.pointsTextField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        
    }
}

@end
