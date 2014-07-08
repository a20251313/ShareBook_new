//
//  ShareBookApplyViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookOrderCommentController.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyCell.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookMoreAddrViewController.h"
#import "NSDate+Helpers.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "JFSegmentControlView.h"


@interface ShareBookOrderCommentController ()<UITextFieldDelegate,JFSegmentControlViewDelegate>{


    
    UITextField *_commentInput;
    UIView      *bgTopView;
    
    int      order_status;
    int      fromUserID;
    int      toUserID;
    
    int      m_nowIndex;
    
    int      point;
}

@end

@implementation ShareBookOrderCommentController
@synthesize orderID;
@synthesize bookName;
@synthesize bookOwner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}





-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"评论"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
          [self.view setBackgroundColor:COLOR_RGB(236, 236, 236)];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {

        
        CGFloat fypoint = self.headHeight;
        
        
        UIImage *imageStar = [UIImage imageNamed:@"icon_star.png"];
        
        bgTopView = [[UIView alloc] initWithFrame:CGRectMake(0, fypoint, self.view.frame.size.width, 50)];
        bgTopView.backgroundColor = COLOR_RGB(215, 215, 215);
        CGFloat fwidth = imageStar.size.width;
        CGFloat fsep = 10;
        CGFloat fxpoint = (bgTopView.frame.size.width-fwidth*5-fsep*4)-40;
        
        
        
        UILabel *labelXinyong = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,80, 30)];
        [labelXinyong setBackgroundColor:[UIColor clearColor]];
        [labelXinyong setText:[NSString stringWithFormat:@"信用评价:"]];
        [labelXinyong setTextColor:[UIColor blackColor]];
        [bgTopView addSubview:labelXinyong];
        [labelXinyong release];
        
        for (int i = 0; i < 5; i++)
        {
            UIButton   *btnStar = [[UIButton alloc] initWithFrame:CGRectMake(fxpoint, (bgTopView.frame.size.height-imageStar.size.height)/2, imageStar.size.width, imageStar.size.height)];
            [btnStar setImage:[UIImage imageNamed:@"icon_star.png"] forState:UIControlStateNormal];
             [btnStar setImage:[UIImage imageNamed:@"icon_star2.png"] forState:UIControlStateSelected];
            [btnStar addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
            btnStar.tag = i+10;
            [bgTopView addSubview:btnStar];
            [btnStar release];
            fxpoint += imageStar.size.width+fsep;
        }
        
        [self.view addSubview:bgTopView];

        
        fypoint += fsep+50;
        
        
        UILabel *labelBookName = [[UILabel alloc] initWithFrame:CGRectMake(10, fypoint, self.view.frame.size.width, 30)];
        [labelBookName setBackgroundColor:[UIColor clearColor]];
        [labelBookName setText:[NSString stringWithFormat:@"书  名：%@",self.bookName]];
        [labelBookName setTextColor:[UIColor blackColor]];
        [self.view addSubview:labelBookName];
        [labelBookName release];
        
        fypoint += fsep+30;
        UILabel *labelBookOwner = [[UILabel alloc] initWithFrame:CGRectMake(10, fypoint, self.view.frame.size.width, 30)];
        [labelBookOwner setBackgroundColor:[UIColor clearColor]];
        [labelBookOwner setText:[NSString stringWithFormat:@"书  主：%@",self.bookOwner]];
        [labelBookOwner setTextColor:[UIColor blackColor]];
        [self.view addSubview:labelBookOwner];
        [labelBookOwner release];
        
        fypoint += fsep+30;
      
        
        
       /* JFSegmentControlView    *controll = [[JFSegmentControlView alloc] initWithFrame:CGRectMake(100, fypoint, 140, 30) withitems:@[@"好评",@"差评"]];
       // controll.btnBgColor = [UIColor whiteColor];
        [self.view addSubview:controll];
        controll.delegate = self;
        [controll release];
        
        
        fypoint += 30;*/
        _commentInput = [[UITextField alloc] initWithFrame:CGRectMake(10,     fypoint, self.view.frame.size.width-20, 40)];
        _commentInput.delegate = self;
        _commentInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _commentInput.layer.borderWidth = 1;
        [self.view addSubview:_commentInput];
        
        
        fypoint = _commentInput.frame.origin.y + _commentInput.frame.size.height+10;
        UIImage *btnImage = [UIImage imageNamed:@"bt01_click"];
        UIButton *btnBorrow = [[UIButton alloc]initWithFrame:CGRectMake(((self.view.frame.size.width-btnImage.size.width/2))/2,fypoint, btnImage.size.width/2, btnImage.size.height/2)];
        [btnBorrow setTag:102];
        [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
        [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
        [btnBorrow setBackgroundColor:[UIColor yellowColor]];
        [btnBorrow addTarget:self action:@selector(clickCommit:) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"提交评论" frame:btnBorrow.frame view:btnBorrow textColor:[UIColor whiteColor]];
        [self.view addSubview:btnBorrow];
        RELEASE(btnBorrow);
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)clickStar:(UIButton*)sender
{
    [sender setSelected:YES];
    int index = sender.tag - 10+1;
    for (int i = 0; i < 5; i++)
    {
        UIButton *btn = (UIButton*)[sender.superview viewWithTag:10+i];
        if (i < index)
        {
            [btn setSelected:YES];
        }else
        {
            [btn setSelected:NO];
        }
        
    }
    if (1)
    {
        point =  index;
    }else
    {
        point = 0;
    }
    
}
-(void)clickCommit:(id)sender
{
    if ([_commentInput.text length] < 1)
    {
         [DYBShareinstaceDelegate popViewText:@"评论不能为空" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }else if(point < 1)
    {
        [DYBShareinstaceDelegate popViewText:@"评分不能为0" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        
    }else{
        MagicRequest    *request = [DYBHttpMethod book_order_comment:self.orderID comment:_commentInput.text point:[@(point) description] sAlert:YES receive:self];
        request.tag = 100;
    }
}

-(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view textColor:(UIColor *)textColor{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:100];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:textColor];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}



#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
            if(request.tag == 100)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    [DYBShareinstaceDelegate popViewText:@"提交评论成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self.drNavigationController popViewControllerAnimated:YES];
                    
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        }
        
    }
}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }
}






- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self clickCommit:nil];
    return YES;
}

#pragma mark JFSegmentControlViewDelegate
-(void)segIndexChanged:(NSInteger)Nowindex
{
    m_nowIndex = Nowindex;

}


@end
