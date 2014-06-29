//
//  NewRouteViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-19.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "NewRouteViewController.h"
#import "ReleaseRouteViewController.h"

@interface NewRouteViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UISegmentedControl *userTypeSegControl;
@property (nonatomic, strong) UISegmentedControl *routeTypeSegControl;
@property (nonatomic, strong) UITextField *spTextField;
@property (nonatomic, strong) UITextField *epTextField;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewRouteViewController

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
        self.title = @"新建路线";
    }
    return self;
}

#pragma mark -
#pragma mark View

- (UISegmentedControl*)userTypeSegControl
{
    if (_userTypeSegControl == nil)
    {
        NSArray *itemsArray = [NSArray arrayWithObjects:@"司机",@"乘客", nil];
        _userTypeSegControl = [[UISegmentedControl alloc]initWithItems:itemsArray];
        [_userTypeSegControl setFrame:CGRectMake(100, 10, 100, 24)];
        [_userTypeSegControl setTintColor:[UIColor redColor]];
        [_userTypeSegControl setSegmentedControlStyle:UISegmentedControlStylePlain];
        [_userTypeSegControl setTag:10010];
        [_userTypeSegControl addTarget:self action:@selector(segmentedControlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _userTypeSegControl;
}

- (UISegmentedControl*)routeTypeSegControl
{
    if (_routeTypeSegControl == nil)
    {
        NSArray *itemsArray = [NSArray arrayWithObjects:@"长途",@"短途",@"上下班", nil];
        _routeTypeSegControl = [[UISegmentedControl alloc]initWithItems:itemsArray];
        [_routeTypeSegControl setFrame:CGRectMake(100, 40, 150, 24)];
        [_routeTypeSegControl setTintColor:[UIColor redColor]];
        [_routeTypeSegControl setSegmentedControlStyle:UISegmentedControlStylePlain];
        [_routeTypeSegControl setTag:10011];
        [_routeTypeSegControl addTarget:self action:@selector(segmentedControlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _routeTypeSegControl;
}

- (void)segmentedControlValueChange:(UISegmentedControl*)segControl
{
    if (segControl.tag == 10010)
    {
        
    }
    else
    {
        
    }
}

- (UITextField*)spTextField
{
    if (_spTextField == nil)
    {
        _spTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 80, 200, 30)];
        [_spTextField setBorderStyle:UITextBorderStyleLine];
        [_spTextField setBackgroundColor:[UIColor whiteColor]];
        [_spTextField setPlaceholder:@"请点击选择起点线路"];
        [_spTextField setEnabled:NO];
        [_spTextField.layer setCornerRadius:2.0];
        [_spTextField.layer setMasksToBounds:YES];
        [_spTextField setFont:[UIFont fontWithName:@"helvetica" size:14]];
    }
    return _spTextField;
}

- (UITextField*)epTextField
{
    if (_epTextField == nil)
    {
        _epTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 120, 200, 30)];
        [_epTextField setBorderStyle:UITextBorderStyleLine];
        [_epTextField setBackgroundColor:[UIColor whiteColor]];
        [_epTextField setPlaceholder:@"请点击选择起点线路"];
        [_epTextField setEnabled:NO];
        [_epTextField.layer setCornerRadius:2.0];
        [_epTextField.layer setMasksToBounds:YES];
        [_epTextField setFont:[UIFont fontWithName:@"helvetica" size:14]];
    }
    return _epTextField;
}

- (UITableView*)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 34, KScreenWidth-20, KScreenHeight - 338)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:@"发布路线" forState:UIControlStateNormal];
    [button setTitle:@"发布路线" forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickToReleaseRoute) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)initViews
{
    UILabel *userTypelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 24)];
    [userTypelabel setBackgroundColor:[UIColor clearColor]];
    [userTypelabel setTextAlignment:NSTextAlignmentCenter];
    [userTypelabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [userTypelabel setText:@"用户类型"];
    [self.view addSubview:userTypelabel];
    
    UILabel *routeTypelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 80, 24)];
    [routeTypelabel setBackgroundColor:[UIColor clearColor]];
    [routeTypelabel setTextAlignment:NSTextAlignmentCenter];
    [routeTypelabel setFont:[UIFont fontWithName:@"helvetica" size:16]];
    [routeTypelabel setText:@"线路类型"];
    [self.view addSubview:routeTypelabel];
    
    UILabel *splabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 83, 80, 24)];
    [splabel setBackgroundColor:[UIColor clearColor]];
    [splabel setTextAlignment:NSTextAlignmentCenter];
    [splabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [splabel setText:@"起点线路"];
    [self.view addSubview:splabel];
    
    UILabel *eplabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 123, 80, 24)];
    [eplabel setBackgroundColor:[UIColor clearColor]];
    [eplabel setTextAlignment:NSTextAlignmentCenter];
    [eplabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [eplabel setText:@"终点线路"];
    [self.view addSubview:eplabel];
    
    UILabel *nodelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, KScreenWidth, 24)];
    [nodelabel setBackgroundColor:[UIColor clearColor]];
    [nodelabel setTextAlignment:NSTextAlignmentCenter];
    [nodelabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [nodelabel setText:@"途径节点"];
    [self.view addSubview:nodelabel];
    
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 180,KScreenWidth-20, KScreenHeight - 304)];
    [backGroundView setBackgroundColor:[UIColor whiteColor]];
    [backGroundView.layer setCornerRadius:4.0];
    [backGroundView.layer setMasksToBounds:YES];
    [backGroundView.layer setBorderColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.961 alpha:1.0].CGColor];
    [backGroundView.layer setBorderWidth:1.0];
    [self.view addSubview:backGroundView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(0, 0, KScreenWidth-20, 34)];
    [addButton setTitle:@"请点击添加途经点" forState:UIControlStateNormal];
    [addButton setTitle:@"请点击添加途经点" forState:UIControlStateHighlighted];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(clicktoAddRoutes) forControlEvents:UIControlEventTouchUpInside];
    [addButton.layer setBorderWidth:1.0];
    [addButton.layer setBorderColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.961 alpha:1.0].CGColor];
    [backGroundView addSubview:addButton];
    [backGroundView addSubview:self.tableView];
}

- (void)initTapGuesture
{
    UITapGestureRecognizer *spTapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectStartPoint)];
    spTapGuesture.numberOfTapsRequired = 1;
    [self.spTextField addGestureRecognizer:spTapGuesture];
    
    UITapGestureRecognizer *epTapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectEndPoint)];
    epTapGuesture.numberOfTapsRequired = 1;
    [self.epTextField addGestureRecognizer:epTapGuesture];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtonItem];
    [self initViews];
    [self.view addSubview:self.userTypeSegControl];
    [self.view addSubview:self.routeTypeSegControl];
    [self.view addSubview:self.spTextField];
    [self.view addSubview:self.epTextField];
    [self initTapGuesture];
}

#pragma mark -
#pragma mark UITapGestureRecognizer

- (void)tapToSelectStartPoint
{
    
}

- (void)tapToSelectEndPoint
{
    
}

#pragma mark -
#pragma mark 发布路线

- (void)clicktoAddRoutes
{
    if (_spTextField.text.length <= 0)
    {
        return;
    }
    
    if (_epTextField.text.length <= 0)
    {
        return;
    }
}

- (void)clickToReleaseRoute
{
    ReleaseRouteViewController *releaseRouteVC = [[ReleaseRouteViewController alloc]init];
    [self.navigationController pushViewController:releaseRouteVC animated:YES];
    releaseRouteVC = nil;
}

#pragma mark -
#pragma mark UItableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
@end
