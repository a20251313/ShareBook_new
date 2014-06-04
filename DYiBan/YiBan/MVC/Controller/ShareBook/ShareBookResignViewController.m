//
//  ShareBookResignViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-27.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookResignViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookMobileViewController.h"
#import "JSONKit.h"
#import "JSON.h"



@interface ShareBookResignViewController (){

    
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
    DYBInputView * _phoneInputAddr1;

}

@end

@implementation ShareBookResignViewController

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
        [self.headview setTitle:@"注册"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
//       [self.rightButton setHidden:YES];
        
          [self setButtonImage:self.rightButton setImage:@"btMobile"];
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
        
        
        _phoneInputName = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"用户名" textType:0];
        [_phoneInputName.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputName.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputName setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputName];
        RELEASE(_phoneInputName);
        
        
        UIImageView *imageViewName21 = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT)];
        [imageViewName21 setImage:[UIImage imageNamed:@"input_bg"]];
        [viewLogin addSubview:imageViewName21];
        RELEASE(imageViewName21);
        _phoneInputNameR = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, INPUTWIDTH, INPUTHEIGHT) placeText:@"昵称" textType:0];
        [_phoneInputNameR.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputNameR.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputNameR setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputNameR];
        RELEASE(_phoneInputNameR);
        
        
        UIImageView *imageViewName2 = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20 +INPUTHEIGHT  + 40*2, INPUTWIDTH, INPUTHEIGHT)];
        [imageViewName2 setImage:[UIImage imageNamed:@"input_bg"]];
        [viewLogin addSubview:imageViewName2];
        RELEASE(imageViewName2);
        
        _phoneInputAddr = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20 +INPUTHEIGHT  + 40*2, INPUTWIDTH, INPUTHEIGHT) placeText:@"密码" textType:0];
        [_phoneInputAddr.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        //        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneInputAddr.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputAddr setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputAddr];
        RELEASE(_phoneInputAddr);
        
       _phoneInputAddr1 = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 20 +INPUTHEIGHT  + 40*3 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"确认密码" textType:0];
        [_phoneInputAddr1.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        //        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneInputAddr1.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputAddr1 setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputAddr1];
        RELEASE(_phoneInputAddr1);
//        [self addViewforAutoLogin ];
        
        
        
        UIButton *btnBack= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneInputAddr.frame) + CGRectGetMinY(_phoneInputAddr.frame) + 40 + 10 + 30, 300, 44)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"bt_click 2"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageNamed:@"bt_click 2"] forState:UIControlStateSelected];
        [btnBack addTarget:self action:@selector(addOKLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"确认提交" frame:btnBack.frame view:btnBack];
        [viewLogin addSubview:btnBack];
        [btnBack release];
        
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
    
    if (![_phoneInputAddr.nameField.text isEqualToString:_phoneInputAddr1.nameField.text]) {
        
        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
        [pop setDelegate:self];
        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
        [pop setText:@"2次输入的密码不同"];
        [pop alertViewAutoHidden:.5f isRelease:YES];
        return;
        
    }
    
    
   MagicRequest *request =   [DYBHttpMethod shareBook_security_reg_username:_phoneInputName.nameField.text password:_phoneInputAddr.nameField.text phone_num:@"" nickName:_phoneInputNameR.nameField.text  sAlert:YES receive:self];
//    MagicRequest *request = [DYBHttpMethod shareBook_security_reg_username:_phoneInputNameR.nameField.text passwd:_phoneInputAddrR.nameField.text sex:_phoneInputMORF.nameField.text sAlert:YES receive:self];
    [request setTag:3];
    
}

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

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        ShareBookMobileViewController *mobile = [[ShareBookMobileViewController alloc]init];
        [self.drNavigationController pushViewController:mobile animated:YES];
        RELEASE(mobile);
        
    }
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
                    
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
//                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
//                    [btn setTag:10];
////                    [self doChange:btn];
                    
                    [self.drNavigationController popViewControllerAnimated:YES];
                }
//                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
//                }
            }
            
        } else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}


@end
