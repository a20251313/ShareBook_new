//
//  ShareBookCellBtnCenterView.m
//  ShareBook
//
//  Created by apple on 14-3-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookCellBtnCenterView.h"

@implementation ShareBookCellBtnCenterView
@synthesize viewBG;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)addBtnView:(int)type{

    switch (type) {
        case 0:
            [self viewForBookAtStore:self.viewBG];
            break;
        case 1:
            [self viewForBookBorrowIn:self.viewBG];
            break;
        case 2:
            [self viewForBookBorrowOut:self.viewBG];
            break;
        case 3:
            [self viewForBookTrip:self.viewBG];
            break;
        case 4:
            [self viewForBookOrder:self.viewBG];
            break;
        default:
            break;
    }


}
//架上图书
-(void)viewForBookAtStore:(UIView *)viewCell{

    UIImage *image = [UIImage imageNamed:@"btn_added"];
    
    MagicUIButton *btnBookSecond = [[MagicUIButton alloc]initWithFrame:CGRectMake(30.0f + 10, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];
    [btnBookSecond setImage:[UIImage imageNamed:@"btn_added"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookSecond ];
    RELEASE(btnBookSecond);
    
    MagicUIButton *btnBookDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4+ 30,  (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];
    [btnBookDown setImage:[UIImage imageNamed:@"btn_off"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookDown ];
    RELEASE(btnBookDown);
    

    MagicUIButton *btnBookShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4 * 2 + 20, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookShare setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookShare ];
    RELEASE(btnBookShare);
    
    MagicUIButton *btnBookHistory = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4 * 3, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookHistory setImage:[UIImage imageNamed:@"btn_history"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookHistory ];
    RELEASE(btnBookHistory);
}
//借入图书
-(void)viewForBookBorrowIn:(UIView *)viewCell{
    
    UIImage *image = [UIImage imageNamed:@"btn_added"];

    
    MagicUIButton *btnBookSecond = [[MagicUIButton alloc]initWithFrame:CGRectMake(30.0f + 10 + 20, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookSecond setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookSecond ];
    RELEASE(btnBookSecond);
    
    MagicUIButton *btnBookDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4+ 30 + 30,  (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookDown setImage:[UIImage imageNamed:@"btn_evaluate"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookDown ];
    RELEASE(btnBookDown);
    
    
    MagicUIButton *btnBookShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4 * 2 + 20 + 50 , (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookShare setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookShare ];
    RELEASE(btnBookShare);
  
    
}

//借出图书
-(void)viewForBookBorrowOut:(UIView *)viewCell{
    
    UIImage *image = [UIImage imageNamed:@"btn_added"];

    
    MagicUIButton *btnBookSecond = [[MagicUIButton alloc]initWithFrame:CGRectMake(30.0f + 10, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookSecond setImage:[UIImage imageNamed:@"btn_con"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookSecond ];
    RELEASE(btnBookSecond);
    
    MagicUIButton *btnBookDown = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4+ 30,  (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];
    [btnBookDown setImage:[UIImage imageNamed:@"btn_remind"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookDown ];
    RELEASE(btnBookDown);
    
    
    MagicUIButton *btnBookShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4 * 2 + 20, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookShare setImage:[UIImage imageNamed:@"btn_evaluate_people"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookShare ];
    RELEASE(btnBookShare);
    
    MagicUIButton *btnBookHistory = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4 * 3, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];
    

    [btnBookHistory setImage:[UIImage imageNamed:@"btn_history"] forState:UIControlStateNormal];
    [viewCell addSubview:btnBookHistory ];
    RELEASE(btnBookHistory);
    
}
//旅行中的图书
-(void)viewForBookTrip:(UIView *)viewCell{
    
    UIImage *image = [UIImage imageNamed:@"btn_added"];
    
    MagicUIButton *btnBookShare = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4+ 30,  (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

        [btnBookShare setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
        [viewCell addSubview:btnBookShare ];
        RELEASE(btnBookShare);
        
    MagicUIButton *btnBookHistory = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4 * 2 + 20, (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

    [btnBookHistory setImage:[UIImage imageNamed:@"btn_history"] forState:UIControlStateNormal];
        [viewCell addSubview:btnBookHistory ];
        RELEASE(btnBookHistory);
    
    
}

//预定中的图书
-(void)viewForBookOrder:(UIView *)viewCell{
    
    
    UIImage *image = [UIImage imageNamed:@"btn_added"];

    MagicUIButton *btnBookHistory = [[MagicUIButton alloc]initWithFrame:CGRectMake(320/4+ 30 + 40,  (90 - image.size.height/1.5)/2, image.size.width/1.5, image.size.height/1.5)];

        [btnBookHistory setImage:[UIImage imageNamed:@"btn_send_history"] forState:UIControlStateNormal];
        [viewCell addSubview:btnBookHistory ];
        RELEASE(btnBookHistory);
    
    
}


@end
