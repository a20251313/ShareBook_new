//
//  ShareBookCircleCell
//  ShareBook
//
//  Created by tom zeng on 14-2-13.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookCircleCell.h"

@implementation ShareBookCircleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSString*)getDistanceNum:(NSString*)disValue
{
    NSString    *strDic = [disValue lowercaseString];
    strDic = [strDic stringByReplacingOccurrencesOfString:@"k" withString:@""];
    strDic = [strDic stringByReplacingOccurrencesOfString:@"m" withString:@"m"];
    strDic = [strDic stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if ([strDic floatValue] < 1)
    {
        strDic = [NSString stringWithFormat:@"%.0fm",[strDic floatValue]*1000];
    }else
    {
        strDic = [NSString stringWithFormat:@"%0.2fkm",[strDic floatValue]];
    }
    
    return strDic;
    
}
-(void)creatCell:(NSDictionary*)dicInfo{

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 260.0f, 30.0f)];
    [label setText:[dicInfo objectForKey:@"circle_name"]];
    [self addSubview:label];
    RELEASE(label);
    
    
    UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 220, 20)];
    NSString *temp = [NSString stringWithFormat:@"热度：%@人 | %@书 | %@交易",[dicInfo objectForKey:@"hots"],[dicInfo objectForKey:@"book_num"],[dicInfo objectForKey:@"loan_num"]];
    [labelB setText:temp];
    [labelB setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelB setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:labelB];
    RELEASE(labelB);
    
    
    
    if (self.isHasDistance)
    {
        UILabel *labelDis = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 220, 20)];
        [labelDis setText:[NSString stringWithFormat:@"距离:%@",[self getDistanceNum:[dicInfo valueForKey:@"distance_num"]]]];
        [labelDis setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
        [labelDis setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:labelDis];
        RELEASE(labelDis);
    }
 
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

}

@end
