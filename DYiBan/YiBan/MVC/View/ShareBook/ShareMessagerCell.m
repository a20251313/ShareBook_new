//
//  ShareMessagerCell.m
//  ShareBook
//
//  Created by apple on 14-2-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareMessagerCell.h"

@implementation ShareMessagerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self creatCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCell:(NSDictionary *)dict{

    UIImage *imageIcon0 = [UIImage imageNamed:@"system-avatar"];
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, imageIcon0.size.width/2, imageIcon0.size.height/2)];
    [imageIcon setBackgroundColor:[UIColor clearColor]];
    [imageIcon setImage:[UIImage imageNamed:@"system-avatar"]];
    [self addSubview:imageIcon];
    [imageIcon release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 10, 5, 100.0f, 20.0f)];
    [labelName setText:@""];
    [self addSubview:labelName];
    [labelName release];
    
    UILabel *labelMSG = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 10, 25, 200, 20)];
    [labelMSG setText:[dict objectForKey:@"content"]];
    [labelMSG setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelMSG setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:labelMSG];
    [labelMSG release];
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(240, 5,80 , 20)];
    [labelTime setText:@"2014-02-09"];
    [labelTime setFont:[UIFont systemFontOfSize:14.0f]];
    [self addSubview:labelTime];
    [labelTime release];

    
    [self setBackgroundColor:[UIColor colorWithRed:246.0f/255 green:246.0f/255 blue:246.0f/255 alpha:1.0f]];
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 50-1, 320.0f, 1)];
    [imageLine setImage:[UIImage imageNamed:@"line3"]];
    [self addSubview:imageLine];
    [imageLine release];
}

@end
