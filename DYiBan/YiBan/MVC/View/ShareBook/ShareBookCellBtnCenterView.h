//
//  ShareBookCellBtnCenterView.h
//  ShareBook
//
//  Created by apple on 14-3-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "DYBBaseView.h"

@interface ShareBookCellBtnCenterView : NSObject

@property(nonatomic,retain) UIView *viewBG;
@property(nonatomic,retain) NSDictionary *dicInfo;
AS_SIGNAL(CLICKREUPLOAD)
-(void)addBtnView:(int)type;
@end
