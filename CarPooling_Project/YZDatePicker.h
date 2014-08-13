//
//  YZDatePicker.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-9.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^resultDate)(NSString *result);

@interface YZDatePicker : UIView
- (id)initWithDatePickerMode:(UIDatePickerMode)mode;
- (void)show:(resultDate)result;
@end
