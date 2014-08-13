//
//  RepeatCyclePickerView.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-9.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "RepeatCyclePickerView.h"

@implementation DateSelectedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToCheck)];
        [self addGestureRecognizer:tapGesture];
        tapGesture = nil;
    }
    return self;
}

- (void)setDayName:(NSString *)dayName
{
    if (_dayName != dayName)
    {
        _dayName = dayName;
        [self setNeedsDisplay];
    }
}

- (void)clickToCheck
{
    _isSelected = !_isSelected;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGRect frame = CGRectMake(5, CGRectGetHeight(rect)*0.5-13, 26, 26);
    if (_isSelected)
    {
        UIImage *pressImage = [UIImage imageNamed:@"filelist_edit_selected"];
        [pressImage drawInRect:frame];
        
    }
    else
    {
        UIImage *norImage = [UIImage imageNamed:@"filelist_edit_unselected"];
        [norImage drawInRect:frame];
    }
    
    if (_dayName)
    {
        [[UIColor blackColor]set];
        CGRect frame = CGRectMake(40, CGRectGetHeight(rect)*0.5-12, 40, 24);
        [_dayName drawInRect:frame withFont:[UIFont fontWithName:@"Helvetica" size:16]];
    }
}

@end

@implementation RepeatCyclePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    NSArray *dayArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for (int i = 0; i < dayArray.count; i++)
    {
        CGRect frame = CGRectMake((i%3)*(self.frame.size.width/3), 30+floorf(i/3)*40, self.frame.size.width/3-10, 34);
        DateSelectedView *dayView = [[DateSelectedView alloc]initWithFrame:frame];
        [dayView setDayName:dayArray[i]];
        [dayView setTag:i+1];
        [self addSubview:dayView];
    }
}

- (NSString*)repeatCycle
{
    NSString *result = @"[";
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[DateSelectedView class]])
        {
            DateSelectedView *selecetedView = (DateSelectedView*)view;
            if (selecetedView.isSelected)
            {
                if (selecetedView.tag == 7)
                {
                    result = [result stringByAppendingFormat:@"%d]",selecetedView.tag];
                }
                else
                {
                    result = [result stringByAppendingFormat:@"%d,",selecetedView.tag];
                }
            }
        }
    }
    return result;
}

- (void)drawRect:(CGRect)rect
{
    NSString *title = @"重复周期";
    [title drawInRect:CGRectMake(0, 0, CGRectGetWidth(rect), 24)
             withFont:[UIFont fontWithName:@"Helvetica" size:18]];
}

@end
