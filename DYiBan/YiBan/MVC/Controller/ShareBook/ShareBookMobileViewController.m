//
//  ShareBookMobileViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-3-5.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookMobileViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "JSON.h"



@interface ShareBookMobileViewController ()
{
    DYBInputView  *_phoneInputPhoneNumber;
    DYBInputView  *_phoneInputAuthCode;
    UIButton      *_btnGetCode;
}

@end

@implementation ShareBookMobileViewController

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
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"绑定手机"];
        
        //        [self setButtonImage:self.leftButton setImage:@"back"];
        //        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        //        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 10, 100.0f, 40.0f)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setText:@"手机号码："];
        [self.view addSubview:labelName];
        RELEASE(labelName);
        
        _phoneInputPhoneNumber = [[DYBInputView alloc]initWithFrame:CGRectMake(100,self.headHeight + 10, 200, 35) placeText:@"输入手机号码" textType:0];
        [_phoneInputPhoneNumber.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputPhoneNumber.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputPhoneNumber setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_phoneInputPhoneNumber];
        RELEASE(_phoneInputPhoneNumber);
        
        
        
        UIImage *image = [UIImage imageNamed:@"bt_click1"];
        _btnGetCode = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(_phoneInputPhoneNumber.frame) + CGRectGetMinY(_phoneInputPhoneNumber.frame) + 20, 280.0f, 40.0f)];
        [_btnGetCode setTag:102];
        [_btnGetCode setImage:image forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [_btnGetCode addTarget:self action:@selector(doGetValiteCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnGetCode];
        RELEASE(_btnGetCode);
        
        [self addlabel_title:@"获得验证码" frame:_btnGetCode.frame view:_btnGetCode];
        
        
        
        
        UILabel *labelJINWEI = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_btnGetCode.frame) + CGRectGetMinY(_btnGetCode.frame) + 20, 100.0f, 40.0f)];
        [labelJINWEI setText:@"验证码："];
        [self.view addSubview:labelJINWEI];
        RELEASE(labelJINWEI);
        [labelJINWEI setBackgroundColor:[UIColor clearColor]];

        _phoneInputAuthCode = [[DYBInputView alloc]initWithFrame:CGRectMake(100,CGRectGetHeight(_btnGetCode.frame) + CGRectGetMinY(_btnGetCode.frame) + 20, 200, 35) placeText:@"输入验证码" textType:0];
        [_phoneInputAuthCode.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputAuthCode.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputAuthCode setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_phoneInputAuthCode];
        RELEASE(_phoneInputAuthCode);

        
        
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK1 = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(_phoneInputAuthCode.frame) + CGRectGetMinY(_phoneInputAuthCode.frame) + 50, 280.0f, 40.0f)];
        [btnOK1 setTag:102];
        [btnOK1 setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnOK1 addTarget:self action:@selector(doCommitCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK1];
        RELEASE(btnOK1);
        
        [self addlabel_title:@"提交验证码" frame:btnOK1.frame view:btnOK1];
        
        DYBUITableView * tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0,200 , 320.0f , self.view.frame.size.height -100 - 60 - 100  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        //        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        //        RELEASE(tbDataBank11);
        
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
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



-(void)doCommitCode:(id)sender
{
    MagicRequest    *request = [DYBHttpMethod security_verifyauthcode:_phoneInputPhoneNumber.nameField.text acuthcode:_phoneInputAuthCode.nameField.text isAlert:YES receive:self];
    request.tag =  101;
   
    
}

-(void)doGetValiteCode:(id)sender
{
    MagicRequest    *request = [DYBHttpMethod security_authcode:_phoneInputPhoneNumber.nameField.text type:@"0" isAlert:YES receive:self];
    request.tag =  100;
    
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
       
      if(request.tag == 100){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"])
                {
                    

                }else
                {
                    NSString *strMSG = [dict objectForKey:@"message"];
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                }
                
                
            }
            
      }if(request.tag == 100){
          
          NSDictionary *dict = [request.responseString JSONValue];
          
          if (dict) {
              if ([[dict objectForKey:@"response"] isEqualToString:@"100"])
              {
                  
                  [self.drNavigationController popToRootViewControllerAnimated:YES];
              }else
              {
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
