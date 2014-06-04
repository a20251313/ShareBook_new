//
//  ShareBookZhuan.m
//  ShareBook
//
//  Created by apple on 14-3-17.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookZhuan.h"

@implementation ShareBookZhuan

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)creatCell:(NSInteger) itype{
    
    if (itype%2 == 0) {
        
        
        UIImageView *imageBG = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 20.0f, 120.0f, 40.0f)];
        [imageBG setImage:[UIImage imageNamed:@"discussbg_01"]];
        [imageBG setBackgroundColor:[UIColor clearColor]];
        [self addSubview:imageBG];
        RELEASE(imageBG);
        
        
        UILabel *labelMSG = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 20.0f, 200.0f, 40.0f)];
        [labelMSG setText:@"转入10个乐享豆"];
        [labelMSG setBackgroundColor:[UIColor clearColor]];
        [self addSubview:labelMSG];
        RELEASE(labelMSG);
        
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelMSG.frame) + CGRectGetMinX(labelMSG.frame) - 30, 10.0f+ 5, 150.0f, 40.0f)];
        [labelTime setBackgroundColor:[UIColor clearColor]];
        [labelTime setText:@"2014-02-10 16:30"];
        [labelTime setFont:[UIFont systemFontOfSize:13.0f]];
        [self addSubview:labelTime];
        [labelTime release];
    }else{
        
        
        
        UILabel *labelMSG = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 20.0f - 5, 200.0f, 40.0f)];
        [labelMSG setText:@"2014-02-10 16:30"];
        [labelMSG setFont:[UIFont systemFontOfSize:13.0f]];
        [labelMSG setBackgroundColor:[UIColor clearColor]];
        [self addSubview:labelMSG];
        RELEASE(labelMSG);
        
        UIImageView *imageBG = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelMSG.frame) + CGRectGetMinX(labelMSG.frame) - 50, 10.0f, 150.0f, 40.0f)];
        [imageBG setImage:[UIImage imageNamed:@"discussbg_02"]];
        [self addSubview:imageBG];
        RELEASE(imageBG);
        
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelMSG.frame)-50 + CGRectGetMinX(labelMSG.frame), 10.0f, 200.0f, 40.0f)];
        [labelTime setText:@"转出20个乐享豆"];
        [self addSubview:labelTime];
        [labelTime release];
        [labelTime setBackgroundColor:[UIColor clearColor]];
        
    }
    
    
    
}

@end
