//
//  BDMapViewController.m
//  BaiduMap
//
//  Created by 马远征 on 14-6-30.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "BDMapViewController.h"
#import "CityNodeViewController.h"
#import "YZUISegmentControl.h"
#import "YZSearchView.h"

@interface BDMapViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeocodeSearchDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) YZUISegmentControl *segmentControl;
@property (nonatomic, strong) YZSearchView *searchView;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKGeocodeSearch *geocodeSearch;
@property (nonatomic, strong) BMKCitySearchOption *citySearchOption;

@property (nonatomic,   copy) completePoiSearch poiSearchBlock;
@property (nonatomic, strong) NSDictionary *cityNodeDic;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, assign) int page;
@end

@implementation BDMapViewController

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    _poiSearch = nil;
    _geocodeSearch = nil;
    _locationService = nil;
    _segmentControl = nil;
    _searchView = nil;
    _citySearchOption = nil;
    _mapView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark init

- (id)initWithCityNode:(NSDictionary*)cityNode
{
    self = [super init];
    if (self)
    {
        _cityNodeDic = cityNode;
    }
    return self;
}

- (void)setCompletePoiSearch:(completePoiSearch)poiSearch
{
    _poiSearchBlock = poiSearch;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"百度地图";
    }
    return self;
}

#pragma mark -
#pragma mark getter (views)

- (YZUISegmentControl*)segmentControl
{
    if (_segmentControl == nil)
    {
        _segmentControl = [[YZUISegmentControl alloc]initWithItems:@[@"标准",@"路况",@"卫星",@"混合"]];
        [_segmentControl setFrame:CGRectMake(40, KScreenHeight - 100, 240, 32)];
        [_segmentControl addTarget:self action:@selector(segmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
        [_segmentControl setSelectedSegmentIndex:0];
    }
    return _segmentControl;
}


- (BMKMapView*)mapView
{
    if (_mapView == nil)
    {
        CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64);
        _mapView = [[BMKMapView alloc]initWithFrame:frame];
        _mapView.showMapScaleBar = YES;
    }
    return _mapView;
}

- (YZSearchView*)searchView
{
    if (_searchView == nil)
    {
        _searchView = [[YZSearchView alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth-20, 40)];
    }
    return _searchView;
}

- (BMKLocationService*)locationService
{
    if (_locationService == nil)
    {
        _locationService = [[BMKLocationService alloc]init];
    }
    return _locationService;
}

- (BMKPoiSearch*)poiSearch
{
    if (_poiSearch == nil)
    {
        _poiSearch = [[BMKPoiSearch alloc]init];
    }
    return _poiSearch;
}

- (BMKGeocodeSearch*)geocodeSearch
{
    if (_geocodeSearch == nil)
    {
        _geocodeSearch = [[BMKGeocodeSearch alloc]init];
    }
    return _geocodeSearch;
}

- (BMKCitySearchOption*)citySearchOption
{
    if (_citySearchOption == nil)
    {
        _citySearchOption = [[BMKCitySearchOption alloc]init];
    }
    return _citySearchOption;
}

#pragma mark -
#pragma mark YZUISegmentControl

- (void)segmentControlValueChange:(YZUISegmentControl*)segControl
{
    if (segControl.selectedSegmentIndex == 0)
    {
        [self.mapView setMapType:BMKMapTypeStandard];
    }
    else if (segControl.selectedSegmentIndex == 1)
    {
        [self.mapView setMapType:BMKMapTypeTrafficOn];
    }
    else if (segControl.selectedSegmentIndex == 2)
    {
        [self.mapView setMapType:BMKMapTypeSatellite];
    }
    else
    {
        [self.mapView setMapType:BMKMapTypeTrafficAndSatellite];
    }
}

#pragma mark -
#pragma mark loadView

- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size,NO,0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddRect(con,CGRectMake(0,0,size.width,size.height));
    CGContextSetFillColorWithColor(con,color.CGColor);
    CGContextFillPath(con);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)initMyLocationBtn
{
    UIImage *norImage = [UIImage imageNamed:@"share_position_loc"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, KScreenHeight-150, 40, 40)];
    [button setBackgroundImage:norImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)initRightBarBtnItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 80, 34)];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [leftButton setTitle:@"切换城市" forState:UIControlStateNormal];
    [leftButton setTitle:@"切换城市" forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(clickToSwitchCity) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}


- (void)startLocation
{
    [self.locationService startUserLocationService];
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    self.geocodeSearch.delegate = self;
    self.poiSearch.delegate = self;
    LogFUNC;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    [self.mapView viewWillDisappear];
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geocodeSearch.delegate = nil;
    self.poiSearch.delegate = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_mapView setCompassPosition:CGPointMake(10, 60)];
    _mapView.mapScaleBarPosition = CGPointMake(15, 300);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.searchView];
    [self initMyLocationBtn];
    [self initRightBarBtnItem];
    
    // 开始执行搜索
    WEAKSELF;
    [_searchView execSearchLocation:^(NSString *searchKey) {
        STRONGSELF;
        strongSelf.page = 0;
        [weakSelf searchCity:strongSelf.page keyWord:searchKey];
    }];
    
    [_searchView execSearchNextPage:^(NSString *searchKey) {
        STRONGSELF;
        strongSelf.page += 1;
        [weakSelf searchCity:strongSelf.page keyWord:searchKey];
    }];
    [self performSelector:@selector(startUpdateLocation) withObject:nil afterDelay:0.2];
}

- (void)startUpdateLocation
{
    if (_cityNodeDic)
    {
        NSLog(@"---定位城市---");
        // 定位区域
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [_cityNodeDic[@"latitude"]doubleValue];
        coordinate.longitude = [_cityNodeDic[@"longitude"]doubleValue];
        
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.01f,0.01f));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        // 开始地理位置反编码
        BMKReverseGeocodeOption *reverseGeocode = [[BMKReverseGeocodeOption alloc]init];
        reverseGeocode.reverseGeoPoint = coordinate;
        [_geocodeSearch reverseGeocode:reverseGeocode];
        LogFUNC;
    }
    else
    {
        [self startLocation];
    }
}

- (void)showMyLocation
{
    [self startLocation];
    return;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 39.92;
    coordinate.longitude = 116.3;
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.01f,0.01f));
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    BMKReverseGeocodeOption *reverseGeocode = [[BMKReverseGeocodeOption alloc]init];
    reverseGeocode.reverseGeoPoint = coordinate;
    [self.geocodeSearch reverseGeocode:reverseGeocode];
}

- (void)searchCity:(int)currentPage keyWord:(NSString*)searchKey
{
    LogFUNC;
    self.citySearchOption.pageIndex = currentPage;
    self.citySearchOption.city= (self.cityName == nil)? @"北京":self.cityName;
    self.citySearchOption.keyword = searchKey;
    BOOL flag = [self.poiSearch poiSearchInCity:self.citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

#pragma mark -
#pragma mark 切换城市

- (void)updateLocation:(NSValue*)value
{
    MplcCityNode node;
    [value getValue:&node];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = node.latitude;
    coordinate.longitude = node.longitude;
    // 更新地理区域
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.01f,0.01f));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    // 开始地理位置反编码
    BMKReverseGeocodeOption *reverseGeocode = [[BMKReverseGeocodeOption alloc]init];
    reverseGeocode.reverseGeoPoint = coordinate;
    [_geocodeSearch reverseGeocode:reverseGeocode];
}

- (void)clickToSwitchCity
{
    WEAKSELF;
    CityNodeViewController *cityNodeVC = [[CityNodeViewController alloc]init];
    [cityNodeVC setCompleteCitySelect:^(MplcCityNode node) {
        STRONGSELF;
        DEBUG_METHOD(@"---切换城市---%@",NSStringFromMplcCityNode(node));
        strongSelf.cityName = (__bridge NSString*)node.address;
        
        NSValue *value = [NSValue valueWithBytes:&node objCType:@encode(MplcCityNode)];
        [weakSelf performSelector:@selector(updateLocation:) withObject:value];
    }];
    [self.navigationController pushViewController:cityNodeVC animated:YES];
    cityNodeVC = nil;
}

#pragma mark -
#pragma mark BMKUserLocationDelegate

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.01;
    region.span.longitudeDelta = 0.01;

    [_mapView setRegion:region animated:YES];
    [_locationService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    
    DEBUG_METHOD(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    // 移除大头针
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    // 地理位置反编码
    BMKReverseGeocodeOption *reverseGeocode = [[BMKReverseGeocodeOption alloc]init];
    reverseGeocode.reverseGeoPoint = coor;
    [_geocodeSearch reverseGeocode:reverseGeocode];
}

#pragma mark -
#pragma mark BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if (_poiSearchBlock)
    {
        MplcCityNode mplcCityNode = MplcCityNodeMake(view.annotation.title,
                                                     view.annotation.subtitle,
                                                     view.annotation.coordinate.latitude,
                                                     view.annotation.coordinate.longitude);
        _poiSearchBlock(mplcCityNode);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *identifier = @"myAnnotation";
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        }
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    LogFUNC;
}

#pragma mark -
#pragma mark 关键字搜索

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
		for (int i = 0; i < poiResult.poiInfoList.count; i++)
        {
            BMKPoiInfo *poi = [poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.city;
            item.subtitle = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                _mapView.centerCoordinate = poi.pt;
            }
		}
	}
}

#pragma mark -
#pragma mark 地理位置反编码

- (void)onGetReverseGeocodeResult:(BMKGeocodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        DEBUG_METHOD(@"-----address--%@",result.address);
        DEBUG_METHOD(@"-----address--%@",result.addressDetail.province);
        DEBUG_METHOD(@"-----address--%@",result.addressDetail.city);
        DEBUG_METHOD(@"-----address--%@",result.addressDetail.district);
        DEBUG_METHOD(@"-----address--%@",result.addressDetail.streetName);
        DEBUG_METHOD(@"-----address--%@",result.addressDetail.streetNumber);
        _cityName = result.addressDetail.city;
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.location;
        annotation.title = result.addressDetail.city;
        annotation.subtitle = result.address;
        [self.mapView setCenterCoordinate:result.location];
        [self.mapView addAnnotation:annotation];
        
        for (int i = 0; i < result.poiList.count; i++)
        {
            BMKPoiInfo *poi = [result.poiList objectAtIndex:i];
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = poi.address;
            [_mapView addAnnotation:item];
        }
    }
}


@end
