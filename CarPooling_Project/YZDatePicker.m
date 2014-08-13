//
//  YZDatePicker.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-9.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZDatePicker.h"

@interface YZDatePicker()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) UIDatePickerMode pickerMode;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic,   copy) resultDate resultDateBlock;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
@implementation YZDatePicker

- (id)initWithDatePickerMode:(UIDatePickerMode)mode
{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self)
    {
        self.pickerMode = mode;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.35];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 300)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
    imageView.frame = CGRectMake(0, 0, KScreenWidth, 44);
    imageView.userInteractionEnabled = YES;
    [_contentView addSubview:imageView];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(5, 5, 80, 34)];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [leftbutton setTitle:@"取消" forState:UIControlStateNormal];
    [leftbutton setTitle:@"取消" forState:UIControlStateHighlighted];
    [leftbutton addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:leftbutton];
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(KScreenWidth- 85, 5, 80, 34)];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightbutton setTitle:@"确定" forState:UIControlStateNormal];
    [rightbutton setTitle:@"确定" forState:UIControlStateHighlighted];
    [rightbutton addTarget:self action:@selector(clickToPicker) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:rightbutton];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 300-44)];
    _datePicker.datePickerMode = self.pickerMode;
    [_contentView addSubview:_datePicker];
}

- (NSDateFormatter*)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc]init];
        if (self.pickerMode == UIDatePickerModeDate)
        {
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        else if (self.pickerMode == UIDatePickerModeTime)
        {
            [_dateFormatter setDateFormat:@"HH:mm:ss"];
        }
        else if (self.pickerMode == UIDatePickerModeDateAndTime)
        {
            [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
    }
    return _dateFormatter;
}

- (void)clickToCancel
{
    [self MoveOut];
}

- (void)clickToPicker
{
    [self MoveOut];
    if (_resultDateBlock)
    {
        NSDate *date = _datePicker.date;
        NSString *resultDateString = [self.dateFormatter stringFromDate:date];
        _resultDateBlock(resultDateString);
    }
}

- (void)show:(resultDate)result
{
    self.resultDateBlock = result;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
    [self MoveIn];
}

- (void)MoveIn
{
    [UIView animateWithDuration:0.35f
                     animations:^{
                         _contentView.transform = CGAffineTransformMakeTranslation(0,-300);
                     }
                     completion:^(BOOL finished){}];
}
- (void)MoveOut
{
    [UIView animateWithDuration:0.35f
                     animations:^{
                         _contentView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [touches anyObject];
    if ([myTouch.view isEqual:self])
    {
        [self MoveOut];
    }
}

@end
