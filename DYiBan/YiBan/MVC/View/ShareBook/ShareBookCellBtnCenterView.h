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
AS_SIGNAL(CLICKREUPLOAD)        //重新上架
AS_SIGNAL(CLICKDROP)            //下架
AS_SIGNAL(CLICKSHARE)            //分享
AS_SIGNAL(CLICKBORROWHIS)            //借阅历史
AS_SIGNAL(CLICKMAKESURERETURN)            //确认归还
AS_SIGNAL(CLICKNOTICERETURN)            //提醒还书
AS_SIGNAL(CLICKEVULUATEBROWWER)            //评价借阅者
AS_SIGNAL(CLICKEVULUATEBOOK)            //评价书
AS_SIGNAL(CLICKRETURNBOOK)            //还书
AS_SIGNAL(CLICKMAKERECEIVE)            //确认收到


-(void)addBtnView:(int)type;
@end
