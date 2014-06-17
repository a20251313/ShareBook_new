//
//  ShareBookListViewController.h
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "DYBBaseViewController.h"


typedef enum
{
    ShareBookListTypeJiashangTushu = 0,
    ShareBookListTypeJieRuBook = 1,
    ShareBookListTypeJieChuBook = 2,
     ShareBookListTypeJieYueHis= 7,
    
}ShareBookListType;


@interface ShareBookListViewController : DYBBaseViewController
@property (nonatomic,assign)ShareBookListType type;
@property (nonatomic,retain)NSString  *headTitle;
@end
