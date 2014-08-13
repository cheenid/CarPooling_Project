//
//  YZSearchView.m
//  BaiduMap
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZSearchView.h"

@interface YZSearchView () <UITextFieldDelegate>
@property (nonatomic, copy) SearchHandle searchHandle;
@property (nonatomic, copy) SearchHandle nextSearchHandle;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation YZSearchView

- (void)execSearchLocation:(SearchHandle)searchBlock
{
    _searchHandle = searchBlock;
}

- (void)execSearchNextPage:(SearchHandle)searchBlock
{
    _nextSearchHandle = searchBlock;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithRed:0.644 green:0.218 blue:0.228 alpha:1.0].CGColor;
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
        self.userInteractionEnabled = YES;
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(35, 0, frame.size.width-100, frame.size.height)];
        [self.textField setBackgroundColor:[UIColor clearColor]];
        [self.textField setReturnKeyType:UIReturnKeySearch];
        [self.textField setDelegate:self];
        [self addSubview:self.textField];
        
        UIImage *searchImage = [UIImage imageNamed:@"map_search_icon"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(10, frame.size.height*0.5-10, 20, 20)];
        [button setBackgroundImage:searchImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIColor *color = [UIColor colorWithRed:0.644 green:0.218 blue:0.228 alpha:1.0];
        UIImage *norImage = [self imageWithColor:color size:CGSizeMake(40, 30)];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(frame.size.width - 50, frame.size.height*0.5-15, 40, 30)];
        [rightBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [rightBtn.layer setMasksToBounds:YES];
        [rightBtn.layer setCornerRadius:2.0];
        [rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [rightBtn setTitle:@"搜索" forState:UIControlStateHighlighted];
        [rightBtn addTarget:self action:@selector(rightSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
    }
    return self;
}

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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    if (CGRectContainsPoint(self.frame, point))
    {
        return YES;
    }
    else
    {
        [self endEditing:YES];
        return NO;
    }
}

- (void)rightSearchBtnClick
{
    [self endEditing:YES];
    if (self.nextSearchHandle)
    {
        self.nextSearchHandle(self.textField.text);
    }
}

- (void)searchBtnClick
{
    [self endEditing:YES];
    if (self.searchHandle && self.textField.text.length > 0)
    {
        self.searchHandle(self.textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    if ([string isEqualToString:@"\n"])
    {
        if (textField.text.length > 0)
        {
            [self endEditing:YES];
            if (self.searchHandle)
            {
                self.searchHandle(textField.text);
            }
        }
        // 发送文本
        return NO;
    }
    return YES;
}


@end
