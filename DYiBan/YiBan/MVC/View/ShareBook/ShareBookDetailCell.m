//
//  ShareBookDetailCell.m
//  ShareBook
//
//  Created by tom zeng on 14-2-12.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookDetailCell.h"
#import "WOSStarView.h"

@implementation ShareBookDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creatCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCell{

    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake( 5, 5, 100, 20)];
    [labelName setText:@"三生三室枕上"];
//    [labelName sizeToFit];
    [labelName setFont:[UIFont systemFontOfSize:14]];
    [labelName setTextColor:[UIColor colorWithRed:19.0f/255 green:138.0f/255 blue:203.0f/255 alpha:1.0f]];
    [self addSubview:labelName];
    [labelName release];
    
    WOSStarView *star = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelName.frame) + CGRectGetWidth(labelName.frame), 5, 100, 20) num:4] ;
    [self addSubview:star];
    RELEASE(star);
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake( 5, CGRectGetMinY(labelName.frame) + CGRectGetHeight(labelName.frame) + 5, 250, 20)];
    [labelAuther setText:[ NSString stringWithFormat:@"作者：曾新messag国民族艺术出"]];
    [labelAuther setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelAuther setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:labelAuther];
    [labelAuther release];
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(220, 5, 200, 20)];
    [labelPublic setText:[NSString stringWithFormat:@"2014-02-01"]];
    [self addSubview:labelPublic];
     [labelPublic setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelPublic setFont:[UIFont systemFontOfSize:13]];
    [labelPublic release];



}
@end
