//
//  CityNodeViewCell.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-7.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "CityNodeViewCell.h"

@interface CityNodeViewCell()
@property (nonatomic, strong) UILabel *citylabel;
@end

@implementation CityNodeViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        
        UIView *selectedview = [[UIView alloc]init];
        selectedview.backgroundColor = [UIColor redColor];
        self.selectedBackgroundView = selectedview;
        
        _citylabel = [[UILabel alloc]init];
        _citylabel.backgroundColor = [UIColor clearColor];
        _citylabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _citylabel.textAlignment = NSTextAlignmentCenter;
        _citylabel.lineBreakMode = NSLineBreakByWordWrapping;
        _citylabel.numberOfLines = 0;
        [self addSubview:_citylabel];

    }
    return self;
}
- (void)execUpdate:(NSString*)cityName
{
    _citylabel.text = cityName;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _citylabel.frame = self.bounds;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _citylabel.text = nil;
}

@end
