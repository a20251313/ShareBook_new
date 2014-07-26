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
#import "PublicUtl.h"

@interface ShareBookMissPWViewController (){

    DYBInputView *_phoneInput;
    UIImageView *viewBG ;
    UIScrollView *scrollView;
    UIView *viewLogin;
    DYBInputView * _phoneInputAuthCode;
    DYBInputView * _phoneInputNewPwd;
    DYBInputView * _phoneConfirmNewPwd;

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
        
        
        viewLogin = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, 400)];
        [viewLogin setTag:101];
        [scrollView addSubview:viewLogin];
        [viewLogin release];
        
        //        input_bg
        
        UIImageView *imageViewName = [[UIImageView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT )];
        [imageViewName setImage:[UIImage imageNamed:@"input_bg"]];
        [viewLogin addSubview:imageViewName];
        RELEASE(imageViewName);
        
        
        _phoneInput = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"请输入手机号码" textType:0];
        [_phoneInput.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInput.nameField setTextColor:[UIColor blackColor]];
        [_phoneInput setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInput];
        RELEASE(_phoneInput);
        

        
        UIView *viewBGbtn = [[UIView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, 130.0f, 40.0f)];
        [viewBGbtn setBackgroundColor:[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]];
        
        viewBGbtn.layer.cornerRadius = 10;//设置那个圆角的有多圆
        viewBGbtn.layer.borderWidth = 10;//设置边框的宽度，当然可以不要
        viewBGbtn.layer.borderColor = [[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor];//设置边框的颜色
        viewBGbtn.layer.masksToBounds = YES;//设为NO去试试

        [viewLogin addSubview:viewBGbtn];
        RELEASE(viewBGbtn);
        
        
        
        UIButton *btnGetCode = [[UIButton alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40, 130.0f, 40.0f)];
        [btnGetCode setBackgroundColor:[UIColor clearColor]];
        [btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btnGetCode setBackgroundImage:[UIImage imageNamed:@"bt_click1"] forState:UIControlStateNormal];
        [btnGetCode addTarget:self action:@selector(doGetCode) forControlEvents:UIControlEventTouchUpInside];
        [viewLogin addSubview:btnGetCode];
        RELEASE(btnGetCode);
        
        UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(150.0f,  0 +INPUTHEIGHT  + 40, 160.0f, 40.0f)];
        [labelText setText:@"通过手机获得验证码每天上限3次"];
        [labelText setFont:[UIFont systemFontOfSize:14]];
        [labelText setBackgroundColor:[UIColor clearColor]];
        labelText.lineBreakMode = NSLineBreakByWordWrapping;
        labelText.numberOfLines = 0;
        [labelText setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
        [viewLogin addSubview:labelText];
        RELEASE(labelText)
        
        
        
         _phoneInputAuthCode = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT  + 40*2 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"请输入验证码" textType:0];
        [_phoneInputAuthCode.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        //        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneInputAuthCode.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputAuthCode setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputAuthCode];
        RELEASE(_phoneInputAuthCode);

        
        
        
        _phoneInputNewPwd = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT*2+5  + 40*2 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"请输入新密码" textType:0];
        [_phoneInputNewPwd.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        //        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneInputNewPwd.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputNewPwd.nameField setSecureTextEntry:YES];
        [_phoneInputNewPwd setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneInputNewPwd];
        RELEASE(_phoneInputNewPwd);
        
        
        
        _phoneConfirmNewPwd = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, 0 +INPUTHEIGHT*3+5*2  + 40*2 + 20, INPUTWIDTH, INPUTHEIGHT) placeText:@"确认新密码" textType:0];
        [_phoneConfirmNewPwd.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f]  CGColor]];
        //        [_phoneInputAddr.nameField setText:@"1"];
        [_phoneConfirmNewPwd.nameField setTextColor:[UIColor blackColor]];
        [_phoneConfirmNewPwd.nameField setSecureTextEntry:YES];
        [_phoneConfirmNewPwd setBackgroundColor:[UIColor whiteColor]];
        [viewLogin addSubview:_phoneConfirmNewPwd];
        RELEASE(_phoneConfirmNewPwd);
        
        
        
        
        UIButton *btnBack= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneConfirmNewPwd.frame) + CGRectGetMinY(_phoneConfirmNewPwd.frame) + 20 , 300, 44)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setImage:[UIImage imageNamed:@"bt_click 2"] forState:UIControlStateNormal];
        [btnBack setImage:[UIImage imageNamed:@"bt_click 2"] forState:UIControlStateSelected];
        [btnBack addTarget:self action:@selector(doCommitCode:) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"确认提交" frame:btnBack.frame view:btnBack];
        [viewLogin addSubview:btnBack];
        [btnBack release];
        
        
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)doCommitCode:(id)sender
{
  
    
    [self.view endEditing:YES];
    if ([_phoneInputAuthCode.nameField.text length] < 1)
    {
        [PublicUtl showText:@"请输入验证码" Gravity:iToastGravityCenter];
        return;
    }
    else if ([_phoneInputNewPwd.nameField.text length] < 1)
    {
        [PublicUtl showText:@"请输入新密码" Gravity:iToastGravityCenter];
        return;
    } else if (![_phoneInputNewPwd.nameField.text isEqualToString:_phoneConfirmNewPwd.nameField.text])
    {
        [PublicUtl showText:@"新密码和确认密码不一致，请重新输入" Gravity:iToastGravityCenter];
        return;
    }

    [PublicUtl addHUDviewinView:self.view];
    MagicRequest    *request = [DYBHttpMethod shareBook_ecurity_resetpwd:_phoneInput.nameField.text authCode:_phoneInputAuthCode.nameField.text newPwd:_phoneInputNewPwd.nameField.text sAlert:YES receive:self];
    request.tag = 100;

}

-(void)doGetCode{

    [self.view endEditing:YES];
    if (_phoneInput.nameField.text == nil)
    {
        [PublicUtl showText:@"请输入手机号码" Gravity:iToastGravityCenter];
        return;
    }
    else if ([_phoneInput.nameField.text length] < 11)
    {
        [PublicUtl showText:@"手机号码不合法，请重新输入" Gravity:iToastGravityCenter];
        return;
    }
    [PublicUtl addHUDviewinView:self.view];
    MagicRequest *request = [DYBHttpMethod security_authcode:_phoneInput.nameField.text type:@"2" isAlert:YES receive:self];
    [request setTag:2];
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



#pragma mark- UITextField
- (void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal
{
    if ([signal.source isKindOfClass:[MagicUITextField class]])//完成编辑
    {
        MagicUITextField *textField = [signal source];
        
        if ([signal is:[MagicUITextField TEXTFIELDDIDENDEDITING]])
        {
        }else if ([signal is:[MagicUITextField TEXTFIELD]])
        {
            
        }else if ([signal is:[MagicUITextField TEXTFIELDSHOULDRETURN]])
        {
            [textField resignFirstResponder];
            
        }
        else if ([signal is:[MagicUITextField TEXTFIELDSHOULDCLEAR]])
        {
            
        }else if ([signal is:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) //开始编辑
        {
            
            

            
        }
        
    }
    
    
}



#pragma mark- 只接受HTTP信号

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        [PublicUtl hideHUDViewInView:self.view];
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                 
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }
    }else if(request.tag == 100){
        
        NSDictionary *dict = [request.responseString JSONValue];
        
        if (dict) {
            
            if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                
                [self.view endEditing:YES];
                [PublicUtl showText:@"密码重置成功，请重新登录！" Gravity:iToastGravityCenter];
                [self.drNavigationController popViewControllerAnimated:YES];
            }else{
                NSString *strMSG = [dict objectForKey:@"message"];
                
                [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                
                [self.drNavigationController popToRootViewControllerAnimated:YES];
                
                
            }
            
        } else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}
@end
