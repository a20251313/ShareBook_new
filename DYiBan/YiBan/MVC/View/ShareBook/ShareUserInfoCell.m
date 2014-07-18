//
//  ShareGiveDouCell.m
//  ShareBook
//
//  Created by tom zeng on 14-2-14.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareUserInfoCell.h"


#define ShareUserInfoCellCustomHeight   90
@implementation ShareUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self creatCell];
    }
    return self;
}

+(CGFloat)ShareUserInfoCellHeight
{
    return ShareUserInfoCellCustomHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCell:(NSDictionary *)dict{

    
    
    for (UIView  *subView in self.contentView.subviews)
    {
        if (![subView isKindOfClass:[UIButton class]] && subView != self.contentView && subView != self)
        {
            [subView removeFromSuperview];
        }
    }
    
    NSString *strUrl = [dict valueForKey:@"pic"];
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, (ShareUserInfoCellCustomHeight-40)/2, 40.0f, 40.0f)];
    [imageIcon setImage:[UIImage imageNamed:@"system-avatar"]];

    if ([strUrl length] > 3)
    {
        [imageIcon setImageWithURL:[DYBShareinstaceDelegate getImageString:[dict objectForKey:@"pic"] ]placeholderImage:[UIImage imageNamed:@"system-avatar"]];
    }
  
    [self.contentView addSubview:imageIcon];
    [imageIcon release];

    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, 10.0f, 260.0, 20.0f)];
    [self.contentView addSubview:labelName];
    [labelName setText:[dict objectForKey:@"username"]];
    [labelName release];
    
    
    UILabel *labelSex = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, 31.0f, 100.0, 20.0f)];
    [self.contentView addSubview:labelSex];
    if ([[dict objectForKey:@"sex"] intValue] == 0)
    {
        [labelSex setText:@"男"];
    }else
    {
        [labelSex setText:@"女"];
    }
    [labelSex release];
    
    
    UIImage *iamageG = [UIImage imageNamed:@"bg_good"];
    UIImageView *imageViewGood = [[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetHeight(labelSex.frame) + CGRectGetMinY(labelSex.frame), iamageG.size.width/2, iamageG.size.height/2)];
    [imageViewGood setImage:[UIImage imageNamed:@"bg_good"]];
    [self.contentView  addSubview:imageViewGood];
    RELEASE(imageViewGood);
    
    UILabel *labelGood = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 5.0f, 20.0f, 20.0f)];
    [labelGood setText:[dict objectForKey:@"good_credit"]];
    [imageViewGood addSubview:labelGood];
    RELEASE(labelGood);
    [labelGood setBackgroundColor:[UIColor clearColor]];
    
    
    UIImage *iamgeB = [UIImage imageNamed:@"bg_bad"];
    UIImageView *imageViewBad = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewGood.frame) + CGRectGetMinX(imageViewGood.frame)+20, CGRectGetHeight(labelSex.frame) + CGRectGetMinY(labelSex.frame), iamageG.size.width/2, iamgeB.size.height/2)];
    [imageViewBad setImage:[UIImage imageNamed:@"bg_bad"]];
    [self.contentView addSubview:imageViewBad];
    RELEASE(imageViewBad);
    
    UILabel *labelDad = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 5.0f, 20.0f, 20.0f)];
    [labelDad setText:[dict objectForKey:@"bad_credit"]];
    [imageViewBad addSubview:labelDad];
    RELEASE(labelDad);
    [labelDad setBackgroundColor:[UIColor clearColor]];
    
    
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, [ShareUserInfoCell ShareUserInfoCellHeight]-1, 320.0f, 1)];
    [imageLine setImage:[UIImage imageNamed:@"line3"]];
    [self.contentView addSubview:imageLine];
    [imageLine release];

}

@end
