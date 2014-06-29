//
//  YZPullRefreshView.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-6-18.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZPullRefreshView.h"

#define PULLSATET -1

static CGFloat KRefreshHeight = 65.0f;
static  NSString *KarrowImage = @"";

#if PULLSATET
static  NSString *KPullToRresh = @"上拉即可刷新";
#else
static  NSString *KPullToRresh = @"下拉加载更多";
#endif

static  NSString *KReleseToRefresh = @"松开即可刷新";
static  NSString *KIsRefreshing = @"正在刷新……";


typedef NS_ENUM(NSInteger, YZPullRefreshState)
{
    YZPullRefreshStateNormal = 0,
    YZPullRefreshStatePulling,
    YZPullRefreshStateRefreshing,
};

@interface YZPullRefreshView()
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, strong) UILabel *statuslabel;
@property (nonatomic, strong) UILabel *updateTimelabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) YZPullRefreshState refreshState;
@property (nonatomic, assign) YZRefreshType refreshType;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation YZPullRefreshView

- (BOOL)isRefreshing
{
    return YZPullRefreshStateRefreshing == _refreshState;
}

- (void)beginRefreshing
{
    [self setRefreshState:YZPullRefreshStateRefreshing];
}

- (void)endRefreshing
{
    [self setRefreshState:YZPullRefreshStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithRefreshType:(YZRefreshType)type
{
    self = [super init];
    if (self)
    {
        self.refreshType = type;
        self.refreshState = YZPullRefreshStateNormal;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.updateTimelabel];
        [self addSubview:self.statuslabel];
        [self addSubview:self.arrowImageView];
        [self addSubview:self.activityView];
        
        self.updateTimelabel.hidden = (self.refreshType == YZPullUpToRefresh);
    }
    return self;
}

#pragma mark -
#pragma mark Setter

- (void)setRefreshState:(YZPullRefreshState)refreshState
{
    if (_refreshState == refreshState)
    {
        return;
    }
    _refreshState = refreshState;
    YZPullRefreshState oldState = _refreshState;
    if (refreshState == YZPullRefreshStateNormal)
    {
        self.statuslabel.text = KPullToRresh;
        self.arrowImageView.hidden = NO;
        [self.activityView stopAnimating];
        if (oldState == YZPullRefreshStateRefreshing)
        {
            self.lastUpdateDate = [NSDate date];
        }
        [UIView animateWithDuration:0.2 animations:^{
           
            self.arrowImageView.transform = CGAffineTransformIdentity;
            UIEdgeInsets insets = self.scrollView.contentInset;
            if (self.refreshType == YZPullUpToRefresh)
            {
                insets.top = 0;
            }
            else
            {
                insets.bottom = 0;
            }
            self.scrollView.contentInset = insets;
        }];
    }
    else if (refreshState == YZPullRefreshStatePulling)
    {
        self.statuslabel.text = KReleseToRefresh;
        [UIView animateWithDuration:0.2 animations:^{
           
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            UIEdgeInsets insets = self.scrollView.contentInset;
            if (self.refreshType == YZPullUpToRefresh)
            {
                insets.top = 0;
            }
            else
            {
                insets.bottom = 0;
            }
            self.scrollView.contentInset = insets;
        }];
    }
    else if (refreshState == YZPullRefreshStateRefreshing)
    {
        self.statuslabel.text = KIsRefreshing;
        [self.activityView startAnimating];
        self.arrowImageView.hidden = YES;
        self.arrowImageView.transform = CGAffineTransformIdentity;
        // 刷新回调
        [UIView animateWithDuration:0.2 animations:^{
            UIEdgeInsets inset = _scrollView.contentInset;
            CGFloat pointY = -KRefreshHeight;
            if (self.refreshType == YZPullUpToRefresh)
            {
                inset.top = KRefreshHeight;
            }
            else
            {
                inset.bottom = self.frame.origin.y - self.scrollView.contentSize.height + KRefreshHeight;
                CGFloat height = MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
                pointY = height - self.scrollView.frame.size.height + KRefreshHeight;
            }
            self.scrollView.contentInset = inset;
            self.scrollView.contentOffset = CGPointMake(0, pointY);
        }];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = KRefreshHeight;
    [super setFrame:frame];
    
    CGFloat statusY = 5;
    CGFloat width = frame.size.width;
    
    if (width == 0 || self.statuslabel.frame.origin.y == statusY)
    {
        return;
    }
    self.statuslabel.frame = CGRectMake(0, 5, width, 20);
    self.updateTimelabel.frame = CGRectMake(0, 30, width, 20);
    self.arrowImageView.center = CGPointMake(width*0.5 - 100, frame.size.height * 0.5);
    self.activityView.center = self.arrowImageView.center;
}

- (void)setLastUpdateDate:(NSDate *)lastUpdateDate
{
    _lastUpdateDate = lastUpdateDate;
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateDate forKey:NSStringFromClass([self class])];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateTimelabel];
}

- (void)updateTimeLabel
{
    if (_lastUpdateDate == nil)
    {
        return;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateDate];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day])
    { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    }
    else if ([cmp1 year] == [cmp2 year])
    { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    }
    else
    {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateDate];
    self.updateTimelabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (self.refreshType == YZPullUpToRefresh)
    {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        self.scrollView = scrollView;
        [self.scrollView  addSubview:self];
        [self.scrollView  addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        self.frame = CGRectMake(0, -KRefreshHeight, scrollView.frame.size.width, KRefreshHeight);
        
        _lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
        [self updateTimeLabel];
    }
    else
    {
        [self.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        
        self.scrollView = scrollView;
        [self.scrollView addSubview:self];
        
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self adjustFrame];
    }
}

- (void)removeFroYZuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [super removeFromSuperview];
}

- (void)adjustFrame
{
    CGFloat contentHeight = self.scrollView.contentSize.height;
    CGFloat scrollHeight = self.scrollView.frame.size.height;
    
    CGFloat y = MAX(contentHeight, scrollHeight);
    self.frame = CGRectMake(0, y, _scrollView.frame.size.width, KRefreshHeight);
    
    CGPoint center = self.statuslabel.center;
    center.y = self.arrowImageView.center.y;
    self.statuslabel.center = center;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"contentSize" isEqualToString:keyPath])
    {
        [self adjustFrame];
    }
    
    if ( [@"contentOffset" isEqualToString:keyPath] )
    {
        CGFloat offsetY = self.scrollView.contentOffset.y * self.refreshType;
        
        CGFloat validY = CGFLOAT_MIN;
        if (self.refreshType == YZPullUpToRefresh)
        {
            validY = 0;
        }
        else
        {
            validY = MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height) - self.scrollView.frame.size.height;
        }
        
        if ( !self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
            || self.refreshState == YZPullRefreshStateRefreshing || offsetY <= validY)
        {
            return;
        }
        
        // 即将刷新 && 手松开
        if (_scrollView.isDragging)
        {
            CGFloat validOffsetY = validY + 65.0;
            if (self.refreshState == YZPullRefreshStatePulling && offsetY <= validOffsetY)
            {
                [self setRefreshState:YZPullRefreshStateNormal];
            }
            else if (self.refreshState == YZPullRefreshStateNormal && offsetY > validOffsetY)
            {
                [self setRefreshState:YZPullRefreshStatePulling];
            }
        }
        else
        {
            if (self.refreshState == YZPullRefreshStatePulling)
            {
                [self setRefreshState:YZPullRefreshStateRefreshing];
            }
        }
    }
}


#pragma mark -
#pragma mark initialize UIView
- (UILabel*)updateTimelabel
{
    if (_updateTimelabel == nil)
    {
        _updateTimelabel = [[UILabel alloc] init];
        _updateTimelabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _updateTimelabel.font = [UIFont boldSystemFontOfSize:12];
        _updateTimelabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _updateTimelabel.backgroundColor = [UIColor clearColor];
        _updateTimelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _updateTimelabel;
}

- (UILabel*)statuslabel
{
    if (_statuslabel == nil)
    {
        _statuslabel = [[UILabel alloc] init];
        _statuslabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statuslabel.font = [UIFont boldSystemFontOfSize:13];
        _statuslabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        _statuslabel.backgroundColor = [UIColor clearColor];
        _statuslabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statuslabel;
}

- (UIImageView*)arrowImageView
{
    if (_arrowImageView == nil)
    {
        UIImage *arrowImage = [UIImage imageNamed:KarrowImage];
        _arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        _arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _arrowImageView;
}

- (UIActivityIndicatorView*)activityView
{
    if (_activityView == nil)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.bounds = self.arrowImageView.bounds;
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _activityView;
}
@end
