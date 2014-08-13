//
//  YZUISegmentControl.m
//  VcareClient
//
//  Created by 马远征 on 14-6-25.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "YZUISegmentControl.h"

@implementation YZUISegmentControl

- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size,NO,0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddRect(con,CGRectMake(0,0,size.width,size.height));
    CGContextSetFillColorWithColor(con,color.CGColor);
//    CGContextSetStrokeColorWithColor(con, color.CGColor);
    CGContextFillPath(con);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIColor *selectedColor = [UIColor colorWithRed:0.644 green:0.218 blue:0.228 alpha:1.0];
        
        
        
//        [self setSegmentedControlStyle:UISegmentedControlStylePlain];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTintColor:selectedColor];
        
        // 自定义背景
        UIImage *normalImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(100, 32)];
        UIImage *selectedImage = [self imageWithColor:selectedColor size:CGSizeMake(100, 32)];
        [self setBackgroundImage:normalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        // 自定义分割线
        UIImage *divideImage = [self imageWithColor:selectedColor size:CGSizeMake(1.0, 32)];
        [self setDividerImage:nil forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setDividerImage:nil forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setDividerImage:divideImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        // 标题属性
        [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                                  UITextAttributeTextColor: selectedColor,
                                                                  UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:14],
                                                                  UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)] }
                                                       forState:UIControlStateNormal];
        
        [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                                  UITextAttributeTextColor: [UIColor whiteColor],
                                                                  UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:14],
                                                                  UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]}
                                                       forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 边缘圆角
//    [self.layer setCornerRadius:self.frame.size.height*0.5];
    [self.layer setBorderColor:[UIColor colorWithRed:0.644 green:0.218 blue:0.228 alpha:1.0].CGColor];
    [self.layer setBorderWidth:1.0];
//    [self.layer setMasksToBounds:YES];
}
@end
