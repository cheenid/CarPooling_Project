//
//  BMKCityNodesType.m
//  CarPooling_Project
//
//  Created by 马远征 on 14-7-5.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "BMKCityNodesType.h"


FOUNDATION_EXPORT MplcCityNode MplcCityNodeMake(NSString *name, NSString *address,Float64 latitude, Float64 longitude)
{
    MplcCityNode mapLC;
    mapLC.name = (__bridge CFStringRef)name;
    mapLC.address = (__bridge CFStringRef)address;
    mapLC.latitude = latitude;
    mapLC.longitude = longitude;
    return mapLC;
}

FOUNDATION_EXPORT NSString *NSStringFromMplcCityNode(MplcCityNode mploc)
{
    NSString *retString = @"{\n";
    retString = [retString stringByAppendingFormat:@"name:%@,\n",(__bridge NSString*)mploc.name];
    retString = [retString stringByAppendingFormat:@"address:%@,\n",(__bridge NSString*)mploc.address];
    retString = [retString stringByAppendingFormat:@"latitude:%lf,\n",mploc.latitude];
    retString = [retString stringByAppendingFormat:@"longitude:%lf \n}",mploc.longitude];
    return retString;
}
