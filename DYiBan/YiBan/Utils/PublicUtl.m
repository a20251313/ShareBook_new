//
//  PublicUtl.m
//  ShareBook
//
//  Created by Joshon on 14-7-8.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "PublicUtl.h"
#import "MBProgressHUD.h"
#import "iToast.h"
@implementation PublicUtl


+(NSString*)getStatusStringByStatus:(int)status
{
    NSString    *strReturn = @"";
    switch (status)
    {
        case 0:
            strReturn = @"订单未确认";
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

+(void)addHUDviewinView:(UIView*)view
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
    [HUD show:YES];
}

+(void)hideHUDViewInView:(UIView*)view
{
    for (MBProgressHUD *subView in view.subviews)
    {
        if ([subView isKindOfClass:[MBProgressHUD class]])
        {
            [subView hide:YES];
        }
    }
}

+(void)showText:(NSString*)text Gravity:(iToastGravity)gravity
{
    iToast  *toast = [[iToast alloc] initWithText:text];
    [toast setGravity:gravity];
    [toast show];
    [toast release];
}
+(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view textColor:(UIColor *)textColor{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:100];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:textColor];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}
@end
