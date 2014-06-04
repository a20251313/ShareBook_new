//
//  WOSLogInViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSLogInViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
//#import "MagicRequest.h"
#import "NSObject+MagicDatabase.h"
#import "ShareBookResignViewController.h"
#import "DYBHttpMethod.h"
#import "JSONKit.h"
#import "JSON.h"
#import "Magic_Database.h"
#import "ShareBookMissPWViewController.h"
#import "APService.h"

@interface WOSLogInViewController (){

    DYBInputView *_phoneInputName;
    DYBInputView *_phoneInputAddr;
    UIButton *btnLogin;
    UIButton *btnResgin;
    UIImageView *viewBG ;
    UIScrollView *scrollView;
    UIView *viewLogin;


    UIView *viewResgin;
    DYBInputView *_phoneInputNameR;
    DYBInputView *_phoneInputAddrR;
    DYBInputView *_phoneInputMORF;


	TencentOAuth* _tencentOAuth;
    NSMutableArray *_permissions;
}

@end

@implementation WOSLogInViewController

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

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
//    22 29 36
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"登陆"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];

        [self setButtonImage:self.rightButton setImage:@"bt"];
        [self.leftButton setHidden:YES];
        //        [self.view setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0f]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor clearColor]];
//        bg
        viewBG = [[UIImageView alloc]initWithFrame:self.view.frame];
        [viewBG setTag:100];
//        [viewBG setBackgroundColor:ColorBG];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [self.view insertSubview:viewBG atIndex:0];
        RELEASE(viewBG);
        
//        btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 44.0f, 320/2,20)];
//        [btnLogin setBackgroundColor:[UIColor blackColor]];
//        [btnLogin setTitle:@"登陆" forState:UIControlStateNormal];
//        [btnLogin setTitleColor:ColorTextYellow forState:UIControlStateNormal];
//        [btnLogin addTarget:self action:@selector(doChange:) forControlEvents:UIControlEventTouchUpInside];
//        [btnLogin setTag:10];
//        [viewBG addSubview:btnLogin];
//        RELEASE(btnLogin);
        
        UIImageView *imageViewMid = [[UIImageView alloc]initWithFrame:CGRectMake(320/2, 0, 1, 20)];
        [imageViewMid setImage:[UIImage imageNamed:@"line"]];
        [viewBG addSubview:imageViewMid];
        RELEASE(imageViewMid);
        
//        btnResgin = [[UIButton alloc]initWithFrame:CGRectMake(320/2+1 , 44.0f, 320/2,20)];
//        [btnResgin setBackgroundColor:[UIColor blackColor]];
//        [btnResgin setTitle:@"注册" forState:UIControlStateNormal];
//        [btnResgin setTag:11];
//        [btnResgin addTarget:self action:@selector(doChange:) forControlEvents:UIControlEventTouchUpInside];
//        [viewBG addSubview:btnResgin];
//        RELEASE(btnResgin);
        
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, CGRectGetHeight(self.view.frame))];
        
        [self.view addSubview:scrollView];
        RELEASE(scrollView);
        
        viewResgin = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, 400)];
        [viewResgin setTag:102];
        [viewResgin setHidden:YES];
        [scrollView addSubview:viewResgin];
        [viewResgin release];
        
        
        
        
        UIImageView *imageViewNameR= [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT )];
        [imageViewNameR setImage:[UIImage imageNamed:@"input_bg"]];
        [viewResgin addSubview:imageViewNameR];
        RELEASE(imageViewNameR);
        
        
        _phoneInputNameR = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"用户名" textType:0];
        [_phoneInputNameR.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
//        [_phoneInputNameR.nameField setText:@"1"];
        [_phoneInputNameR.nameField setTextColor:[UIColor yellowColor]];
        [_phoneInputNameR setBackgroundColor:[UIColor redColor]];
        [viewResgin addSubview:_phoneInputNameR];
        RELEASE(_phoneInputNameR);
        
        
        UIImageView *imageViewName2R = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT)];
        [imageViewName2R setImage:[UIImage imageNamed:@"input_bg"]];
        [viewResgin addSubview:imageViewName2R];
        RELEASE(imageViewName2R);
        
        _phoneInputAddrR = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:0];
        [_phoneInputAddrR.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
//        [_phoneInputAddrR.nameField setText:@"1"];
        [_phoneInputAddrR.nameField setTextColor:[UIColor whiteColor]];
        [_phoneInputAddrR setBackgroundColor:[UIColor clearColor]];
        [viewResgin addSubview:_phoneInputAddrR];
        RELEASE(_phoneInputAddrR);
        
        
        UIImageView *imageViewName3R = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40 + 20 +INPUTHEIGHT , INPUTWIDTH, INPUTHEIGHT)];
        [imageViewName3R setImage:[UIImage imageNamed:@"input_bg"]];
        [viewResgin addSubview:imageViewName3R];
        RELEASE(imageViewName3R);
        
        _phoneInputMORF = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  +40 + 20 +INPUTHEIGHT, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:0];
        [_phoneInputMORF.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
        [_phoneInputMORF.nameField setText:@"0"];
        [_phoneInputMORF.nameField setTextColor:[UIColor whiteColor]];
        [_phoneInputMORF setBackgroundColor:[UIColor clearColor]];
        [viewResgin addSubview:_phoneInputMORF];
        RELEASE(_phoneInputMORF);
        
        
        UIButton *btnBackR = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneInputMORF.frame) + CGRectGetMinY(_phoneInputMORF.frame) + 20 + 10, 300, 44)];
        [btnBackR setBackgroundColor:[UIColor clearColor]];
        [btnBackR setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [btnBackR addTarget:self action:@selector(addRisgin) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"注册" frame:btnBackR.frame view:btnBackR];
        [viewResgin addSubview:btnBackR];
        [btnBackR release];

        
        
        
        viewLogin = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, 400)];
        
        [viewLogin setTag:101];
        [scrollView addSubview:viewLogin];
        [viewLogin release];
        
//        input_bg
        
        UIImageView *imageViewName = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT )];
        [imageViewName setImage:[UIImage imageNamed:@"input_bg"]];
        [viewLogin addSubview:imageViewName];
        RELEASE(imageViewName);
        
        
        _phoneInputName = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"用户名" textType:0];
        [_phoneInputName.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        [_phoneInputName.nameField setText:@"test2"];
        [_phoneInputName.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputName setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputName];
        RELEASE(_phoneInputName);
        
        
        UIImageView *imageViewName2 = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT)];
        [imageViewName2 setImage:[UIImage imageNamed:@"input_bg"]];
        [viewLogin addSubview:imageViewName2];
        RELEASE(imageViewName2);
        
        _phoneInputAddr = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:0];
        [_phoneInputAddr.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        [_phoneInputAddr.nameField setText:@"11111"];
        [_phoneInputAddr.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputAddr setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputAddr];
        RELEASE(_phoneInputAddr);

        
        [self addViewforAutoLogin ];
        
        
        
        UIButton *btnBack= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 40 + 10, 300, 44)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"bt1_click"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageNamed:@"bt1_click"] forState:UIControlStateSelected];
        [btnBack addTarget:self action:@selector(addOKLogin) forControlEvents:UIControlEventTouchUpInside];
//        [self addlabel_title:@"登陆" frame:btnBack.frame view:btnBack];
        [viewLogin addSubview:btnBack];
        [btnBack release];
        
        
        UIButton *btnBackGO= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(btnBack.frame) + CGRectGetMinY(btnBack.frame) + 20 , 300, 44)];
        [btnBackGO setBackgroundColor:[UIColor clearColor]];
        [btnBackGO setImage:[UIImage imageNamed:@"bt2.png"] forState:UIControlStateNormal];
        [btnBackGO setImage:[UIImage imageNamed:@"bt2_click.png"] forState:UIControlStateSelected];
        [btnBackGO addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
//        [self addlabel_title:@"逛一逛" frame:btnBackGO.frame view:btnBackGO];
        [viewLogin addSubview:btnBackGO];
        [btnBackGO release];
        
        UIImage *imageLine = [UIImage imageNamed:@"line"];
        UIImageView *labelOtherLogin = [[UIImageView alloc]initWithFrame:CGRectMake((320 - imageLine.size.width/2)/2, CGRectGetHeight(btnBackGO.frame) + CGRectGetMinY(btnBackGO.frame)  + 15, imageLine.size.width/2, imageLine.size.height/2)];
        
        [labelOtherLogin setImage:[UIImage imageNamed:@"line"]];
        [viewLogin addSubview:labelOtherLogin];
        RELEASE(labelOtherLogin);
        
        
        [self addOtherLogin];
        
        UIView *viewRigen = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 400)];
        [viewRigen setHidden:YES];
        [scrollView addSubview:viewRigen];
        RELEASE(viewRigen);
        
        
        
        _permissions = [[NSMutableArray arrayWithObjects:
                         kOPEN_PERMISSION_GET_USER_INFO,
                         kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                         kOPEN_PERMISSION_ADD_ALBUM,
                         kOPEN_PERMISSION_ADD_IDOL,
                         kOPEN_PERMISSION_ADD_ONE_BLOG,
                         kOPEN_PERMISSION_ADD_PIC_T,
                         kOPEN_PERMISSION_ADD_SHARE,
                         kOPEN_PERMISSION_ADD_TOPIC,
                         kOPEN_PERMISSION_CHECK_PAGE_FANS,
                         kOPEN_PERMISSION_DEL_IDOL,
                         kOPEN_PERMISSION_DEL_T,
                         kOPEN_PERMISSION_GET_FANSLIST,
                         kOPEN_PERMISSION_GET_IDOLLIST,
                         kOPEN_PERMISSION_GET_INFO,
                         kOPEN_PERMISSION_GET_OTHER_INFO,
                         kOPEN_PERMISSION_GET_REPOST_LIST,
                         kOPEN_PERMISSION_LIST_ALBUM,
                         kOPEN_PERMISSION_UPLOAD_PIC,
                         kOPEN_PERMISSION_GET_VIP_INFO,
                         kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                         kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                         kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                         nil] retain];
        
        NSString *appid = @"101046123";
//        titleLabel.text = [NSString stringWithFormat:@"Demo 1 with appid:%@",appid];
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                                andDelegate:self];
        
        
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)addViewforAutoLogin{
    UIButton *btnAutoLogin = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 20 , 20.0f, 20.0f)];
    [btnAutoLogin setBackgroundColor:[UIColor clearColor]];
    [btnAutoLogin setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
    [btnAutoLogin setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateSelected];
    [viewLogin addSubview:btnAutoLogin];
    [btnAutoLogin addTarget:self action:@selector(atuoLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    RELEASE(btnAutoLogin);
    
    
    UILabel *labelAutoLogin = [[UILabel alloc]initWithFrame:CGRectMake(20.0f + 30, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 20 , 100.0f, 20.0f)];
    [labelAutoLogin setBackgroundColor:[UIColor clearColor]];
    [labelAutoLogin setText:@"自动登陆"];
    [viewLogin addSubview:labelAutoLogin];
    RELEASE(labelAutoLogin);
    
    
    UIButton *btnMissPW = [[UIButton alloc]initWithFrame:CGRectMake(30.0f + 150, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 0 + 20 , 20.0f, 20.0f)];
    [btnMissPW setBackgroundColor:[UIColor clearColor]];
    [btnMissPW setImage:[UIImage imageNamed:@"icon_q"] forState:UIControlStateNormal];
    [viewLogin addSubview:btnMissPW];
    [btnMissPW addTarget:self action:@selector(forgetPW:) forControlEvents:UIControlEventTouchUpInside];
    
    
    RELEASE(btnMissPW);
    
    
    UILabel *labelMissPW = [[UILabel alloc]initWithFrame:CGRectMake(10.0f + 200, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 20 , 100.0f, 20.0f)];
    [labelMissPW setBackgroundColor:[UIColor clearColor]];

    [labelMissPW setText:@"忘记密码"];
    [labelMissPW setUserInteractionEnabled:YES];
    [viewLogin addSubview:labelMissPW];
    RELEASE(labelMissPW);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetPW:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [labelMissPW addGestureRecognizer:tap];
    RELEASE(tap);
    
}


-(void)doMess{


}

-(void)addOKLogin{

    MagicRequest *request = [DYBHttpMethod shareBook_security_login_username:_phoneInputName.nameField.text password:_phoneInputAddr.nameField.text sAlert:YES receive:self];
    [request setTag:2];


}

-(void)addOtherLogin{

    UIImage *imageIcon = [UIImage imageNamed:@"icon_qq"];
    
    for (int i = 0; i< 3; i++) {
        
        UIButton *btnLoginOther = [[UIButton alloc]initWithFrame:CGRectMake(20.0f + (imageIcon.size.width/2 + 20)* i  + 40, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 0 + 20 + 200, imageIcon.size.width/2, imageIcon.size.height/2)];
        [btnLoginOther setTag:10 + i];
        [btnLoginOther addTarget:self action:@selector(onClickTencentOAuth:) forControlEvents:UIControlEventTouchUpInside];
        [btnLoginOther setBackgroundColor:[UIColor clearColor]];
        [viewLogin addSubview:btnLoginOther];
        RELEASE(btnLoginOther);
        
        
        switch (i) {
            case 0:
                [btnLoginOther setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
                break;
            case 1:
                [btnLoginOther setImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
                break;
            case 2:
                [btnLoginOther setImage:[UIImage imageNamed:@"icon_dou"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
   
}

-(void)atuoLogin:(id)sender{

    NSLog(@"auto");
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        
        [btn setSelected:NO];
        
    }else{

        [btn setSelected:YES];
    
    }

}

-(void)forgetPW:(id)sender{


    ShareBookMissPWViewController *mess = [[ShareBookMissPWViewController alloc]init];
    [self.drNavigationController pushViewController:mess animated:YES];
    RELEASE(mess);

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


-(void)doChange:(id)sender{

    UIButton *btn = (UIButton *)sender;
    if (btnLogin.tag  == btn.tag) {
        
        [viewResgin setHidden:YES];
        [viewLogin setHidden:NO];
        [btnLogin setTitleColor:ColorTextYellow forState:UIControlStateNormal];
        [btnResgin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        
        [viewResgin setHidden:NO];
        [viewLogin setHidden:YES];
        [btnResgin setTitleColor:ColorTextYellow forState:UIControlStateNormal];
        [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    }


}

//DEF_SIGNAL(TEXTFIELDSHOULDBEGINEDITING)
//DEF_SIGNAL(TEXTFIELDDIDBEGINEDITING)
//DEF_SIGNAL(TEXTFIELDSHOULDENDEDITING)
//DEF_SIGNAL(TEXTFIELDDIDENDEDITING)
//DEF_SIGNAL(TEXTFIELD)
//DEF_SIGNAL(TEXTFIELDSHOULDCLEAR)
//DEF_SIGNAL(TEXTFIELDSHOULDRETURN)
//DEF_SIGNAL(TEXT_OVERFLOW)//文字超长

//MagicUITextField
-(void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal{
    if ([signal isKindOf:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) {
        
        [scrollView setContentSize:CGSizeMake(320.0f, CGRectGetHeight(self.view.frame))];
//        [viewBG setCenter:CGPointMake(160, self.view.frame.size.height/2 -30)];
        
    }else if ([signal isKindOf:[MagicUITextField TEXTFIELDDIDENDEDITING]]){
    
//        [viewBG setCenter:CGPointMake(160, self.view.frame.size.height/2 +10 )];
    
    }else if ([signal isKindOf:[MagicUITextField TEXTFIELDSHOULDRETURN]]){
    
//        [viewBG setCenter:CGPointMake(160, self.view.bounds.size.height/2 +10 )];
      MagicUITextField *filed = (MagicUITextField *)[signal source];
        [filed resignFirstResponder];
    
    }



}


-(void)addRisgin{


        MagicRequest *request = [DYBHttpMethod wosRegion_nickName:_phoneInputNameR.nameField.text passwd:_phoneInputAddrR.nameField.text sex:_phoneInputMORF.nameField.text sAlert:YES receive:self];
        [request setTag:3];
    
}

-(void)addOK{
    
    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
   [self.drNavigationController pushViewController:vc animated:YES];
//    [vc];
//    MagicRequest *request = [DYBHttpMethod wosLongin_nickName:_phoneInputName.nameField.text passwd:_phoneInputAddr.nameField.text sAlert:YES receive:self];
//    [request setTag:2];
    
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
//        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            
        
       NSDictionary *dict = [request.responseString JSONValue];
        
        if (dict) {

            if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                
                 JsonResponse *response = (JsonResponse *)receiveObj; //登陆成功，记下
                
                SHARED.sessionID = response.sessID;
                
                self.DB.FROM(USERMODLE)
                .SET(@"userInfo", request.responseString)
                .SET(@"userIndex",[dict objectForKey:@"user_id"])
                .INSERT();
               
                SHARED.userId = [[dict objectForKey:@"data"] objectForKey:@"user_id"]; //设置userid 全局变量
                DLogInfo(@"SHARED.userId -- >%@",SHARED.userId);

            // 注册推送
                [APService setTags:nil alias:SHARED.userId callbackSelector:nil object:nil];

                
                DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
                
                [self.drNavigationController pushViewController:vc animated:YES];
                
            }else{
                NSString *strMSG = [dict objectForKey:@"message"];
                
                [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                
            
            }
        }
        }else if(request.tag == 3){
        
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTag:10];
                    [self doChange:btn];
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
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
//        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        //        [self goShowOrderListAction];
        
        ShareBookResignViewController *resg = [[ShareBookResignViewController alloc]init];
        [self.drNavigationController pushViewController:resg animated:YES];
        RELEASE(resg);
    }
}

- (void)onClickTencentOAuth:(id)sender {
//	_labelTitle.text = @"开始获取token";
	[_tencentOAuth authorize:_permissions inSafari:NO];
}
- (void)tencentDidLogin {

    NSLog(@"qq 登陆成功");

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
    [super dealloc];
}



@end
