//
//  CitySectionHeaderView.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-7.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "CitySectionHeaderView.h"

@interface CitySectionHeaderView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CitySectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)execUpdate:(NSString*)title
{
    _titleLabel.text = title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.frame = CGRectMake(10, 0, KScreenWidth-20, self.frame.size.height);
    _titleLabel.frame = CGRectMake(15, 0, KScreenWidth-25, self.frame.size.height);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _titleLabel.text = nil;
}


@end
