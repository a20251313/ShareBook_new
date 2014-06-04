//
//  ShareBookMissPWViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-27.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookMissPWViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "JSONKit.h"
#import "JSON.h"

@interface ShareBookMissPWViewController (){

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

}

@end

@implementation ShareBookMissPWViewController

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
    //    22 29 36
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"重置密码"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.rightButton setHidden:YES];
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
        
        UIImageView *imageViewMid = [[UIImageView alloc]initWithFrame:CGRectMake(320/2, 0, 1, 20)];
        [imageViewMid setImage:[UIImage imageNamed:@"line"]];
        [viewBG addSubview:imageViewMid];
        RELEASE(imageViewMid);
        
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight + 20, 320.0f, 400)];
        
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
        
        
        DYBInputView *  _phoneInputAddrR1 = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40 *2, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:0];
        [_phoneInputAddrR1.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor clearColor] CGColor]];
        //        [_phoneInputAddrR.nameField setText:@"1"];
        [_phoneInputAddrR1.nameField setTextColor:[UIColor whiteColor]];
        [_phoneInputAddrR1 setBackgroundColor:[UIColor clearColor]];
        [viewResgin addSubview:_phoneInputAddrR1];
        RELEASE(_phoneInputAddrR1);
        
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
        
        
        _phoneInputName = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"请输入手机号码" textType:0];
        [_phoneInputName.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputName.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputName setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputName];
        RELEASE(_phoneInputName);
        
        
//        UIImageView *imageViewName2 = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT)];
//        [imageViewName2 setImage:[UIImage imageNamed:@"input_bg"]];
//        [viewLogin addSubview:imageViewName2];
//        RELEASE(imageViewName2);
        
        

        
        
//        _phoneInputAddr = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:0];
//        [_phoneInputAddr.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
//        //        [_phoneInputAddr.nameField setText:@"1"];
//        [_phoneInputAddr.nameField setTextColor:[UIColor blackColor]];
//        [_phoneInputAddr setBackgroundColor:[UIColor whiteColor]];
//        [viewLogin addSubview:_phoneInputAddr];
//        RELEASE(_phoneInputAddr);
        
        
//        188
        
        UIView *viewBGbtn = [[UIView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, 130.0f, 40.0f)];
        [viewBGbtn setBackgroundColor:[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]];
        
        viewBGbtn.layer.cornerRadius = 10;//设置那个圆角的有多圆
        viewBGbtn.layer.borderWidth = 10;//设置边框的宽度，当然可以不要
        viewBGbtn.layer.borderColor = [[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor];//设置边框的颜色
        viewBGbtn.layer.masksToBounds = YES;//设为NO去试试

        [viewLogin addSubview:viewBGbtn];
        RELEASE(viewBGbtn);
        
        
        
        UIButton *btnGetCode = [[UIButton alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, 130.0f, 40.0f)];
//        [btnGetCode setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [btnGetCode setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [btnGetCode setBackgroundColor:[UIColor clearColor]];
        [btnGetCode setTitle:@"获得验证码" forState:UIControlStateNormal];
        [btnGetCode addTarget:self action:@selector(doGetCode) forControlEvents:UIControlEventTouchUpInside];
        [viewLogin addSubview:btnGetCode];
        RELEASE(btnGetCode);
        
        UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(150.0f,  0 +INPUTHEIGHT  + 40, 160.0f, 40.0f)];
        [labelText setText:@"通过手机获得验证码每天上线3次"];
        [labelText setFont:[UIFont systemFontOfSize:14]];
        [labelText setBackgroundColor:[UIColor clearColor]];
        labelText.lineBreakMode = UILineBreakModeWordWrap;
        labelText.numberOfLines = 0;
        [labelText setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
        [viewLogin addSubview:labelText];
        RELEASE(labelText)
        
        
        
        DYBInputView * _phoneInputAddr1 = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40*2 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"请输入验证码" textType:0];
        [_phoneInputAddr1.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        //        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneInputAddr1.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputAddr1 setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputAddr1];
        RELEASE(_phoneInputAddr1);
        //        [self addViewforAutoLogin ];
        
        
        
        UIButton *btnBack= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneInputAddr1.frame) + CGRectGetMinY(_phoneInputAddr1.frame) + 20 , 300, 44)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"bt_click 2"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageNamed:@"bt_click 2"] forState:UIControlStateSelected];
        [btnBack addTarget:self action:@selector(addOKLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"确认提交" frame:btnBack.frame view:btnBack];
        [viewLogin addSubview:btnBack];
        [btnBack release];
        
        
        
        
        
        //        UIButton *btnBackGO= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(btnBack.frame) + CGRectGetMinY(btnBack.frame) + 20 , 300, 44)];
        //        [btnBackGO setBackgroundColor:[UIColor clearColor]];
        //        [btnBackGO setImage:[UIImage imageNamed:@"bt2.png"] forState:UIControlStateNormal];
        //        [btnBackGO setImage:[UIImage imageNamed:@"bt2_click.png"] forState:UIControlStateSelected];
        //        [btnBackGO addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
        //        //        [self addlabel_title:@"逛一逛" frame:btnBackGO.frame view:btnBackGO];
        //        [viewLogin addSubview:btnBackGO];
        //        [btnBackGO release];
        
        //        UIImage *imageLine = [UIImage imageNamed:@"line"];
        //        UIImageView *labelOtherLogin = [[UIImageView alloc]initWithFrame:CGRectMake((320 - imageLine.size.width/2)/2, CGRectGetHeight(btnBackGO.frame) + CGRectGetMinY(btnBackGO.frame)  + 15, imageLine.size.width/2, imageLine.size.height/2)];
        //
        //        [labelOtherLogin setImage:[UIImage imageNamed:@"line"]];
        //        [viewLogin addSubview:labelOtherLogin];
        //        RELEASE(labelOtherLogin);
        
        
        //        [self addOtherLogin];
        
        UIView *viewRigen = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 400)];
        [viewRigen setHidden:YES];
        [scrollView addSubview:viewRigen];
        RELEASE(viewRigen);
        
        
        
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)addOKLogin{




}

-(void)doGetCode{


    MagicRequest *request = [DYBHttpMethod security_authcode:_phoneInputName.nameField.text type:@"1" isAlert:YES receive:self];
    [request setTag:2];
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
    [labelMissPW setText:@"忘记密码"];
    [viewLogin addSubview:labelMissPW];
    RELEASE(labelMissPW);
    
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
                    
//                    SHARED.sessionID = response.sessID;
                    
//                    self.DB.FROM(USERMODLE)
//                    .SET(@"userInfo", request.responseString)
//                    .SET(@"userIndex",[dict objectForKey:@"user_id"])
//                    .INSERT();
//                    
//                    SHARED.userId = [[dict objectForKey:@"data"] objectForKey:@"user_id"]; //设置userid 全局变量
//                    DLogInfo(@"SHARED.userId -- >%@",SHARED.userId);
//                    
//                    // 注册推送
////                    [APService setTags:nil alias:SHARED.userId callbackSelector:nil object:nil];
//                    
//                    
//                    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
//                    
//                    [self.drNavigationController pushViewController:vc animated:YES];
//                    
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
//                    
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
@end
