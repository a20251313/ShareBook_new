//
//  JingDianMapCell.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingDianMapCell : DYBBaseView
@property(nonatomic,retain)id targetObjc;
@property(nonatomic,retain)NSDictionary *dictInfo;
- (id)initWithFrame:(CGRect)frame dictInfo:(NSDictionary *)dict;
AS_SIGNAL(TOUCHCELL)
@end
