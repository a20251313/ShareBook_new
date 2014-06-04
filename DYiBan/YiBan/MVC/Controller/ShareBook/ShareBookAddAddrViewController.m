//
//  ShareBookAddAddrViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-3-5.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookAddAddrViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"


@interface ShareBookAddAddrViewController ()

@end

@implementation ShareBookAddAddrViewController

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
        [self.headview setTitle:@"添加地址"];

        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);;

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 20, 200.0, 30.0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"输入新地址："];
        [self.view addSubview:label];
        RELEASE(label);
        
        
        DYBInputView *_phoneInputName = [[DYBInputView alloc]initWithFrame:CGRectMake((320-INPUTWIDTH)/2, self.headHeight + 60, INPUTWIDTH, INPUTHEIGHT) placeText:@"地址" textType:0];
        [_phoneInputName.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputName.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputName setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_phoneInputName];
        RELEASE(_phoneInputName);
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(20.0f,self.headHeight + 60 + INPUTHEIGHT + 20 , 280.0f, 40.0f)];
        [btnOK setTag:102];
        [btnOK setImage:image1 forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(doChoose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK];
        RELEASE(btnOK);
        
        [self addlabel_title:@"确认添加" frame:btnOK.frame view:btnOK];
        
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




@end
