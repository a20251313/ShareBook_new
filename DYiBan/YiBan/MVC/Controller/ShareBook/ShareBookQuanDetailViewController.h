//
//  ShareBookQuanDetailViewController.h
//  ShareBook
//
//  Created by tom zeng on 14-2-24.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface ShareBookQuanDetailViewController : DYBBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)NSDictionary *dictInfo;
@end
