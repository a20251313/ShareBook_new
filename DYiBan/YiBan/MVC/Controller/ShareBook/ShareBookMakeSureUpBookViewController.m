//
//  ShareBookMakeSureUpBookViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-3-11.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookMakeSureUpBookViewController.h"
#import "YDSlider.h"
#import "ShareBookMyQuanCenterViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "ShareBookChooseQuanCenterViewController.h"

#define YDIMG(__name)  [UIImage imageNamed:__name]

@interface ShareBookMakeSureUpBookViewController ()<UIActionSheetDelegate>{


    UIImageView *viewBG;
    UILabel      *lableCate;
    int          lent_way;  //借出方式
    int           m_ideposit;  //押金
    int           m_iperiod;    //loan_period
    int           m_iBookCate;      //2 大众，1 少儿
}

@end

@implementation ShareBookMakeSureUpBookViewController
@synthesize dictInfo = _dictInfo,arrayResult,labelAutoQuan1;
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
    // Dispose of any resources that can be recreated.
}



-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"图书上架设置"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        arrayResult = [[NSMutableArray alloc]init];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, self.view.frame.size.height)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setUserInteractionEnabled:YES];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UILabel *labelBookName = [[UILabel alloc]initWithFrame:CGRectMake(20.0f , self.headHeight + 20 , 100.0f, 20.0f)];
        
        [labelBookName setText:@"图书："];
        [labelBookName setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelBookName];
        RELEASE(labelBookName);
        
        
        
        UILabel *labelBookName1 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f + 60, self.headHeight + 20 , 200.0f, 20.0f)];
        
        [labelBookName1 setText:[[_dictInfo objectForKey:@"book"] objectForKey:@"title"]];
        [labelBookName1 setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelBookName1];
        RELEASE(labelBookName1);
        
        
        
        UILabel *labelBorrowStye = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelBookName1.frame) + CGRectGetMinY(labelBookName1.frame) + 20 , 100.0f, 20.0f)];
        
        [labelBorrowStye setText:@"借阅方式："];
        [labelBorrowStye sizeToFit];
        [labelBorrowStye setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelBorrowStye];
        RELEASE(labelBorrowStye);
        
        UIImage *image2 = [UIImage imageNamed:@"icon_cir"];
        UIButton *btnOKzuo = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelBorrowStye.frame) + CGRectGetWidth(labelBorrowStye.frame) + 15, CGRectGetHeight(labelBookName1.frame) + CGRectGetMinY(labelBookName1.frame) + 20 ,20.0f, 20.0f)];
        [btnOKzuo setTag:103];
        [btnOKzuo setImage:image2 forState:UIControlStateNormal];
        [btnOKzuo setImage:YDIMG(@"not_secelt") forState:UIControlStateSelected];
        [btnOKzuo addTarget:self action:@selector(doChoose1:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOKzuo];
        RELEASE(btnOKzuo);
        
        UILabel *labelDo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(btnOKzuo.frame) + CGRectGetWidth(btnOKzuo.frame) + 5, CGRectGetHeight(labelBookName1.frame) + CGRectGetMinY(labelBookName1.frame) + 20 , 100.0f, 20.0f)];
        
        [labelDo setText:@"做客"];
        [labelDo sizeToFit];
        [labelDo setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelDo];
        RELEASE(labelDo);

        UIButton *btnOKTrip = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelDo.frame) + CGRectGetWidth(labelDo.frame) + 5 + 15, CGRectGetHeight(labelBookName1.frame) + CGRectGetMinY(labelBookName1.frame) + 20 ,20.0f, 20.0f)];
        [btnOKTrip setTag:104];
        
        [btnOKTrip setImage:[UIImage imageNamed:@"icon_cir"] forState:UIControlStateNormal];
        [btnOKTrip setImage:[UIImage imageNamed:@"not_secelt"] forState:UIControlStateSelected];
        [btnOKTrip setBackgroundColor:[UIColor clearColor]];
        [btnOKTrip setSelected:YES];
        
        [btnOKTrip addTarget:self action:@selector(doChoose1:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOKTrip];
        RELEASE(btnOKTrip);
        
       
        
        UILabel *labelTrip = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(btnOKTrip.frame) + CGRectGetWidth(btnOKTrip.frame) + 5, CGRectGetHeight(labelBookName1.frame) + CGRectGetMinY(labelBookName1.frame) + 20 , 100.0f, 20.0f)];
        
        [labelTrip setText:@"旅行"];
        [labelTrip sizeToFit];
        [labelTrip setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelTrip];
        RELEASE(labelTrip);
        
        
        UILabel *labelBorrowMeyon= [[UILabel alloc]initWithFrame:CGRectMake(20.0f , CGRectGetHeight(labelBorrowStye.frame) + CGRectGetMinY(labelBorrowStye.frame) + 20 , 100.0f, 20.0f)];
        
        [labelBorrowMeyon setText:@"借阅押金："];
        [labelBorrowMeyon sizeToFit];
        [labelBorrowMeyon setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelBorrowMeyon];
        RELEASE(labelBorrowMeyon);
        
        
        YDSlider *_slider3 = [[YDSlider alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelBorrowMeyon.frame) + CGRectGetWidth(labelBorrowMeyon.frame) + 5, CGRectGetHeight(labelBorrowStye.frame) + CGRectGetMinY(labelBorrowStye.frame) + 20 , 100, 20)];
        _slider3.tag = 1001;
        [_slider3 addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        [viewBG addSubview:_slider3];
        RELEASE(_slider3);
        
        _slider3.value = 0.3;
        _slider3.middleValue = 0.7;
        [_slider3 setThumbImage:YDIMG(@"21X21") forState:UIControlStateNormal];
        [_slider3 setThumbImage:YDIMG(@"21X21") forState:UIControlStateHighlighted];
        [_slider3 setMinimumTrackImage:[YDIMG(@"boby") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
        [_slider3 setMiddleTrackImage:[YDIMG(@"boby2") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
        [_slider3 setMaximumTrackImage:[YDIMG(@"boby2") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
        

        
        
        
        UILabel *labelBackTime = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelBorrowMeyon.frame) + CGRectGetMinY(labelBorrowMeyon.frame) + 20 , 100.0f, 20.0f)];
        
        [labelBackTime setText:@"还书时限："];
        [labelBackTime sizeToFit];
        [labelBackTime setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelBackTime];
        RELEASE(labelBackTime);
        
        
        
        YDSlider *_slider4 = [[YDSlider alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelBorrowMeyon.frame) + CGRectGetWidth(labelBorrowMeyon.frame) + 5, CGRectGetHeight(labelBorrowMeyon.frame) + CGRectGetMinY(labelBorrowMeyon.frame) + 20 , 100, 20)];
        
        [viewBG addSubview:_slider4];
        _slider4.tag = 1002;
        [_slider4 addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        RELEASE(_slider4);
        
        
        _slider4.value = 0.3;
        _slider4.middleValue = 0.7;
        [_slider4 setThumbImage:YDIMG(@"21X21") forState:UIControlStateNormal];
        [_slider4 setThumbImage:YDIMG(@"21X21") forState:UIControlStateHighlighted];
        [_slider4 setMinimumTrackImage:[YDIMG(@"boby") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
        [_slider4 setMiddleTrackImage:[YDIMG(@"boby2") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];
        [_slider4 setMaximumTrackImage:[YDIMG(@"boby2") resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 5, 4) resizingMode:UIImageResizingModeStretch]];

        
        UILabel *labelNumDou = [[UILabel alloc]initWithFrame:CGRectMake(220.0f + 0, CGRectGetHeight(labelBorrowStye.frame) + CGRectGetMinY(labelBorrowStye.frame) + 20 , 100.0f, 20.0f)];
        [labelNumDou setBackgroundColor:[UIColor clearColor]];
        [labelNumDou setText:@"10乐享豆"];
        labelNumDou.tag = 1003;
        [viewBG addSubview:labelNumDou];
        RELEASE(labelNumDou);
        
        
        UILabel *labelNumTime = [[UILabel alloc]initWithFrame:CGRectMake(220.0f + 0, CGRectGetHeight(labelBorrowMeyon.frame) + CGRectGetMinY(labelBorrowMeyon.frame) + 20 , 100.0f, 20.0f)];
        [labelNumTime setBackgroundColor:[UIColor clearColor]];
        [labelNumTime setText:@"10天"];
          labelNumTime.tag = 1004;
        [viewBG addSubview:labelNumTime];
        RELEASE(labelNumTime);
        
        
        
        UILabel *labelBookCate = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelNumTime.frame) + CGRectGetMinY(labelNumTime.frame) + 20 , 180.0f, 20.0f)];
        [labelBookCate setBackgroundColor:[UIColor clearColor]];
        [labelBookCate setText:@"图书类别："];
        [labelBookCate setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelBookCate];
        RELEASE(labelBookCate);
        
        
        
        lableCate = [[UILabel alloc]initWithFrame:CGRectMake(20.0f + 100, CGRectGetHeight(labelNumTime.frame) + CGRectGetMinY(labelNumTime.frame) + 20 , 80.0f, 20.0f)];
        [lableCate setBackgroundColor:[UIColor clearColor]];
        [lableCate setText:@"大众"];
        [lableCate setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:lableCate];
        RELEASE(lableCate);
        
        
        
        
        
        
        UIButton *btnCate = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(lableCate.frame) + CGRectGetWidth(lableCate.frame) + 20,CGRectGetHeight(labelNumTime.frame) + CGRectGetMinY(labelNumTime.frame) + 15 , 70, 30)];
        [btnCate setTitle:@"更改" forState:UIControlStateNormal];
        [btnCate setBackgroundImage:[UIImage imageNamed:@"bt_click1"] forState:UIControlStateNormal];
        [btnCate addTarget:self action:@selector(doModifyCate:) forControlEvents:UIControlEventTouchUpInside];
        [btnCate setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:btnCate];
        RELEASE(btnCate);
        
        
        
        
        
        UILabel *labelAutoQuan = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelBookCate.frame) + CGRectGetMinY(labelBookCate.frame) + 20 , 180.0f, 20.0f)];
        [labelAutoQuan setBackgroundColor:[UIColor clearColor]];
        [labelAutoQuan setText:@"上传圈子："];
        [labelAutoQuan setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelAutoQuan];
        RELEASE(labelAutoQuan);
        
        labelAutoQuan1 = [[UILabel alloc]initWithFrame:CGRectMake(20.0f + 100, CGRectGetHeight(labelBookCate.frame) + CGRectGetMinY(labelBookCate.frame) + 20 , 130.0f, 20.0f)];
        [labelAutoQuan1 setBackgroundColor:[UIColor clearColor]];
        [labelAutoQuan1 setText:@"请选择圈子"];
        [labelAutoQuan1 setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelAutoQuan1];
        RELEASE(labelAutoQuan1);
        
        
        UIButton *btnQuan = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelAutoQuan1.frame) + CGRectGetWidth(labelAutoQuan1.frame),CGRectGetHeight(labelBookCate.frame) + CGRectGetMinY(labelBookCate.frame) + 10 , 100, 30)];
        [btnQuan setTitle:@"添加圈子" forState:UIControlStateNormal];
        [btnQuan addTarget:self action:@selector(doQuan) forControlEvents:UIControlEventTouchUpInside];
       // [btnQuan setBackgroundColor:[UIColor redColor]];
        [btnQuan setBackgroundImage:[UIImage imageNamed:@"bt_click1"] forState:UIControlStateNormal];
        [viewBG addSubview:btnQuan];
        RELEASE(btnQuan);

        
        
        UILabel *labelAutoLogin = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelAutoQuan.frame) + CGRectGetMinY(labelAutoQuan.frame) + 20  , 180.0f, 20.0f)];
        [labelAutoLogin setBackgroundColor:[UIColor clearColor]];
        [labelAutoLogin setText:@"是否以秘钥方式上传："];
        [labelAutoLogin setBackgroundColor:[UIColor clearColor]];
        [viewBG addSubview:labelAutoLogin];
        RELEASE(labelAutoLogin);
        
        m_iperiod = 10;
        m_ideposit = 10;
        m_iBookCate = 2;
        
//        UIButton *btnAutoLogin = [[UIButton alloc]initWithFrame:CGRectMake(200.0f, CGRectGetHeight(labelNumTime.frame) + CGRectGetMinY(labelNumTime.frame) + 20 , 20.0f, 20.0f)];
//        [btnAutoLogin setBackgroundColor:[UIColor clearColor]];
//        [btnAutoLogin setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
//        [btnAutoLogin setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateSelected];
//        [viewBG addSubview:btnAutoLogin];
//        [btnAutoLogin addTarget:self action:@selector(atuoLogin:) forControlEvents:UIControlEventTouchUpInside];
//        
//        RELEASE(btnAutoLogin);
//        
        
        
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(20.0f,CGRectGetHeight(labelAutoLogin.frame) + CGRectGetMinY(labelAutoLogin.frame) + 20, 280.0f, 40.0f)];
        [btnOK setTag:102];
        [btnOK setImage:image1 forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(doMakeUpload:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK];
        RELEASE(btnOK);
        
        [self addlabel_title:@"确认上架" frame:btnOK.frame view:btnOK];

        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        if (labelAutoQuan1 && self.arrayResult ) {
            
            
//            [labelAutoQuan1 setText:[self.dictResult objectForKey:@"circle_name"]];
        }
        
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)doModifyCate:(id)sender
{
    
    UIActionSheet   *sheet = [[UIActionSheet alloc] initWithTitle:@"图书类别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"大众" otherButtonTitles:@"少儿", nil];
    [sheet showInView:self.view];
    [sheet release];
}



-(void)doQuan{

    ShareBookChooseQuanCenterViewController *my = [[ShareBookChooseQuanCenterViewController alloc] init];
    my.makesure = self;
    my.bEnter = NO;
    [self.drNavigationController pushViewController:my animated:YES];
    RELEASE(my);

}


-(void)atuoLogin:(id)sender{

    UIButton *btn = (UIButton *)sender;

    if (btn.selected) {
        [btn setSelected:NO];
    }else{
    
        [btn setSelected:YES];
    }

}



-(void)sliderValueChange:(YDSlider*)slider
{
    if (slider.tag == 1001)
    {
        m_ideposit = slider.value*30;
        UILabel *labelDou = (UILabel*)[viewBG viewWithTag:1003];
        [labelDou setText:[NSString stringWithFormat:@"%d乐享豆",m_ideposit]];
        
        
    }else
    {
        m_iperiod = slider.value*30;
        UILabel *labelDou = (UILabel*)[viewBG viewWithTag:1004];
        [labelDou setText:[NSString stringWithFormat:@"%d天",m_iperiod]];
    }
}

-(void)doChoose1:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 103) {
        
        UIButton *btn104   = (UIButton *)[self.view viewWithTag:104];

        if (btn.selected) {
            [btn setSelected:NO];
            [btn104 setSelected:YES];
            
        }else{
        
            [btn setSelected:YES];
            [btn104 setSelected:NO];
            
            lent_way = 1;
        }
    }else {
        
     UIButton *btn103   = (UIButton *)[self.view viewWithTag:103];
        
        if (btn.selected) {
            [btn setSelected:NO];
            [btn103 setSelected:YES];
            
        }else{
            
            [btn setSelected:YES];
            [btn103 setSelected:NO];
            lent_way = 2;
        }

        
        
    
    }
    



}

-(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:100];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}


- (void)onSliderValueChanged:(YDSlider* )slider {
    NSLog(@"Slider value=%f, middleValue=%f", slider.value, slider.middleValue);
}


-(void)doMakeUpload:(id)sender
{

    if (!self.arrayResult.count) {
        
        [DYBShareinstaceDelegate popViewText:@"请选择圈子" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }
    
    NSString    *cirleIDs = [self.arrayResult componentsJoinedByString:@","];
    
    DLogInfo(@"doChoose cirleIDs:%@",cirleIDs);
    NSDictionary *dict = [_dictInfo objectForKey:@"book"];
    MagicRequest *request = [DYBHttpMethod shareBook_book_upload_book_id:[dict objectForKey:@"id"] lent_way:[NSString stringWithFormat:@"%d",lent_way] deposit_type:@"1" deposit:[NSString stringWithFormat:@"%d",m_ideposit]  loan_period:[NSString stringWithFormat:@"%d",m_iperiod]  public:@"1" remark:@"eeeee" lat:@"dd" lng:@"ddd" sskey:@"11" address:@"ddd" circle_id:cirleIDs rent:@"1" tag_ids:[@(m_iBookCate) description] sAlert:YES receive:self];
    [request setTag:2];




}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    //JsonResponse *response = (JsonResponse *)receiveObj; //登陆成功，记下
                    
                    //                    SHARED.sessionID = response.sessID;
                    //
                    //                    self.DB.FROM(USERMODLE)
                    //                    .SET(@"userInfo", request.responseString)
                    //                    .SET(@"userIndex",[dict objectForKey:@"user_id"])
                    //                    .INSERT();
                    
                    //                    SHARED.userId = [dict objectForKey:@"user_id"]; //设置userid 全局变量
                    
                    //                    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
                    //
                    //                    [self.drNavigationController pushViewController:vc animated:YES];
                    [DYBShareinstaceDelegate popViewText:@"上传成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
           //     BOOL result = [[dict objectForKey:@"result"] boolValue];
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    //                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
                    //                    [btn setTag:10];
                    //                    [self doChange:btn];
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        } else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}
#pragma mark UIActionSheetdelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        m_iBookCate = 2;
        [lableCate setText:@"大众"];
    }else if (buttonIndex == 1)
    {
        m_iBookCate = 1;
        [lableCate setText:@"少儿"];
    }
    
}

@end
