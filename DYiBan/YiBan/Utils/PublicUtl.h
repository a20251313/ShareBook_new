//
//  PublicUtl.h
//  ShareBook
//
//  Created by Joshon on 14-7-8.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iToast.h"
@interface PublicUtl : NSObject


+(NSString*)getStatusStringByStatus:(int)status;
+(void)addHUDviewinView:(UIView*)view;
+(void)hideHUDViewInView:(UIView*)view;
+(void)showText:(NSString*)text Gravity:(iToastGravity)gravity;
@end
