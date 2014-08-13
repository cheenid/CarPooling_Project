//
//  CityNodeViewController.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-7.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "CityNodeViewController.h"
#import "CityNodeViewCell.h"
#import "CitySectionHeaderView.h"

static NSString *cellIdentifier = @"Cell";
static NSString *cellheaderIdentifier = @"CellHeader";

@interface CityNodeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSDictionary *plistDictionary;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,   copy) completeCitySelect citySelect;
@end

@implementation CityNodeViewController
- (void)setCompleteCitySelect:(completeCitySelect)citySelect
{
    _citySelect = citySelect;
}
#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    _citySelect = nil;
    _plistDictionary = nil;
    _collectionView = nil;
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
        self.title = @"切换城市";
    }
    return self;
}

#pragma mark -
#pragma mark ViewMethods

- (void)loadView
{
    [super loadView];
    UIView *contentView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    contentView.backgroundColor = [UIColor colorWithRed:0.776 green:0.776 blue:0.776 alpha:1.0];
    self.view = contentView;
}

- (void)loadPlistFileResource
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"detailCity" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithContentsOfFile:path];
    self.plistDictionary = dictionary;
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(90, 40);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.headerReferenceSize = CGSizeMake(KScreenWidth, 34);
    
    CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    self.collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CityNodeViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[CitySectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellheaderIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPlistFileResource];
    [self initCollectionView];
}

#pragma mark -
#pragma mark  collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.plistDictionary allKeys].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *key = [[self.plistDictionary allKeys]objectAtIndex:section];
    NSArray *items = [self.plistDictionary objectForKey:key];
    return items.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CitySectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellheaderIdentifier forIndexPath:indexPath];
    NSString *key = [[self.plistDictionary allKeys]objectAtIndex:indexPath.section];
    [headerView execUpdate:key];
    return headerView;
}
 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityNodeViewCell *cell = (CityNodeViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *key = [[self.plistDictionary allKeys]objectAtIndex:indexPath.section];
    NSArray *items = [self.plistDictionary objectForKey:key];
    NSDictionary *cityDic = [items objectAtIndex:indexPath.row];
    [cell execUpdate:cityDic[@"城市名"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.citySelect)
    {
        NSString *key = [[self.plistDictionary allKeys]objectAtIndex:indexPath.section];
        NSArray *items = [self.plistDictionary objectForKey:key];
        NSDictionary *cityDic = [items objectAtIndex:indexPath.row];
        MplcCityNode node = MplcCityNodeMake(key,
                                             cityDic[@"城市名"],
                                             [cityDic[@"纬度"]doubleValue],
                                             [cityDic[@"经度"]doubleValue]);
        self.citySelect(node);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
