//
//  ShareBookOrderDetailViewController.h
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookOrderDetailViewController.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyCell.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookMoreAddrViewController.h"
#import "NSDate+Helpers.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "ShareBookOrderCommentController.h"
#import "iToast.h"

@interface ShareBookOrderDetailViewController (){
    DYBInputView *_phoneInputNameRSend;
    DYBUITableView * tbDataBank11;
    NSMutableArray *arrayDate;
    NSMutableDictionary *m_dictOrdeDeatil;
    int      order_status;
    int      fromUserID;
    
    
    UILabel  *labelTime1;
    DYBInputView    *_phoneInputNameR;
    UIDatePicker    *datePicker;
}

@end

@implementation ShareBookOrderDetailViewController
@synthesize orderID;
@synthesize dicAddress;

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




-(void)requestOrderDetails
{
    MagicRequest *request = [DYBHttpMethod order_detail_order_id:self.orderID sAlert:YES receive:self];
    [request setTag:3];
    
}
-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"订单详情"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {

        
        if (!arrayDate)
        {
            arrayDate = [[NSMutableArray alloc]init];
        }
       
        [self.view setBackgroundColor:[MagicCommentMethod colorWithHex:@"f0f0f0"]];
        [self requestOrderDetails];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAddMessage:) name:@"GETMESSAGE" object:nil];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        };
        
        
        
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(NSString*)getDateFormatFormTimeinter:(NSString*)time
{
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    return [dateFormat stringFromDate:date];
}


-(UIButton*)getBtnWithName:(NSString*)btnName sel:(SEL)selector frame:(CGRect)rect
{
   
    
    UIButton *btnBorrow = [[UIButton alloc]initWithFrame:rect];
    [btnBorrow setTag:102];
    [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
    [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
    [self addlabel_title:btnName frame:btnBorrow.frame view:btnBorrow textColor:[UIColor whiteColor]];
    [btnBorrow addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return [btnBorrow autorelease];
}


-(BOOL)createBtnForSupView:(UIView*)superView
{
    int orderStatus = [[[m_dictOrdeDeatil objectForKey:@"order"] objectForKey:@"order_status"] intValue];
    order_status = orderStatus;
    if (order_status < 0)
    {
        return NO;
    }

    CGFloat fwidth = superView.frame.size.width;
    switch (orderStatus)
    {
        case 0:
        {
            if (fromUserID == [SHARED.userId intValue])
            {
                UIButton    *btnAggree = [self getBtnWithName:@"确认订单" sel:@selector(makeSureOrder:) frame:CGRectMake(10,10, fwidth-20, 40)];
                [superView addSubview:btnAggree];
           
                
            }else
            {
                return NO;
            }
        }
            break;
        case 1:
        {
            if (fromUserID != [SHARED.userId intValue])
            {
                UIButton    *btnAggree = [self getBtnWithName:@"同意借书" sel:@selector(tongyi:) frame:CGRectMake(10, 10, fwidth/2-20, 40)];
                [superView addSubview:btnAggree];
                
                
                UIButton    *btnRefuse = [self getBtnWithName:@"拒绝" sel:@selector(clickNoAgree:) frame:CGRectMake(fwidth/2+10, 10, fwidth/2-20, 40)];
                [superView addSubview:btnRefuse];
                
                
            }else
            {
                return NO;
            }
            
        
    
        }
            break;
        case 2:
        {
            if (fromUserID == [SHARED.userId intValue])
            {
                UIButton    *btnAggree = [self getBtnWithName:@"确认收到图书" sel:@selector(MakeSureReceiveBook:) frame:CGRectMake(10,10, fwidth-20, 40)];
                [superView addSubview:btnAggree];
        
                
            }else
            {
                return NO;
            }
        }
            break;
        case 4:
        {
            if (fromUserID == [SHARED.userId intValue])
            {
                UIButton    *btnAggree = [self getBtnWithName:@"还书" sel:@selector(returnBook:) frame:CGRectMake(10,10, fwidth-20, 40)];
                [superView addSubview:btnAggree];
         
                
            }else
            {
                return NO;
            }
        }
            break;
        case 5:
        {
            if (fromUserID != [SHARED.userId intValue])
            {
                UIButton    *btnAggree = [self getBtnWithName:@"确认还书" sel:@selector(MakeSureReturn:) frame:CGRectMake(10,10, fwidth-20, 40)];
                [superView addSubview:btnAggree];
          
                
            }else
            {
                return NO;
            }
        }
            break;
        case 6:
        {
            if (fromUserID == [SHARED.userId intValue])
            {
                UIButton    *btnAggree = [self getBtnWithName:@"评价" sel:@selector(commentBook:) frame:CGRectMake(10,10, fwidth-20, 40)];
                [superView addSubview:btnAggree];
             
                
            }else
            {
                return NO;
            }
        }
            break;
        case 7:
        {
            return NO;
            
        }
            break;
            
        default:
            return NO;
            break;
    }

    
    
    return YES;
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




-(void)setAddress:(NSDictionary*)addressInfo
{
    self.dicAddress = addressInfo;
    if (addressInfo)
    {
        [_phoneInputNameR.nameField setText:[addressInfo valueForKey:@"address"]];
    }
}
-(void)doMoreAddr{
    
    ShareBookMoreAddrViewController *moreBook = [[ShareBookMoreAddrViewController alloc]init];
    moreBook.applyController = self;
    [self.drNavigationController pushViewController:moreBook animated:YES];
    RELEASE(moreBook);
    
    
}

-(void)doCancel{
    
    UIView *view = [self.view viewWithTag:TIMEVIEWTAG];
    if ( view ) {
        [view removeFromSuperview];
    }
    
    UIView *view1 = [self.view viewWithTag:TIMEVIEWTAG2];
    if ( view1 ) {
        [view1 removeFromSuperview];
    }
    
}


-(void)doMakeSureTime{
    
    NSDate *date = [datePicker date];
    NSString *strDate =  [self getDateFormatFormTimeinter:[self stringFromDate:date]];
    
    DLogInfo(@"date -- %@",strDate);
    [labelTime1 setText:strDate];
    UIView *view = [self.view viewWithTag:TIMEVIEWTAG];
    if ( view ) {
        [view removeFromSuperview];
    }
    
    
    UIView *view1 = [self.view viewWithTag:TIMEVIEWTAG2];
    if ( view1 ) {
        [view1 removeFromSuperview];
    }
    
}

-(void)dateChanged:(UIDatePicker *)sender
{
    
}
-(void)doChooseTime{
    
    
    
    UIView *viewBG2 = [[UIView alloc]initWithFrame:CGRectMake(0.0F, 0.0f, 320.0f, CGRectGetHeight(self.view.frame))];
    [viewBG2 setBackgroundColor:[UIColor blackColor]];
    [viewBG2 setAlpha:0.7];
    [viewBG2 setTag:TIMEVIEWTAG2];
    [self.view addSubview:viewBG2];
    RELEASE(viewBG2);
    
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0F, 0.0f, 320.0f, CGRectGetHeight(self.view.frame))];
    [viewBG setBackgroundColor:[UIColor clearColor]];
    [viewBG setTag:TIMEVIEWTAG];
    [self.view addSubview:viewBG];
    RELEASE(viewBG);
    
    
    
    
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 216-44, 320, 44)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doMakeSureTime)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    toolBar.items = [NSArray arrayWithObjects:cancel,right,done,nil];
    toolBar.barStyle = UIBarStyleBlack;
    
    
    
    [viewBG addSubview:toolBar];
    [toolBar release];
    [cancel release];
    [right release];
    [done release];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,CGRectGetHeight(self.view.frame) - 216 ,0.0,0.0)];
    
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
-(void)creatApplyView:(NSDictionary *)dict{
    
    
    UIView *view = [self.view viewWithTag:1122];
    [view removeFromSuperview];
    
    
    NSDictionary *dicttt = [[dict objectForKey:@"order"] objectForKey:@"book"];
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height)];
    [viewBG setBackgroundColor:[MagicCommentMethod colorWithHex:@"f0f0f0"]];
    [self.view addSubview:viewBG];
    viewBG.tag = 1122;
    RELEASE(viewBG);
    
    
    UIImage *imageIcon = [UIImage imageNamed:@"defualt_book"];
    UIImageView *imageBook = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f , imageIcon.size.width/2, imageIcon.size.height/2)];
    [imageBook setBackgroundColor:[UIColor clearColor]];
    [imageBook setImage:[UIImage imageNamed:@"defualt_book"]];
    
    if ([[dicttt valueForKey:@"image"] isKindOfClass:[NSString class]])
    {
        [imageBook setImageWithURL:[NSURL URLWithString:[dicttt valueForKey:@"image"]]];
    }
    
    [viewBG addSubview:imageBook];
    [imageBook release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, 5.0f + 0, 200, 20)];
    [labelName setText:[dicttt objectForKey:@"title"]];
    [viewBG addSubview:labelName];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName release];
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelName.frame) + CGRectGetHeight(labelName.frame) + 0, 200, 15)];
    [labelAuther setText:[ NSString stringWithFormat:@"作者：%@",[dicttt objectForKey:@"author"]]];
    [labelAuther setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    
    [labelAuther setFont:[UIFont systemFontOfSize:12]];
    [viewBG addSubview:labelAuther];
    [labelAuther setBackgroundColor:[UIColor clearColor]];
    [labelAuther release];
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelAuther.frame) + CGRectGetHeight(labelAuther.frame) + 0, 200, 15)];
    [labelPublic setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelPublic setText:[NSString stringWithFormat:@"出版社:%@",[dicttt valueForKey:@"publisher"]]];
    [viewBG addSubview:labelPublic];
    [labelPublic setFont:[UIFont systemFontOfSize:12]];
    [labelPublic release];
    
    
    
    UILabel *labelState = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 200, 15)];
    [labelState setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelState setText:[NSString stringWithFormat:@"订单状态:待确认"]];
    [viewBG addSubview:labelState];
    [labelState setBackgroundColor:[UIColor clearColor]];
    [labelState setFont:[UIFont systemFontOfSize:12]];
    [labelState release];
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelState.frame) + CGRectGetHeight(labelState.frame) + 0, 200, 15)];
    [labelTime setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelTime setText:[NSString stringWithFormat:@"借阅时间:"]];
    [viewBG addSubview:labelTime];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    [labelTime setFont:[UIFont systemFontOfSize:12]];
    [labelTime release];
    
    
    
    labelTime1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelTime.frame) + CGRectGetMinX(labelTime.frame) -140, CGRectGetMinY(labelState.frame) + CGRectGetHeight(labelState.frame) -2, 200, 20)];
    [labelTime1 setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelTime1 setText:[self getDateFormatFormTimeinter:[self stringFromDate:[NSDate date]]]];
    [viewBG addSubview:labelTime1];
    [labelTime1 setBackgroundColor:[UIColor clearColor]];
    [labelTime1 setFont:[UIFont systemFontOfSize:12]];
    [labelTime1 release];
    
    UIButton *btnChooseTime = [[UIButton alloc]initWithFrame:CGRectMake(280.0f, CGRectGetMinY(labelState.frame) + CGRectGetHeight(labelState.frame) + self.headHeight, 20.0f, 20.0f)];
    [btnChooseTime setBackgroundColor:[UIColor clearColor]];
    [btnChooseTime setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [btnChooseTime addTarget:self action:@selector(doChooseTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChooseTime];
    RELEASE(btnChooseTime);
    
    NSArray *rr = [dict objectForKey:@"charts"];
    for (int i = 0; i < rr.count; i++) {
        NSDictionary *dictTime = [rr objectAtIndex:i];
        
        NSString *strDate = [dictTime objectForKey:@"time"];
        
        NSString *content = [dictTime objectForKey:@"content"];
        
        NSString *index =   [dictTime objectForKey:@"user_id"];
        
        NSDictionary *dict44 = [[NSDictionary alloc]initWithObjectsAndKeys:strDate,@"time",content,@"content",index, @"user_id",nil];
        [arrayDate addObject:dict44];
        [dict44 release];
    }
    
    
    _phoneInputNameR = [[DYBInputView alloc]initWithFrame:CGRectMake( 5, CGRectGetMinY(labelTime1.frame) + CGRectGetHeight(labelTime1.frame) + 10 , 250, 40) placeText:@"请选择您的地址" textType:0];
    [_phoneInputNameR.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
    [_phoneInputNameR.nameField setDelegate:self];
    [_phoneInputNameR.nameField setTextColor:[UIColor blackColor]];
    [_phoneInputNameR setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:_phoneInputNameR];
    RELEASE(_phoneInputNameR);
    
    
    UIButton *btnMoreAddr = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_phoneInputNameR.frame) + CGRectGetMinX(_phoneInputNameR.frame)+ 5 , CGRectGetMinY(labelTime1.frame) + CGRectGetHeight(labelTime1.frame)+ 15, 55, 30)];
    [btnMoreAddr addTarget:self action:@selector(doMoreAddr) forControlEvents:UIControlEventTouchUpInside];
    
    [btnMoreAddr setImage:[UIImage imageNamed:@"top_bt_bg"] forState:UIControlStateNormal];
    [btnMoreAddr setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:btnMoreAddr];
    RELEASE(btnMoreAddr);
    [self addlabel_title:@"选地址" frame:btnMoreAddr.frame view:btnMoreAddr];
    
    
    UIView  *bgbtnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_phoneInputNameR.frame) + CGRectGetHeight(_phoneInputNameR.frame) + 0, 320, 50)];
    BOOL  bsuc = [self createBtnForSupView:bgbtnView];
    [viewBG addSubview:bgbtnView];
    RELEASE(bgbtnView);
    
    CGFloat  fdelHeight = 50;
    if (!bsuc)
    {
        fdelHeight = 0;
    }
    
    if (!tbDataBank11)
    {
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(bgbtnView.frame) + CGRectGetHeight(bgbtnView.frame) + 10, 320.0f, self.view.frame.size.height -CGRectGetMinY(bgbtnView.frame) + CGRectGetHeight(bgbtnView.frame) -50) isNeedUpdate:YES];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
    }
    
    [tbDataBank11 setFrame:CGRectMake(0, CGRectGetMinY(bgbtnView.frame) + fdelHeight + 10+self.headHeight, 320.0f, self.view.frame.size.height-fdelHeight-100-self.headHeight)];
    [self.view bringSubviewToFront:tbDataBank11];
    
    [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
    
    [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self creatDownBar];
    
    [self resortByTime];
    
}




-(void)creatView:(NSDictionary *)dict{
    
    
    
    UIView *view = [self.view viewWithTag:1122];
    [view removeFromSuperview];
    
    
    NSDictionary *dicttt = [[dict objectForKey:@"order"] objectForKey:@"book"];
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height)];
    [viewBG setBackgroundColor:[MagicCommentMethod colorWithHex:@"f0f0f0"]];
    [self.view addSubview:viewBG];
    viewBG.tag = 1122;
    RELEASE(viewBG);
    
    
    UIImage *imageIcon = [UIImage imageNamed:@"defualt_book"];
    UIImageView *imageBook = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 10.0f , imageIcon.size.width/2, imageIcon.size.height/2)];
    [imageBook setBackgroundColor:[UIColor clearColor]];
    [imageBook setImage:[UIImage imageNamed:@"defualt_book"]];
    
    if ([[dicttt valueForKey:@"image"] isKindOfClass:[NSString class]])
    {
          [imageBook setImageWithURL:[NSURL URLWithString:[dicttt valueForKey:@"image"]]];
    }
 
    [viewBG addSubview:imageBook];
    [imageBook release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, 5.0f + 0, 200, 20)];
    [labelName setText:[dicttt objectForKey:@"title"]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:labelName];
    [labelName release];
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelName.frame) + CGRectGetHeight(labelName.frame) + 0, 200, 15)];
    [labelAuther setText:[ NSString stringWithFormat:@"作者：%@",[dicttt objectForKey:@"author"]]];
    [labelAuther setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelAuther setBackgroundColor:[UIColor clearColor]];
    [labelAuther setFont:[UIFont systemFontOfSize:12]];
    [viewBG addSubview:labelAuther];
    [labelAuther release];
    
    
    UILabel *labelOwner = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelAuther.frame) + CGRectGetHeight(labelAuther.frame) + 0, 200, 15)];
    [labelOwner setText:[ NSString stringWithFormat:@"书主：%@",[dicttt objectForKey:@"username"]]];
    [labelOwner setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelOwner setBackgroundColor:[UIColor clearColor]];
    [labelOwner setFont:[UIFont systemFontOfSize:12]];
    [viewBG addSubview:labelOwner];
    [labelOwner release];
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelOwner.frame) + CGRectGetHeight(labelOwner.frame) + 0, 200, 15)];
    [labelPublic setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelPublic setText:[NSString stringWithFormat:@"出版社:%@",[dicttt valueForKey:@"publisher"]]];
    [viewBG addSubview:labelPublic];
    [labelPublic setBackgroundColor:[UIColor clearColor]];
    [labelPublic setFont:[UIFont systemFontOfSize:12]];
    [labelPublic release];
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 0, 200, 15)];
    [labelTime setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelTime setText:[NSString stringWithFormat:@"借阅时间:%@",[self getDateFormatFormTimeinter:[dicttt objectForKey:@"time"]]]];
    [viewBG addSubview:labelTime];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    [labelTime setFont:[UIFont systemFontOfSize:12]];
    [labelTime release];
    
    NSArray *arrayCir = [dicttt valueForKey:@"circles"];
    NSString   *strAdd = @"";
    if (arrayCir.count)
    {
        strAdd = [arrayCir[0] objectForKey:@"address"];
    }
    UILabel *labelAddress = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelTime.frame) + CGRectGetHeight(labelTime.frame) + 0, 200, 15)];
    [labelAddress setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelAddress setText:[NSString stringWithFormat:@"地址:%@",strAdd]];
    [viewBG addSubview:labelAddress];
    [labelAddress setBackgroundColor:[UIColor clearColor]];
    [labelAddress setFont:[UIFont systemFontOfSize:12]];
    [labelAddress sizeToFit];
    [labelAddress release];
    
    NSArray *rr = [dict objectForKey:@"charts"];
    for (int i = 0; i < rr.count; i++) {
        NSDictionary *dictTime = [rr objectAtIndex:i];
        
        NSString *strDate = [dictTime objectForKey:@"time"];
        
        NSString *content = [dictTime objectForKey:@"content"];
        
        NSString *index =   [dictTime objectForKey:@"user_id"];
        
        NSDictionary *dict44 = [[NSDictionary alloc]initWithObjectsAndKeys:strDate,@"time",content,@"content",index, @"user_id",nil];
        
        [self needAddInfoMsg:dict44];
    }
    
    UIView  *bgbtnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(labelAddress.frame) + CGRectGetHeight(labelAddress.frame) + 0, 320, 50)];
    BOOL  bsuc = [self createBtnForSupView:bgbtnView];
    [viewBG addSubview:bgbtnView];
    RELEASE(bgbtnView);
    
    CGFloat  fdelHeight = 50;
    if (!bsuc)
    {
        fdelHeight = 0;
    }
    
    if (!tbDataBank11)
    {
           tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(bgbtnView.frame) + CGRectGetHeight(bgbtnView.frame) + 10, 320.0f, self.view.frame.size.height -CGRectGetMinY(bgbtnView.frame) + CGRectGetHeight(bgbtnView.frame) -50) isNeedUpdate:YES];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
    }
    
    [tbDataBank11 setFrame:CGRectMake(0, CGRectGetMinY(bgbtnView.frame) + fdelHeight + 10+self.headHeight, 320.0f, self.view.frame.size.height-fdelHeight-100-self.headHeight)];
    [self.view bringSubviewToFront:tbDataBank11];
 
    [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
  
    [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self creatDownBar];

    [self resortByTime];
    
}


-(void)needAddInfoMsg:(NSDictionary*)dicInfo
{
    
    BOOL  add = YES;
    long long time1 = [[dicInfo valueForKey:@"time"] longLongValue];
    for (NSDictionary  *dicTemp in arrayDate)
    {
        if (time1 == [[dicTemp valueForKey:@"time"] longLongValue])
        {
            add = NO;
            break;
        }
    }
    
    if (add)
    {
        [arrayDate addObject:dicInfo];
    }
    
}
-(void)doAddMessage:(NSNotification *)sender{

    
    NSDictionary *dict = [sender object];
    NSString *centent = [[dict objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *date = [self stringFromDate:[NSDate date]];
    NSString *userID = [dict valueForKey:@"ui"];
    NSDictionary *dictt = [[NSDictionary alloc]initWithObjectsAndKeys:centent,@"content",date,@"time",userID,@"user_id", nil];
   // [arrayDate addObject:dictt];
    [self needAddInfoMsg:dictt];
}

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

-(void)resortByTime
{
    [arrayDate sortUsingComparator:^NSComparisonResult(id obj1,id obj2){
        NSString  *strTimeInt1 = [obj1 valueForKey:@"time"];
        NSString  *strTimeInt2 = [obj2 valueForKey:@"time"];
        if ([strTimeInt1 doubleValue] >= [strTimeInt2 doubleValue])
        {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    [tbDataBank11 reloadData];
    
    if (arrayDate.count)
    {
        [tbDataBank11 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrayDate.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSTimeInterval  timerInt = [date timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%0.0f",timerInt];
    
}

-(void)creatDownBar{

    
    int offset = 0;
    if (!IOS7_OR_LATER) {
        
        offset = 0;
    }
    
    UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
    UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2 - offset, 320.0f, imageBG.size.height/2)];
    [viewBG setUserInteractionEnabled:YES];
    [viewBG setTag:201];
    [viewBG setImage:[UIImage imageNamed:@"down_options_bg"]];
    [self.view addSubview:viewBG];
    RELEASE(viewBG);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 200.0f, 30.0f)];
    [viewBG addSubview:textField];
    RELEASE(textField);
    
    
    
    _phoneInputNameRSend = [[DYBInputView alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 250.0f, 30.0f) placeText:@"输入内容" textType:0];
    [_phoneInputNameRSend.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
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

    NSDictionary *dictTime = [m_dictOrdeDeatil objectForKey:@"order"];
    NSString *strUserID = [dictTime objectForKey:@"from_userid"];
    
    if ([SHARED.userId isEqualToString:strUserID]) {
        strUserID = [dictTime objectForKey:@"to_userid"];
    }
    MagicRequest *request = [DYBHttpMethod message_send_userid:strUserID content:_phoneInputNameRSend.nameField.text type:@"2" mid:self.orderID orderid:self.orderID sAlert:YES receive:self];
    [request setTag:1];
    [_phoneInputNameRSend.nameField resignFirstResponder];
}

#pragma mark- 只接受UITableView信号
//static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s;
        s = [NSNumber numberWithInteger:arrayDate.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:80];
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
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
        
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
    [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
    
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
   // static CGFloat normalKeyboardHeight = 216.0f;

    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    UIView *viewBg = [self.view viewWithTag:201];
    UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
      [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2-kbSize.height, 320.0f, imageBG.size.height/2)];
}

-(void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal{
    if ([signal isKindOf:[MagicUITextField TEXTFIELDDIDBEGINEDITING]]) {
        

        
    }else if ([signal isKindOf:[MagicUITextField TEXTFIELDDIDENDEDITING]]){
        

        
    }else if ([signal isKindOf:[MagicUITextField TEXTFIELDSHOULDRETURN]]){

            MagicUITextField *filed = (MagicUITextField *)[signal source];
        
            [filed resignFirstResponder];
            UIView *viewBg = [self.view viewWithTag:201];
        
            UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
            [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
      

        
    }
    
    
    
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
     
            //私信OK
        if (request.tag == 1) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    NSString *strDate = [self stringFromDate:[NSDate date]];
                    
                    NSString *content = _phoneInputNameRSend.nameField.text;
                    NSString *userID = SHARED.userId;
                    
                    NSDictionary *dictTempInfo = [[NSDictionary alloc]initWithObjectsAndKeys:strDate,@"time",content,@"content",userID, @"user_id",nil];
                    [self needAddInfoMsg:dictTempInfo];
                    [self resortByTime];
                    [_phoneInputNameRSend.nameField setText:@""];


                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3)
        {
            //获取到订单详情
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                int statusCode = [[dict objectForKey:@"response"] intValue];
                if (statusCode == 100) {

                    if (m_dictOrdeDeatil == nil)
                    {
                        m_dictOrdeDeatil = [[NSMutableDictionary alloc] init];
                    }
                    [m_dictOrdeDeatil addEntriesFromDictionary:[dict objectForKey:@"data"]];
                    
                    fromUserID = [[[m_dictOrdeDeatil objectForKey:@"order"]objectForKey:@"from_userid"] intValue];
                    
                    if ([[[m_dictOrdeDeatil objectForKey:@"order"] objectForKey:@"order_status"] intValue] == 0)
                    {
                        [self creatApplyView:m_dictOrdeDeatil];
                    }else
                    {
                        [self creatView:m_dictOrdeDeatil];
                    }
                }
                else{
                  
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
                [self requestOrderDetails];
                    

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
                    self.orderID = [strOrder retain];
                }
                    [self requestOrderDetails];
                    
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
                     [self requestOrderDetails];
                    
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
                    [self requestOrderDetails];
                    
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
                       [self requestOrderDetails];
                    
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if(request.tag == 900)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            int statusCode = [[dict objectForKey:@"response"] intValue];
            if (dict) {
                if (statusCode == 100) {
                    [DYBShareinstaceDelegate popViewText:@"确认订单成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self requestOrderDetails];
                    
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


#pragma mark actions
-(void)tongyi:(id)sender
{
    NSString    *order = [[[m_dictOrdeDeatil objectForKey:@"order"] objectForKey:@"order_id"] description];
    MagicRequest *request = [DYBHttpMethod order_confirm_msg_id:order type:@"1" sAlert:YES receive:self];
    [request setTag:4];
}
-(void)clickNoAgree:(id)sender
{
    NSString    *order = [[[m_dictOrdeDeatil objectForKey:@"order"] objectForKey:@"order_id"] description];
    MagicRequest *request = [DYBHttpMethod order_confirm_msg_id:order type:@"2" sAlert:YES receive:self];
    [request setTag:4];
    
}
-(void)MakeSureReceiveBook:(id)sender
{
    MagicRequest *request = [DYBHttpMethod book_order_receiptbook:self.orderID sAlert:YES receive:self];
    [request setTag:200];
    
}
-(void)returnBook:(id)sender
{
    MagicRequest *request = [DYBHttpMethod book_order_launchbook:self.orderID sAlert:YES receive:self];
    [request setTag:400];
    
}
-(void)MakeSureReturn:(id)sender
{
    MagicRequest *request = [DYBHttpMethod book_order_confirmationbook:self.orderID sAlert:YES receive:self];
    [request setTag:500];
    
}
-(void)commentBook:(id)sender
{
    ShareBookOrderCommentController *controller = [[ShareBookOrderCommentController  alloc] init];
    controller.orderID = self.orderID;
    controller.bookOwner = [[[m_dictOrdeDeatil objectForKey:@"order"] objectForKey:@"book"] valueForKey:@"username"];
    controller.bookName = [[[m_dictOrdeDeatil objectForKey:@"order"] objectForKey:@"book"] valueForKey:@"title"];
    [self.drNavigationController pushViewController:controller animated:YES];
    [controller release];
    
}


-(void)makeSureOrder:(id)sender
{
    

    if ([_phoneInputNameR.nameField.text length] < 1)
    {
        iToast  *toast = [[iToast alloc] initWithText:@"请选择您的地址"];
        [toast setGravity:iToastGravityCenter];
        [toast show];
        [toast release];
        return;
    }
    MagicRequest *request = [DYBHttpMethod book_loan_order_id:self.orderID content:_phoneInputNameRSend.nameField.text loan_time:labelTime1.text address:_phoneInputNameR.nameField.text sAlert:YES receive:self];
    [request setTag:900];
}


#pragma mark    UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField isEqual:[_phoneInputNameRSend nameField]]) {
        [textField resignFirstResponder];
        
        [self doSend];
    }
    
    return YES;
}

-(void)dealloc
{
    if (tbDataBank11)
    {
        [tbDataBank11 removeFromSuperview];
    }
    
    RELEASE(m_dictOrdeDeatil);
    if (arrayDate)
    {
        RELEASE(arrayDate);
    }
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
