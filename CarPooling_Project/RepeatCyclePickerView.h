//
//  RepeatCyclePickerView.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-9.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectedView : UIView
@property (nonatomic, readonly ,assign) BOOL isSelected;
@property (nonatomic, strong) NSString *dayName;
@end

@interface RepeatCyclePickerView : UIView
- (NSString*)repeatCycle;
@end
