//
//  NewRouteViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-19.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "NewRouteViewController.h"
#import "DatePickerViewController.h"
#import "BDMapViewController.h"
#import "YZUISegmentControl.h"
#import "YZProgressHUD.h"

@interface NewRouteViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIButton *addButton;
}
@property (nonatomic, strong) YZUISegmentControl *userTypeSegControl;
@property (nonatomic, strong) YZUISegmentControl *routeTypeSegControl;
@property (nonatomic, strong) UITextField *spTextField;
@property (nonatomic, strong) UITextField *epTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *splabel;
@property (nonatomic, strong) UILabel *eplabel;
@property (nonatomic, strong) NSMutableArray *cityNodesArray;
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

- (NSMutableArray*)cityNodesArray
{
    if (_cityNodesArray == nil)
    {
        _cityNodesArray = [[NSMutableArray alloc]init];
    }
    return _cityNodesArray;
}

#pragma mark -
#pragma mark View

- (UISegmentedControl*)userTypeSegControl
{
    if (_userTypeSegControl == nil)
    {
        NSArray *itemsArray = [NSArray arrayWithObjects:@"司机",@"乘客", nil];
        _userTypeSegControl = [[YZUISegmentControl alloc]initWithItems:itemsArray];
        [_userTypeSegControl setFrame:CGRectMake(100, 10, 100, 24)];
        [_userTypeSegControl setSegmentedControlStyle:UISegmentedControlStylePlain];
        [_userTypeSegControl setSelectedSegmentIndex:0];
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
        _routeTypeSegControl = [[YZUISegmentControl alloc]initWithItems:itemsArray];
        [_routeTypeSegControl setFrame:CGRectMake(100, 40, 180, 24)];
        [_routeTypeSegControl setSelectedSegmentIndex:0];
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
        if (segControl.selectedSegmentIndex == 0)
        {
            addButton.enabled = NO;
        }
        else
        {
            addButton.enabled = YES;
        }
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
        [_spTextField setUserInteractionEnabled:YES];
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
        [_epTextField setUserInteractionEnabled:YES];
    }
    return _epTextField;
}

- (UILabel*)splabel
{
    if (_splabel == nil)
    {
        _splabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 80, 200, 30)];
        [_splabel setBackgroundColor:[UIColor whiteColor]];
        [_splabel.layer setBorderColor:[UIColor blackColor].CGColor];
        [_splabel.layer setBorderWidth:1.0];
        [_splabel.layer setCornerRadius:2.0];
        [_splabel.layer setMasksToBounds:YES];
        [_splabel setFont:[UIFont fontWithName:@"helvetica" size:14]];
        [_splabel setUserInteractionEnabled:YES];
    }
    return _splabel;
}


- (UILabel*)eplabel
{
    if (_eplabel == nil)
    {
        _eplabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 120, 200, 30)];
        [_eplabel setBackgroundColor:[UIColor whiteColor]];
        [_eplabel.layer setBorderColor:[UIColor blackColor].CGColor];
        [_eplabel.layer setBorderWidth:1.0];
        [_eplabel.layer setCornerRadius:2.0];
        [_eplabel.layer setMasksToBounds:YES];
        [_eplabel setFont:[UIFont fontWithName:@"helvetica" size:14]];
        [_eplabel setUserInteractionEnabled:YES];
    }
    return _eplabel;
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
    
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(0, 0, KScreenWidth-20, 34)];
    [addButton setTitle:@"请点击添加途经点" forState:UIControlStateNormal];
    [addButton setTitle:@"请点击添加途经点" forState:UIControlStateHighlighted];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [addButton addTarget:self action:@selector(clicktoAddRoutes) forControlEvents:UIControlEventTouchUpInside];
    [addButton.layer setBorderWidth:1.0];
    [addButton.layer setBorderColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.961 alpha:1.0].CGColor];
    [addButton setEnabled:NO];
    [backGroundView addSubview:addButton];
    [backGroundView addSubview:self.tableView];
}

- (void)initTapGuesture
{
    UITapGestureRecognizer *spTapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectStartPoint)];
    spTapGuesture.numberOfTapsRequired = 1;
    [self.splabel addGestureRecognizer:spTapGuesture];
    
    UITapGestureRecognizer *epTapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectEndPoint)];
    epTapGuesture.numberOfTapsRequired = 1;
    [self.eplabel addGestureRecognizer:epTapGuesture];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRightBarButtonItem];
    [self initViews];
    [self.view addSubview:self.userTypeSegControl];
    [self.view addSubview:self.routeTypeSegControl];
    [self.view addSubview:self.splabel];
    [self.view addSubview:self.eplabel];
    [self initTapGuesture];
}




#pragma mark -
#pragma mark UITapGestureRecognizer
// 选择起点线路
- (void)tapToSelectStartPoint
{
    LogFUNC;
    NSDictionary *cityNode = nil;
    if (self.cityNodesArray && self.cityNodesArray.count > 1)
    {
        cityNode = [self.cityNodesArray firstObject];
    }
    WEAKSELF;
    BDMapViewController *BDMapViewVC = [[BDMapViewController alloc]initWithCityNode:cityNode];
    [BDMapViewVC setCompletePoiSearch:^(MplcCityNode node) {
        
        NSLog(@"----node---%@",NSStringFromMplcCityNode(node));
        STRONGSELF;
        strongSelf->_splabel.text = (__bridge NSString *)(node.name);
        NSDictionary *cityNodeDic = @{@"name":(__bridge NSString *)(node.name),
                                      @"address":(__bridge NSString *)(node.address),
                                      @"type":@1,
                                      @"latitude":@(node.latitude),
                                      @"longitude":@(node.longitude)};
        if (strongSelf.cityNodesArray.count > 0)
        {
            [strongSelf.cityNodesArray removeObjectAtIndex:0];
        }
        [strongSelf.cityNodesArray insertObject:cityNodeDic atIndex:0];
    }];
    [self.navigationController pushViewController:BDMapViewVC animated:YES];
    BDMapViewVC = nil;
}

// 选择终点线路
- (void)tapToSelectEndPoint
{
    LogFUNC;
    NSDictionary *cityNode = nil;
    if (self.cityNodesArray && self.cityNodesArray.count > 1)
    {
        cityNode = [self.cityNodesArray lastObject];
    }
    WEAKSELF;
    BDMapViewController *BDMapViewVC = [[BDMapViewController alloc]initWithCityNode:cityNode];
    [BDMapViewVC setCompletePoiSearch:^(MplcCityNode node) {
        NSLog(@"----node---%@",NSStringFromMplcCityNode(node));
        STRONGSELF;
        strongSelf->_eplabel.text = (__bridge NSString *)(node.name);
        
        NSDictionary *cityNodeDic = @{@"name":(__bridge NSString *)(node.name),
                                      @"address":(__bridge NSString *)(node.address),
                                      @"type":@2,
                                      @"latitude":@(node.latitude),
                                      @"longitude":@(node.longitude)};
        if (strongSelf.cityNodesArray.count > 1)
        {
            [strongSelf.cityNodesArray removeLastObject];
        }
        [strongSelf.cityNodesArray addObject:cityNodeDic];
        
    }];
    [self.navigationController pushViewController:BDMapViewVC animated:YES];
    BDMapViewVC = nil;
}

#pragma mark -
#pragma mark 发布路线

- (void)clicktoAddRoutes
{
    LogFUNC;
    if (_splabel.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择起点路线"];
        return;
    }
    
    if (_eplabel.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择终点路线"];
        return;
    }
    

    WEAKSELF;
    BDMapViewController *BDMapViewVC = [[BDMapViewController alloc]initWithCityNode:nil];
    [BDMapViewVC setCompletePoiSearch:^(MplcCityNode node) {
        STRONGSELF;
        NSLog(@"----node---%@",NSStringFromMplcCityNode(node));
        
        strongSelf->_eplabel.text = (__bridge NSString *)(node.name);
        NSDictionary *cityNodeDic = @{@"name":(__bridge NSString *)(node.name),
                                      @"address":(__bridge NSString *)(node.address),
                                      @"type":@3,
                                      @"latitude":@(node.latitude),
                                      @"longitude":@(node.longitude)};

        NSDictionary *lastObject = [strongSelf.cityNodesArray lastObject];
        if (lastObject)
        {
            NSInteger index = [strongSelf.cityNodesArray indexOfObject:lastObject];
            [strongSelf.cityNodesArray insertObject:cityNodeDic atIndex:index];
        }
    }];
    [self.navigationController pushViewController:BDMapViewVC animated:YES];
    BDMapViewVC = nil;
}

- (void)clickToReleaseRoute
{
    if (_splabel.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择起点路线"];
        return;
    }
    
    if (_eplabel.text.length <= 0)
    {
        [[YZProgressHUD progressHUD]showWithError:self.view.window labelText:nil detailText:@"请选择终点路线"];
        return;
    }
    
    NSDictionary *paramsDic = @{@"personType":@(_userTypeSegControl.selectedSegmentIndex+1),
                                @"routeType":@(_routeTypeSegControl.selectedSegmentIndex+1),
                                @"nodes":_cityNodesArray};
    DatePickerViewController *releaseRouteVC = [[DatePickerViewController alloc]initWithPostParams:paramsDic];
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
    return (self.cityNodesArray.count -2) > 0 ? (self.cityNodesArray.count - 2):0;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (self.cityNodesArray.count > 2)
        {
            [self.cityNodesArray removeObjectAtIndex:indexPath.row+1];
            [self.tableView reloadData];
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *tmpDic = [self.cityNodesArray objectAtIndex:indexPath.row+1];
    if (tmpDic)
    {
        cell.textLabel.text = tmpDic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tmpDic = [self.cityNodesArray objectAtIndex:indexPath.row+1];
    if (tmpDic == nil)
    {
        return;
    }
    WEAKSELF;
    BDMapViewController *BDMapViewVC = [[BDMapViewController alloc]initWithCityNode:tmpDic];
    [BDMapViewVC setCompletePoiSearch:^(MplcCityNode node) {
        STRONGSELF;
        NSLog(@"----node---%@",NSStringFromMplcCityNode(node));
        strongSelf->_eplabel.text = (__bridge NSString *)(node.name);
        
        NSDictionary *cityNodeDic = @{@"name":(__bridge NSString *)(node.name),
                                      @"address":(__bridge NSString *)(node.address),
                                      @"type":@3,
                                      @"latitude":@(node.latitude),
                                      @"longitude":@(node.longitude)};
        
        [strongSelf.cityNodesArray replaceObjectAtIndex:indexPath.row+1 withObject:cityNodeDic];

    }];
    [self.navigationController pushViewController:BDMapViewVC animated:YES];
    BDMapViewVC = nil;
}
@end
