//
//  ShareBookApplyCell.m
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookApplyCell.h"

@implementation ShareBookApplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)getDateString:(NSString*)dataInter
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:[dataInter floatValue]];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setTimeZone:[NSTimeZone localTimeZone]];
    [formater setLocale:[NSLocale currentLocale]];
    [formater setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    NSString    *strDate = [formater stringFromDate:date];
    [formater release];
    return strDate;
    
}



-(UIView*)getViewAccordContent:(NSString*)content isLeft:(BOOL)isleft
{
    UIImageView  *view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 23, 300, 45)];
    CGFloat  fheight = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 4999) lineBreakMode:NSLineBreakByWordWrapping].height;
    if (fheight > 45)
    {
        fheight = 45;
    }
    NSLog(@"fheight:%f content:%@",fheight,content);
    UILabel *labelMSG = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,300, fheight)];
    [labelMSG setText:content];
    [labelMSG setFont:[UIFont systemFontOfSize:15]];
    [labelMSG setNumberOfLines:0];
    [labelMSG setBackgroundColor:[UIColor clearColor]];
    [view addSubview:labelMSG];
    if (isleft)
    {
        
        UIImage *image = [UIImage imageNamed:@"discussbg_01"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2+1, image.size.width/2+1, image.size.height/2-1, image.size.width/2-1)];
         view.image = image;
    }else
    {
        UIImage *image = [UIImage imageNamed:@"discussbg_02"];
       // image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2+1, image.size.width/2+1, image.size.height/2-1, image.size.width/2-1)];
        view.image = image;
    }
   
    RELEASE(labelMSG);
    
    return [view autorelease];
    
}

-(void)creatCell:(NSDictionary *) dict{

    NSString *userID = [dict objectForKey:@"user_id"];
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0,5, 320, 21.0f)];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    if ([dict objectForKey:@"date"])
    {
          [labelTime setText:[self getDateString:[dict objectForKey:@"date"]]];
    }else if ([dict objectForKey:@"time"])
    {
            [labelTime setText:[self getDateString:[dict objectForKey:@"time"]]];
    }

    [labelTime setFont:[UIFont systemFontOfSize:13.0f]];
    [labelTime setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:labelTime];
    [labelTime release];
    if ([userID isEqualToString:SHARED.userId]) {
        
        UIView  *contentView  = [self getViewAccordContent:[dict objectForKey:@"content"] isLeft:NO];
        [self addSubview:contentView];

    }else{
    
        UIView  *contentView  = [self getViewAccordContent:[dict objectForKey:@"content"] isLeft:YES];
        [self addSubview:contentView];
    
    }

    
    
}
@end
