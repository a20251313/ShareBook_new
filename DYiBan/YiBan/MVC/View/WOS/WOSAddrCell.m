//
//  WOSAddrCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSAddrCell.h"

@implementation WOSAddrCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self tt];
        
    }
    return self;
}

-(void)tt{
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 300.0f, 40.0f)];
    [labelAddr setText:@"上海市区杨浦区国康路21号100楼"];
    [labelAddr setTextColor:ColorGryWhite];
    [labelAddr setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelAddr];
    RELEASE(labelAddr)
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 40 + 5, 200, 20)];
    [labelName setText:@"程鹏 159110110"];
    [labelName setTextColor:ColorGryWhite];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelName];
    RELEASE(labelName);

    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 79, 320.0f, 1)];
    [imageFen setImage:[UIImage imageNamed:@"个人中心_line"]];
    [self addSubview:imageFen];
    RELEASE(imageFen);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
