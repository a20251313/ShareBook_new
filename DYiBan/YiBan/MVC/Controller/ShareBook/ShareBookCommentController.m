//
//  ShareBookApplyViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookCommentController.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyCell.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookMoreAddrViewController.h"
#import "NSDate+Helpers.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"


@interface ShareBookCommentController ()<UITextViewDelegate>{

    UITextView *_commentInput;
}

@end

@implementation ShareBookCommentController
@synthesize pubID;

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
        
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {

        _commentInput = [[UITextView alloc] initWithFrame:CGRectMake(10, self.headHeight+10, self.view.frame.size.width-20, 100)];
        _commentInput.delegate = self;
        _commentInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _commentInput.layer.borderWidth = 1;
        
        [self.view addSubview:_commentInput];
        
        
        CGFloat fypoint = _commentInput.frame.origin.y + _commentInput.frame.size.height+10;
        UIImage *btnImage = [UIImage imageNamed:@"bt01_click"];
        UIButton *btnBorrow = [[UIButton alloc]initWithFrame:CGRectMake(((self.view.frame.size.width-btnImage.size.width/2))/2,fypoint, btnImage.size.width/2, btnImage.size.height/2)];
        [btnBorrow setTag:102];
        [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
        [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
        [btnBorrow setBackgroundColor:[UIColor yellowColor]];
        [btnBorrow addTarget:self action:@selector(clickCommit:) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"提交评论" frame:btnBorrow.frame view:btnBorrow textColor:[UIColor whiteColor]];
        [self.view addSubview:btnBorrow];
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)clickCommit:(id)sender
{
    if ([_commentInput.text length] < 1)
    {
         [DYBShareinstaceDelegate popViewText:@"评论不能为空" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }else
    {
        MagicRequest    *request = [DYBHttpMethod book_book_comment:self.pubID content:_commentInput.text points:@"5" sAlert:YES receive:self];
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


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}



@end
