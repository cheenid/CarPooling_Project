//
//  BMKCityNodesType.h
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-5.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

struct MplcCityNode
{
    CFStringRef name;
    CFStringRef address;
    Float64 latitude;
    Float64 longitude;
};

typedef struct MplcCityNode MplcCityNode;


FOUNDATION_EXPORT MplcCityNode MplcCityNodeMake(NSString *name, NSString *address,Float64 latitude, Float64 longitude);

FOUNDATION_EXPORT NSString *NSStringFromMplcCityNode(MplcCityNode mploc);