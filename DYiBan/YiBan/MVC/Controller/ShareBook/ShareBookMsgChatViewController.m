//
//  ShareBookMsgChatViewController
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookMsgChatViewController.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyCell.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookMoreAddrViewController.h"
#import "NSDate+Helpers.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"


@interface ShareBookMsgChatViewController (){

    UILabel *labelTime1;
    DYBInputView *_phoneInputNameRSend;
    
    DYBInputView *_phoneInputNameR;
    BOOL bKeyShow;
    UIDatePicker *datePicker;
    DYBUITableView * tbDataBank11;
    NSMutableArray *arrayDate;
    
    NSDictionary *dictRR;

    
    int      order_status;
    int      fromUserID;
    int      toUserID;
}

@end

@implementation ShareBookMsgChatViewController
@synthesize dictInfo;

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
        [self.headview setTitle:@"对话"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
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
        
        [self requestMessageChatList];
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight+10, 320.0f, self.view.frame.size.height-50-self.headHeight) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        RELEASE(tbDataBank11);
        [self creatDownBar];
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)requestMessageChatList
{
    if ([self.dictInfo objectForKey:@"contact_id"])
    {
       MagicRequest *request = [DYBHttpMethod message_chat_sixin:1 pageNum:2000 type:@"2" userid:[dictInfo valueForKey:@"contact_id"] maxid:@"0" last_id:@"0" isAlert:YES receive:self];
        request.tag = 1;
        
    }
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
    
    NSTimeInterval timeinter = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",timeinter];
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
    
    
    MagicRequest *request = [DYBHttpMethod message_send_userid:[dictInfo objectForKey:@"contact_id"] content:_phoneInputNameRSend.nameField.text type:@"1" mid:@"0" orderid:@"0" sAlert:YES receive:self];
    [request setTag:100];
    
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
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 1)
        {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    if (!arrayDate)
                    {
                        arrayDate = [[NSMutableArray alloc] init];
                    }
                    [arrayDate addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"arr"]];
                    
                    [tbDataBank11 reloadData];

                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 100)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    if (!arrayDate)
                    {
                        arrayDate = [[NSMutableArray alloc] init];
                    }
                    NSString *strDate = [self stringFromDate:[NSDate date]];
                     
                     NSString *content = _phoneInputNameRSend.nameField.text;
                    
                     NSDictionary *dictMessage = [[NSDictionary alloc]initWithObjectsAndKeys:strDate,@"date",content,@"content",SHARED.userId, @"user_id",nil];
                     
                    [arrayDate insertObject:dictMessage atIndex:0];
                    [tbDataBank11 reloadData];
                    [_phoneInputNameRSend.nameField setText:@""];
                    
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField isEqual:[_phoneInputNameRSend nameField]]) {
        [textField resignFirstResponder];
        
        [self doSend];
    }
    
    return YES;
}

-(void)dealloc
{
    RELEASE(arrayDate);
    [super dealloc];
}

@end
