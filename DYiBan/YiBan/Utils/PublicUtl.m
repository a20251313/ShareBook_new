//
//  PublicUtl.m
//  ShareBook
//
//  Created by Joshon on 14-7-8.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "PublicUtl.h"

@implementation PublicUtl


+(NSString*)getStatusStringByStatus:(int)status
{
    NSString    *strReturn = @"";
    switch (status)
    {
        case 0:
            strReturn = @"订单已完成";
            break;
        case 1:
            strReturn = @"待书主同意";
            break;
        case 2:
            strReturn = @"待借阅者收到书";
            break;
        case 3:
            strReturn = @"书主拒绝";
            break;
        case 4:
            strReturn = @"待借阅者还书";
            break;
        case 5:
            strReturn = @"待确认还书";
            break;
        case 6:
            strReturn = @"待评价";
            break;
        case 7:
            strReturn = @"订单已完成";
            break;
        default:
            strReturn = @"未知状态";
            break;
            break;
    }
    return strReturn;
}
@end
