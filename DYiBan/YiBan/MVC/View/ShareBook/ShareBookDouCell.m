//
//  ShareBookDouCell.m
//  ShareBook
//
//  Created by tom zeng on 14-2-13.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookDouCell.h"

@implementation ShareBookDouCell

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

    UILabel *labeTime = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 5.0f, 100.0f, 30.0f)];
    [labeTime setText:@"2014-01-28"];
    [self addSubview:labeTime];
    RELEASE(labeTime);
    
    UILabel *labeType = [[UILabel alloc]initWithFrame:CGRectMake(140.0f, 5.0f, 100.0f, 30.0f)];
    [labeType setText:@"系统赠送"];
    [self addSubview:labeType];
    RELEASE(labeType);
    
    UILabel *labeNum= [[UILabel alloc]initWithFrame:CGRectMake(260.0f, 5.0f, 150.0f, 30.0f)];
    [labeNum setText:@"+10"];
    [self addSubview:labeNum];
    RELEASE(labeNum);

}

@end
