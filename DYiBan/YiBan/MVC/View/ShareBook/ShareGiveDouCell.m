//
//  ShareGiveDouCell.m
//  ShareBook
//
//  Created by tom zeng on 14-2-14.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareGiveDouCell.h"

@implementation ShareGiveDouCell

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

    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 40.0f, 40.0f)];
    [imageIcon setImage:[UIImage imageNamed:@"system-avatar"]];
    [imageIcon setBackgroundColor:[UIColor redColor]];
    [self addSubview:imageIcon];
    [imageIcon release];

    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, 10.0f, 100.0, 30.0f)];
    [self addSubview:labelName];
    [labelName setText:[dict objectForKey:@"username"]];
    [labelName release];

}

@end
