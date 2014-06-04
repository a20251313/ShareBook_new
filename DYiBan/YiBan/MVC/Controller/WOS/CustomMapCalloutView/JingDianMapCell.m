//
//  JingDianMapCell.m
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "JingDianMapCell.h"

@implementation JingDianMapCell
DEF_SIGNAL(TOUCHCELL)
@synthesize targetObjc,dictInfo;

- (id)initWithFrame:(CGRect)frame dictInfo:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         dictInfo = dict;
        [self creatView];
    }
    return self;
}

-(void)creatView{

//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 40.f, 40.f)];
//    [imageView setImage:[UIImage imageNamed:@"food1"]];
////    [self addSubview:imageView];
////    RELEASE(imageView);

    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 120, 20)];
    [self addSubview:labelName];
    [labelName setText:[dictInfo objectForKey:@"circle_name"]];
    RELEASE(labelName);
    
//    UIImage *image  = [UIImage imageNamed:@"icon_pepole(1)"];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0f, 25.0f + 2+ 2, image.size.width/2, image.size.height/2)];
//    [imageView setImage:[UIImage imageNamed:@"icon_book(1)"]];
//    [self addSubview:imageView];
//    RELEASE(imageView);
    
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 220, 20)];
    NSString *strContent = [NSString stringWithFormat:@"热度：%@人 | %@书 | %@交易",[dictInfo objectForKey:@"hots"],[dictInfo objectForKey:@"book_num"],[dictInfo objectForKey:@"loan_num"]];
    [labelB setText:strContent];
    [labelB setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelB setFont:[UIFont systemFontOfSize:14]];
    [labelB sizeToFit];
    [self addSubview:labelB];
    RELEASE(labelB);
    
    
}

-(void)dodo{
//    [[self superview] removeFromSuperview];
    NSLog(@"dodo");
    if (targetObjc) {
        [self sendViewSignal:[JingDianMapCell TOUCHCELL] withObject:self from:self target:targetObjc];
    }
    
}

- (void)dealloc
{
    
    [targetObjc release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
