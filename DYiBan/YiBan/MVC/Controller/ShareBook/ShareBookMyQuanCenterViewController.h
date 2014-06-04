//
//  ShareBookMyQuanCenterViewController.h
//  ShareBook
//
//  Created by tom zeng on 14-2-25.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "ShareBookMakeSureUpBookViewController.h"
@interface ShareBookMyQuanCenterViewController : DYBBaseViewController
@property (nonatomic,assign)BOOL bEnter;
@property (nonatomic,retain)NSArray *arrayResult;
@property (nonatomic,assign)BOOL bselct;
@property (nonatomic,retain)ShareBookMakeSureUpBookViewController *makesure;
@end
