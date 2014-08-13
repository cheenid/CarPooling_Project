//
//  YZSearchView.h
//  BaiduMap
//
//  Created by 马远征 on 14-7-2.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SearchHandle)(NSString *searchKey);

@interface YZSearchView : UIView
- (void)execSearchLocation:(SearchHandle)searchBlock;
- (void)execSearchNextPage:(SearchHandle)searchBlock;
@end
