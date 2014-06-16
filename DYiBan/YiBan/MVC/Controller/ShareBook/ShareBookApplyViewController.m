//
//  ShareBookApplyViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookApplyViewController.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyCell.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookMoreAddrViewController.h"
#import "NSDate+Helpers.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"


@interface ShareBookApplyViewController (){

    UILabel *labelTime1;
    DYBInputView *_phoneInputNameRSend;
    
    DYBInputView *_phoneInputNameR;
    BOOL bKeyShow;
    UIDatePicker *datePicker;
    DYBUITableView * tbDataBank11;
    NSMutableArray *arrayDate;
    
    NSDictionary *dictRR;
    NSString *order_id;
    
    int      order_status;
    int      fromUserID;
    int      toUserID;
}

@end

@implementation ShareBookApplyViewController
@synthesize dictInfo,mi = _mi;

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



-(void)setAgreeViewShow
{
    
    BOOL bhide = ([[[dictRR objectForKey:@"order"] objectForKey:@"order_status"] intValue] != 1);
    
    if (bhide) {
        UIView *view = [self.headview viewWithTag:100];
        view.hidden = YES;
    }else
    {
        
        UIView *view = [self.headview viewWithTag:100];
        if (view)
        {
              view.hidden = NO;
        }else
        {
            view = [[UIView alloc]initWithFrame:CGRectMake(220.0f, 20.0f, 100.0f, 44.0f)];
            [view setTag:100];
            [view setBackgroundColor:[UIColor redColor]];
            [self.headview addSubview:view];
            //                RELEASE(view);
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0,  40.0f,44.0f)];
            [btn1 addTarget:self action:@selector(tongyi) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitle:@"同意" forState:UIControlStateNormal];
            [view addSubview:btn1];
            RELEASE(btn1);
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(50.0f, 0.0,  40.0f,44.0f)];
            [btn2 addTarget:self action:@selector(tongyi1) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitle:@"不" forState:UIControlStateNormal];
            [view addSubview:btn2];
            RELEASE(btn2);
            
        }
      
    }
    
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"申请借阅"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
//        book_loan_pub_id
        
        
        
        order_id = [[NSString alloc]init];
        
//        order_detail_order_id
        
        if (_mi) {
            
            MagicRequest *request = [DYBHttpMethod order_detail_order_id:_mi sAlert:YES receive:self];
            [request setTag:3];

        }else {
        
            MagicRequest *request = [DYBHttpMethod book_order_pub_id:[dictInfo objectForKey:@"pub_id"] sAlert:YES receive:self];
            [request setTag:100];
        
        
        }
       
        
        
        arrayDate = [[NSMutableArray alloc]init];
//        [self.rightButton setHidden:YES];
        bKeyShow = NO;
        [self.view setBackgroundColor:[MagicCommentMethod colorWithHex:@"f0f0f0"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAddMessage:) name:@"GETMESSAGE" object:nil];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        };
        
        if (!_mi) {
            
            
            UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, self.view.frame.size.height)];
            [viewBG setBackgroundColor:[MagicCommentMethod colorWithHex:@"f0f0f0"]];
            [self.view addSubview:viewBG];
            RELEASE(viewBG);
            
            
            UIImage *imageIcon = [UIImage imageNamed:@"defualt_book"];
            UIImageView *imageBook = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f + self.headHeight, imageIcon.size.width/2, imageIcon.size.height/2)];
        
            [imageBook setBackgroundColor:[UIColor clearColor]];
            [imageBook setImage:[UIImage imageNamed:@"defualt_book"]];
            
            if ([dictInfo valueForKey:@"image"])
            {
                [imageBook setImageWithURL:[NSURL URLWithString:[dictInfo valueForKey:@"image"]]];
            }
            [viewBG addSubview:imageBook];
            [imageBook release];
            
            UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, 5.0f + self.headHeight, 240, 20)];

            [labelName setText:@"三生三室枕上书"];
            
            if ([dictInfo valueForKey:@"title"])
            {
                [labelName setText:[dictInfo valueForKey:@"title"]];
            }
            [viewBG addSubview:labelName];
            [labelName release];
            
            UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelName.frame) + CGRectGetHeight(labelName.frame) + 0, 200, 20)];
            
            if ([dictInfo valueForKey:@"author"])
            {
                [labelAuther setText:[NSString stringWithFormat:@"作者：%@",[dictInfo valueForKey:@"author"]]];
            }
         
            [labelAuther setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
            
            [labelAuther setFont:[UIFont systemFontOfSize:15]];
            [viewBG addSubview:labelAuther];
            [labelAuther release];
            
            UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelAuther.frame) + CGRectGetHeight(labelAuther.frame) + 0, 200, 20)];
            [labelPublic setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
            if ([dictInfo valueForKey:@"publisher"])
            {
                [labelPublic setText:[NSString stringWithFormat:@"出版社：%@",[dictInfo valueForKey:@"publisher"]]];
            }
          
            [viewBG addSubview:labelPublic];
            [labelPublic setFont:[UIFont systemFontOfSize:14]];
            [labelPublic release];
            
            
            UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 200, 20)];
            [labelTime setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
            [labelTime setText:[NSString stringWithFormat:@"借阅时间：%@天",[dictInfo objectForKey:@"loan_period"]]];
            [viewBG addSubview:labelTime];
            [labelTime setFont:[UIFont systemFontOfSize:14]];
            [labelTime release];
            
            labelTime1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelTime.frame) + CGRectGetMinX(labelTime.frame) -130, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 200, 20)];
            [labelTime1 setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
            [labelTime1 setText:[NSString stringWithFormat:@"2014-02-20 15：30"]];
            [viewBG addSubview:labelTime1];
            [labelTime1 setFont:[UIFont systemFontOfSize:14]];
            [labelTime1 release];
            
            UIButton *btnChooseTime = [[UIButton alloc]initWithFrame:CGRectMake(280.0f, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 20.0f, 20.0f)];
            [btnChooseTime setBackgroundColor:[UIColor clearColor]];
            [btnChooseTime setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
            [btnChooseTime addTarget:self action:@selector(doChooseTime) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnChooseTime];
            RELEASE(btnChooseTime);
            
            
            
            _phoneInputNameR = [[DYBInputView alloc]initWithFrame:CGRectMake( 5, CGRectGetMinY(btnChooseTime.frame) + CGRectGetHeight(btnChooseTime.frame) + 10, 250, 40) placeText:@"长宁区天山路145号" textType:0];
            [_phoneInputNameR.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
            //        [_phoneInputNameR.nameField setText:@"1"];
            [_phoneInputNameR.nameField setTextColor:[UIColor blackColor]];
            [_phoneInputNameR setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:_phoneInputNameR];
            RELEASE(_phoneInputNameR);
            
            
            UIButton *btnMoreAddr = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_phoneInputNameR.frame) + CGRectGetMinX(_phoneInputNameR.frame)+ 5 , CGRectGetMinY(btnChooseTime.frame) + CGRectGetHeight(btnChooseTime.frame)+ 10, 55, 30)];
            [btnMoreAddr addTarget:self action:@selector(doMoreAddr) forControlEvents:UIControlEventTouchUpInside];
            
            [btnMoreAddr setImage:[UIImage imageNamed:@"top_bt_bg"] forState:UIControlStateNormal];
            [btnMoreAddr setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:btnMoreAddr];
            RELEASE(btnMoreAddr);
            [self addlabel_title:@"选地址" frame:btnMoreAddr.frame view:btnMoreAddr];
            
            tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_phoneInputNameR.frame) + CGRectGetHeight(_phoneInputNameR.frame) + 10, 320.0f, self.view.frame.size.height -CGRectGetMinY(_phoneInputNameR.frame) + CGRectGetHeight(_phoneInputNameR.frame) + 10  ) isNeedUpdate:YES];
            [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:tbDataBank11];
            [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
            RELEASE(tbDataBank11);
            [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            [self creatDownBar];

            
            
        }
        
        
        
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)tongyi{

    
    
    NSString    *order = [[[dictRR objectForKey:@"order"] objectForKey:@"order_id"] description];
    MagicRequest *request = [DYBHttpMethod order_confirm_msg_id:order type:@"1" sAlert:YES receive:self];
    [request setTag:4];
    

}
-(void)tongyi1{

    MagicRequest *request = [DYBHttpMethod order_confirm_msg_id:[[[dictRR objectForKey:@"charts"]objectAtIndex:0] objectForKey:@"id"] type:@"2" sAlert:YES receive:self];
    [request setTag:4];

}


-(void)creatView:(NSDictionary *)dict{
    
    
    NSDictionary *dicttt = [[dict objectForKey:@"order"] objectForKey:@"book"];
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height)];
    [viewBG setBackgroundColor:[MagicCommentMethod colorWithHex:@"f0f0f0"]];
    [self.view addSubview:viewBG];
    RELEASE(viewBG);
    
    
    UIImage *imageIcon = [UIImage imageNamed:@"defualt_book"];
    UIImageView *imageBook = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f , imageIcon.size.width/2, imageIcon.size.height/2)];
    [imageBook setBackgroundColor:[UIColor clearColor]];
    [imageBook setImage:[UIImage imageNamed:@"defualt_book"]];
    [imageBook setImageWithURL:[NSURL URLWithString:[dicttt valueForKey:@"book_image"]]];
    [viewBG addSubview:imageBook];
    [imageBook release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, 5.0f + 0, 200, 20)];
    [labelName setText:[dicttt objectForKey:@"book_name"]];
    [viewBG addSubview:labelName];
    [labelName release];
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelName.frame) + CGRectGetHeight(labelName.frame) + 0, 200, 20)];
    [labelAuther setText:[ NSString stringWithFormat:@"作者：%@",[dicttt objectForKey:@"book_author"]]];
    [labelAuther setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    
    [labelAuther setFont:[UIFont systemFontOfSize:15]];
    [viewBG addSubview:labelAuther];
    [labelAuther release];
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelAuther.frame) + CGRectGetHeight(labelAuther.frame) + 0, 200, 20)];
    [labelPublic setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelPublic setText:[NSString stringWithFormat:@"出版社:"]];
    [viewBG addSubview:labelPublic];
    [labelPublic setFont:[UIFont systemFontOfSize:14]];
    [labelPublic release];
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 200, 20)];
    [labelTime setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelTime setText:[NSString stringWithFormat:@"借阅时间：%@",[[dict objectForKey:@"order"] objectForKey:@"loan_time"]]];
    [viewBG addSubview:labelTime];
    [labelTime setFont:[UIFont systemFontOfSize:14]];
    [labelTime release];
    
    labelTime1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelTime.frame) + CGRectGetMinX(labelTime.frame) -130, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 200, 20)];
    [labelTime1 setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelTime1 setText:[NSString stringWithFormat:@"2014-02-20 15：30"]];
    [viewBG addSubview:labelTime1];
    [labelTime1 setFont:[UIFont systemFontOfSize:14]];
    [labelTime1 release];
    
    UIButton *btnChooseTime = [[UIButton alloc]initWithFrame:CGRectMake(280.0f, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + self.headHeight, 20.0f, 20.0f)];
    [btnChooseTime setBackgroundColor:[UIColor clearColor]];
    [btnChooseTime setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [btnChooseTime addTarget:self action:@selector(doChooseTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChooseTime];
    RELEASE(btnChooseTime);
    
    
    
    _phoneInputNameR = [[DYBInputView alloc]initWithFrame:CGRectMake( 5, CGRectGetMinY(btnChooseTime.frame) + CGRectGetHeight(btnChooseTime.frame) + 10 , 250, 40) placeText:@"长宁区天山路145号" textType:0];
    [_phoneInputNameR.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
    //        [_phoneInputNameR.nameField setText:@"1"];
    [_phoneInputNameR.nameField setDelegate:self];
    [_phoneInputNameR.nameField setTextColor:[UIColor blackColor]];
    [_phoneInputNameR setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_phoneInputNameR];
    RELEASE(_phoneInputNameR);
    
    
    UIButton *btnMoreAddr = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_phoneInputNameR.frame) + CGRectGetMinX(_phoneInputNameR.frame)+ 5 , CGRectGetMinY(btnChooseTime.frame) + CGRectGetHeight(btnChooseTime.frame)+ 10, 55, 30)];
    [btnMoreAddr addTarget:self action:@selector(doMoreAddr) forControlEvents:UIControlEventTouchUpInside];
    
    [btnMoreAddr setImage:[UIImage imageNamed:@"top_bt_bg"] forState:UIControlStateNormal];
    [btnMoreAddr setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btnMoreAddr];
    RELEASE(btnMoreAddr);
    [self addlabel_title:@"选地址" frame:btnMoreAddr.frame view:btnMoreAddr];
    
    
    NSArray *rr = [dict objectForKey:@"charts"];
    for (int i = 0; i < rr.count; i++) {
        NSDictionary *dictTime = [rr objectAtIndex:i];
        
        NSString *strDate = [dictTime objectForKey:@"time"];
        
        NSString *content = [dictTime objectForKey:@"content"];
        
        NSString *index =   [SHARED.userId isEqualToString:[dictTime objectForKey:@"user_id"]] ? @"2" : @"1";
        
        NSDictionary *dict44 = [[NSDictionary alloc]initWithObjectsAndKeys:strDate,@"date",content,@"content",index, @"index",nil];
        
        [arrayDate addObject:dict44];
    }
    
    
    
    
    tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_phoneInputNameR.frame) + CGRectGetHeight(_phoneInputNameR.frame) + 10, 320.0f, self.view.frame.size.height -CGRectGetMinY(_phoneInputNameR.frame) + CGRectGetHeight(_phoneInputNameR.frame) + 10  ) isNeedUpdate:YES];
    [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tbDataBank11];
    [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
    RELEASE(tbDataBank11);
    [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self creatDownBar];

    [tbDataBank11 reloadData];
    
}

-(void)doAddMessage:(NSNotification *)sender{

    
//initWithObjectsAndKeys:strDate,@"date",content,@"content",index, @"index",nil];
    

    
    
    NSDictionary *dict = [sender object];
    NSString *centent = [[dict objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *date = [self stringFromDate:[NSDate date]];
    NSString *type = @"2";
    NSDictionary *dictt = [[NSDictionary alloc]initWithObjectsAndKeys:centent,@"content",date,@"date",type,@"index", nil];
    [arrayDate addObject:dictt];
    [tbDataBank11 reloadData];
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}



-(void)doChooseTime{
    
    
    
    UIView *viewBG2 = [[UIView alloc]initWithFrame:CGRectMake(0.0F, 0.0f, 320.0f, CGRectGetHeight(self.view.frame))];
    [viewBG2 setBackgroundColor:[UIColor blackColor]];
    [viewBG2 setAlpha:0.7];
    [viewBG2 setTag:102];
    [self.view addSubview:viewBG2];
    RELEASE(viewBG2);
    
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0F, 0.0f, 320.0f, CGRectGetHeight(self.view.frame))];
    [viewBG setBackgroundColor:[UIColor clearColor]];
    [viewBG setTag:101];
    [self.view addSubview:viewBG];
    RELEASE(viewBG);
    
    
    UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake( 20 , CGRectGetHeight(self.view.frame) - 216 - 60, 50, 40)];
    [btnCancel setImage:[UIImage imageNamed:@"top_bt_bg"] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:btnCancel];
    RELEASE(btnCancel);
    [self addlabel_title:@"取消" frame:btnCancel.frame view:btnCancel];
    
    
    
    UIButton *btnMakeSureTime = [[UIButton alloc]initWithFrame:CGRectMake( 240 , CGRectGetHeight(self.view.frame) - 216 - 60, 50, 40)];
    [btnMakeSureTime setTitle:@"确定" forState:UIControlStateNormal];
    [btnMakeSureTime setImage:[UIImage imageNamed:@"top_bt_bg"] forState:UIControlStateNormal];
    [btnMakeSureTime addTarget:self action:@selector(doMakeSureTime) forControlEvents:UIControlEventTouchUpInside];
    [btnMakeSureTime setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:btnMakeSureTime];
    RELEASE(btnMakeSureTime);
    [self addlabel_title:@"确定" frame:btnMakeSureTime.frame view:btnMakeSureTime];

    
    
    datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,CGRectGetHeight(self.view.frame) - 216 ,0.0,0.0)];

    datePicker.datePickerMode  = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    
    NSDate* minDate = [NSDate convertDateFromString:@"1900-01-01 00:00:00 -0500"];
    NSDate* maxDate = [NSDate convertDateFromString:@"2099-01-01 00:00:00 -0500"];
    
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = maxDate;
    
    datePicker.date = [NSDate date];
    
    [viewBG addSubview:datePicker];
    RELEASE(datePicker);
    
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    
//     NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//设置为英文显示
     NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
     datePicker.locale = locale;
     [locale release];

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

-(void)doCancel{

    UIView *view = [self.view viewWithTag:101];
    if ( view ) {
        [view removeFromSuperview];
    }
    
    UIView *view1 = [self.view viewWithTag:102];
    if ( view1 ) {
        [view1 removeFromSuperview];
    }

}


-(void)doMakeSureTime{
    
    NSDate *date = [datePicker date];
    NSString *strDate = [self stringFromDate:date];
    
    DLogInfo(@"date -- %@",strDate);
    [labelTime1 setText:strDate];
    UIView *view = [self.view viewWithTag:101];
    if ( view ) {
        [view removeFromSuperview];
    }
    
    
    UIView *view1 = [self.view viewWithTag:102];
    if ( view1 ) {
        [view1 removeFromSuperview];
    }

    
}


- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    NSString *destDateString = [dateFormatter stringFromDate:date];

    [dateFormatter release];
    
    return destDateString;
    
}

-(void)dateChanged:(UIDatePicker *)sender{


    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;

}

-(void)doMoreAddr{

    ShareBookMoreAddrViewController *moreBook = [[ShareBookMoreAddrViewController alloc]init];
    [self.drNavigationController pushViewController:moreBook animated:YES];
    RELEASE(moreBook);


}

-(void)creatDownBar{

    
    int offset = 0;
    if (!IOS7_OR_LATER) {
        
        offset = 20;
    }
    
    UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
    UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2 - offset, 320.0f, imageBG.size.height/2)];
    [viewBG setUserInteractionEnabled:YES];
//    [viewBG setBackgroundColor:[UIColor redColor]];
    [viewBG setTag:201];
    [viewBG setImage:[UIImage imageNamed:@"down_options_bg"]];
    [self.view addSubview:viewBG];
    RELEASE(viewBG);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 200.0f, 30.0f)];
    [viewBG addSubview:textField];
    RELEASE(textField);
    
    
    
    _phoneInputNameRSend = [[DYBInputView alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 250.0f, 30.0f) placeText:@"输入内容" textType:0];
    [_phoneInputNameRSend.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
    //        [_phoneInputNameR.nameField setText:@"1"];
    [_phoneInputNameRSend.nameField setDelegate:self];
    [_phoneInputNameRSend.nameField setTextColor:[UIColor blackColor]];
    [_phoneInputNameRSend setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:_phoneInputNameRSend];
    RELEASE(_phoneInputNameRSend);
    
    UIImage *image = [UIImage imageNamed:@"send"];
    
    UIButton *btnSend = [[UIButton alloc]initWithFrame:CGRectMake(270, ( imageBG.size.height/2 - image.size.height/2)/2, image.size.width/2, image.size.height/2)];
    [btnSend setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
    [btnSend setBackgroundColor:[UIColor redColor]];
    [viewBG addSubview:btnSend];
    RELEASE(btnSend);

}

-(void)doSend{
    
    if (_mi) {
        NSDictionary *dictTime = [dictRR objectForKey:@"order"];
        NSString *strDate = [dictTime objectForKey:@"from_userid"];
        
        if ([SHARED.userId isEqualToString:strDate]) {
            strDate = [dictTime objectForKey:@"to_userid"];
        }else{
        
        
        }
        
        MagicRequest *request = [DYBHttpMethod message_send_userid:strDate content:_phoneInputNameRSend.nameField.text type:@"2" mid:order_id orderid:order_id sAlert:YES receive:self];
        //    MagicRequest *request = [DYBHttpMethod book_loan_pub_id:[dictInfo objectForKey:@"pub_id"] content:_phoneInputNameRSend.nameField.text loan_time:[self stringFromDate:[NSDate date]] sAlert:YES receive:self];
        [request setTag:1];
    }else{
        MagicRequest *request = [DYBHttpMethod message_send_userid:[dictInfo objectForKey:@"user_id"] content:_phoneInputNameRSend.nameField.text type:@"2" mid:order_id orderid:order_id sAlert:YES receive:self];
//    MagicRequest *request = [DYBHttpMethod book_loan_pub_id:[dictInfo objectForKey:@"pub_id"] content:_phoneInputNameRSend.nameField.text loan_time:[self stringFromDate:[NSDate date]] sAlert:YES receive:self];
    [request setTag:1];
    }
    
    [_phoneInputNameRSend.nameField resignFirstResponder];
}

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
        //        if ([_section intValue] == 0) {
        s = [NSNumber numberWithInteger:arrayDate.count];
        //        }else{
        //            s = [NSNumber numberWithInteger:[_arrStatusData count]];
        //        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:60];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ShareBookApplyCell *cell = [[ShareBookApplyCell alloc]init];
        
        
        [cell creatCell:[arrayDate objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
//        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 60-1, 320.0f, 1)];
//        [imageLine setImage:[UIImage imageNamed:@"line3"]];
//        [cell addSubview:imageLine];
//        [imageLine release];
        
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
       // NSDictionary *dict = (NSDictionary *)[signal object];
      //  NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}



-(void)keyboardWillHide:(NSNotification*)note
{
    UIView *viewBg = [self.view viewWithTag:201];
    UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
    //        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
    [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
    
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
   // static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
   // DLogInfo(@"*********keyboardWillChangeFrame info:%@",info);
   // CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
  
    UIView *viewBg = [self.view viewWithTag:201];
 //   CGRect rect = viewBg.frame;
    
    
    UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
      [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2-kbSize.height, 320.0f, imageBG.size.height/2)];
    /*
    if (self.view.frame.size.height - rect.origin.y < 100) {
        
        rect.size.height = rect.size.height - kbSize.height  - 60 ;
        [viewBg setFrame:rect];
    }else{
        
        UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
//        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
        [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
    
    }*/
    
    
    //自适应代码
}

-(void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal{
    if ([signal isKindOf:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) {
        
//        [scrollView setContentSize:CGSizeMake(320.0f, CGRectGetHeight(self.view.frame))];
        //        [viewBG setCenter:CGPointMake(160, self.view.frame.size.height/2 -30)];
        
    }else if ([signal isKindOf:[MagicUITextField TEXTFIELDDIDENDEDITING]]){
        
        //        [viewBG setCenter:CGPointMake(160, self.view.frame.size.height/2 +10 )];
        
    }else if ([signal isKindOf:[MagicUITextField TEXTFIELDSHOULDRETURN]]){
        
        //        [viewBG setCenter:CGPointMake(160, self.view.bounds.size.height/2 +10 )];
        MagicUITextField *filed = (MagicUITextField *)[signal source];
        [filed resignFirstResponder];
        
        UIView *viewBg = [self.view viewWithTag:201];
       // CGRect rect = viewBg.frame;
        
            UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
            //        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
            [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
      

        
    }
    
    
    
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 1) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    NSString *strDate = [self stringFromDate:[NSDate date]];
                    
                    NSString *content = _phoneInputNameRSend.nameField.text;
                    
                    NSString *index = @"1";
                    
                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:strDate,@"date",content,@"content",index, @"index",nil];
                    
                    [arrayDate addObject:dict];
                    
                    
                    
                    [tbDataBank11 reloadData];
                    [_phoneInputNameRSend.nameField setText:@""];


                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3)
        {
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                int statusCode = [[dict objectForKey:@"response"] intValue];
                if (statusCode == 100) {

                    dictRR = [[NSDictionary alloc]initWithDictionary:[dict objectForKey:@"data"]];
                    order_id = [[NSString alloc]initWithString:[[dictRR objectForKey:@"order"]objectForKey:@"order_id"] ];
                    

                    fromUserID = [[[dictRR objectForKey:@"order"]objectForKey:@"from_userid"] intValue];
                    toUserID = [[[dictRR objectForKey:@"order"]objectForKey:@"to_userid"] intValue];
                    [self setRightNavAccordStatus:[[[dictRR objectForKey:@"order"]objectForKey:@"order_status"] intValue]];
                    
                    [self creatView:dictRR];
                }
                else{
                    NSString    *strOrder = [[[dict objectForKey:@"data"] objectForKey:@"order_id"] description];
                    if (strOrder && [strOrder length])
                    {
                        order_id = [strOrder retain];
                    }
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:2.0f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if (request.tag == 4){
        
            NSDictionary *dict = [request.responseString JSONValue];
            
              int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    
                    
                  [DYBShareinstaceDelegate popViewText:@"提交成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    

                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if(request.tag == 2)
        {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        }else if(request.tag == 100)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    
                NSString    *strOrder = [[[dict objectForKey:@"data"] objectForKey:@"order_id"] description];
                if (strOrder && [strOrder length])
                {
                    order_id = [strOrder retain];
                }
                    [self setRightNavAccordStatus:0];
                    
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if(request.tag == 200)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    [DYBShareinstaceDelegate popViewText:@"提交成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self setRightNavAccordStatus:4];
                    
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if(request.tag == 400)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    [DYBShareinstaceDelegate popViewText:@"提交成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self setRightNavAccordStatus:5];
                    
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if(request.tag == 500)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    [DYBShareinstaceDelegate popViewText:@"提交成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self setRightNavAccordStatus:6];
                    
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
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        
    
        if (order_status == 0)
        {
            MagicRequest *request = [DYBHttpMethod book_loan_order_id:order_id content:_phoneInputNameRSend.nameField.text loan_time:[self stringFromDate:[NSDate date]] address:@"ddd" sAlert:YES receive:self];
            [request setTag:2];
        }else if(order_status == 2)
        {
            MagicRequest *request = [DYBHttpMethod book_order_receiptbook:order_id sAlert:YES receive:self];
            [request setTag:200];
            
        }else if(order_status == 4)
        {
            MagicRequest *request = [DYBHttpMethod book_order_launchbook:order_id sAlert:YES receive:self];
            [request setTag:400];
            
        }else if(order_status == 5)
        {
            MagicRequest *request = [DYBHttpMethod book_order_confirmationbook:order_id sAlert:YES receive:self];
            [request setTag:500];
            
        }
        
      
        

    }
}



-(void)setRightNavAccordStatus:(int)orderStatus
{
    
    order_status = orderStatus;
    DLogInfo(@"orderStatus:%dmyuserID:%@",orderStatus,SHARED.userId);
    if (orderStatus == 1 )
    {
        
        if (toUserID  != [SHARED.userId intValue])
        {
            [self.rightButton setHidden:YES];
            return;
        }
        UIView *tt = [self.headview viewWithTag:100];
        if (!tt) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(220.0f, 20.0f, 100.0f, 44.0f)];
            [view setTag:100];
            [view setBackgroundColor:[UIColor redColor]];
            [self.headview addSubview:view];
            //                RELEASE(view);
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0,  40.0f,44.0f)];
            [btn1 addTarget:self action:@selector(tongyi) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitle:@"同意" forState:UIControlStateNormal];
            [view addSubview:btn1];
            RELEASE(btn1);
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(50.0f, 0.0,  40.0f,44.0f)];
            [btn2 addTarget:self action:@selector(tongyi1) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitle:@"不" forState:UIControlStateNormal];
            [view addSubview:btn2];
            RELEASE(btn2);
            
            
            
            
        }
        
    }else if (orderStatus == 0)
    {
        [self setButtonImage:self.rightButton setImage:@"top_bt_bg" strTitle:@"确认"];
        
    }else if(orderStatus == 2)
    {
        if (fromUserID == [SHARED.userId intValue])
        {
            [self setButtonImage:self.rightButton setImage:@"top_bt_bg" strTitle:@"确认收到书"];
        }else
        {
            [self.rightButton setHidden:YES];
        }
 
    }else if(orderStatus == 4)
    {
        
        if (fromUserID == [SHARED.userId intValue])
        {
            [self setButtonImage:self.rightButton setImage:@"top_bt_bg" strTitle:@"还书"];
        }else
        {
            [self.rightButton setHidden:YES];
        }
    }else if(orderStatus == 5)
    {
        
        if (toUserID == [SHARED.userId intValue])
        {
            [self setButtonImage:self.rightButton setImage:@"top_bt_bg" strTitle:@"确认归还"];
        }else
        {
            [self.rightButton setHidden:YES];
        }
    }else
    {
            [self.rightButton setHidden:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField isEqual:[_phoneInputNameRSend nameField]]) {
        [textField resignFirstResponder];
        
        [self doSend];
    }
    
    return YES;
}

@end
