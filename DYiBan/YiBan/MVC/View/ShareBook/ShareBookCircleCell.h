//
//  ShareBookCircleCell
//  ShareBook
//
//  Created by tom zeng on 14-2-13.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareBookCircleCell : UITableViewCell
@property(nonatomic,assign)BOOL  isHasDistance;

-(void)creatCell:(NSDictionary*)dicInfo;
@end
