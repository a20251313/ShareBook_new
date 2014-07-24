//
//  ShareBookListViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookListViewController.h"
#import "ShareBookCell.h"
#import "ShareBookDetailViewController.h"
#import "UITableView+property.h"
#import "JSONKit.h"
#import "JSON.h"
#import "ShareBookCellBtnCenterView.h"
#import "ShareBookApplyViewController.h"
#import "ShareBookCommentController.h"
#import "ShareBookOrderCommentController.h"
#import "DYBTwoDimensionCodeViewController.h"
#import "ShareBookOrderDetailViewController.h"
#import "DYBDataBankTopRightCornerView.h"
#import "PublicUtl.h"
#import "EGORefreshTableFooterView.h"


#define  RIGHTMENUVIEWTAG 3265523
@interface ShareBookListViewController ()<EGORefreshTableDelegate>{


    DYBUITableView * tbDataBank11 ;
    NSMutableArray  *m_dataArray;
    
    EGORefreshTableFooterView   *refreshView;
    int             m_iCurrentPage;
    int             m_iPageNum;
    BOOL            m_bHasNext;
    BOOL            m_bIsLoading;
    int             m_iOrderStatus;     //图书状态
    

}

@end

@implementation ShareBookListViewController
@synthesize  type = _type;
@synthesize headTitle;

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




- (void)handleViewSignal_DYBDataBankTopRightCornerView:(MagicViewSignal *)signal
{
    
    if ([signal is:[DYBDataBankTopRightCornerView TOUCHSINGLEBTN]]) {
        
        UIView *viewR = [self.view viewWithTag:RIGHTMENUVIEWTAG];
        if (viewR) {
            [viewR setHidden:YES];
        }
        NSNumber *num = (NSNumber *)[signal object];
        if (m_iOrderStatus == [num intValue]-1)
        {
            return;
        }
        

        m_iOrderStatus = [num intValue]-1;
        self.headTitle = [PublicUtl getStatusStringByStatus:m_iOrderStatus];
        m_iCurrentPage = 1;
        m_iPageNum = 25;
        m_bHasNext = NO;
        [m_dataArray removeAllObjects];
        [self requestOrderList];
        
        //        ShareDouViewController
        
    }
    
    
}




-(NSDictionary*)getDataFromsignal:(MagicViewSignal*)signal
{
    if (!signal)
    {
        return nil;
    }
    
    if ([[signal source] isKindOfClass:[UIView class]])
    {
        UIView  *subView = [signal source];
        while (subView.superview)
        {
            if ([subView.superview isKindOfClass:[ShareBookCell class]])
            {
                ShareBookCell   *cell = (ShareBookCell*)subView.superview;
                return cell.dicData;
            }else
            {
                subView = subView.superview;
            }
            
        }
    }
    
    return nil;
}



- (void)handleViewSignal:(MagicViewSignal *)signal
{
    NSDictionary    *dicData = [self getDataFromsignal:signal];
    
    DLogInfo(@"%@ handleViewSignal:signal signal object:%@//%@",[signal object],signal,dicData);
    
    if ([signal is:[ShareBookCellBtnCenterView CLICKREUPLOAD]])
    {
        DYBTwoDimensionCodeViewController *scan = [[DYBTwoDimensionCodeViewController alloc]init];
        [self.drNavigationController pushViewController:scan animated:YES];
        [scan release];
      
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKBORROWHIS]])
    {
        ShareBookListViewController *controller = [[ShareBookListViewController alloc] init];
        controller.type = ShareBookListTypeJieYueHis;
        [self.drNavigationController pushViewController:controller animated:YES];
        RELEASE(controller);
        
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKDROP]])
    {
        
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKEVULUATEBOOK]])
    {
      
        ShareBookOrderCommentController *controller = [[ShareBookOrderCommentController  alloc] init];
        controller.orderID = [dicData valueForKey:@"order_id"];
        controller.bookOwner = [[dicData valueForKey:@"book"] valueForKey:@"username"];
        controller.bookName = [[dicData valueForKey:@"book"] valueForKey:@"book_name"];
        [self.drNavigationController pushViewController:controller animated:YES];
        [controller release];

    }else if ([signal is:[ShareBookCellBtnCenterView CLICKEVULUATEBROWWER]])
    {
        
        ShareBookOrderCommentController *controller = [[ShareBookOrderCommentController  alloc] init];
        controller.orderID = [dicData valueForKey:@"order_id"];
        [self.drNavigationController pushViewController:controller animated:YES];
        
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKMAKESURERETURN]])
    {
        MagicRequest    *request = [DYBHttpMethod book_order_confirmationbook:[dicData valueForKey:@"order_id"] sAlert:YES receive:self];
        request.tag = 4000;
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKNOTICERETURN]])
    {
       /* int status = [[dicData valueForKey:@"order_status"] intValue];
        if (status ) {
            <#statements#>
        }*/
        NSString    *userID = [dicData valueForKey:@"from_userid"];
        NSString    *orderID = [dicData valueForKey:@"order_id"];
        MagicRequest *request = [DYBHttpMethod message_send_userid:userID content:@"该还书了吧" type:@"2" mid:@"0" orderid:orderID sAlert:YES receive:self];
        [request setTag:6000];
        
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKRETURNBOOK]])
    {
        
        //order_launchbook
        int orderstatus = [[dicData valueForKey:@"order_status"] intValue];
        if(orderstatus == 4)
        {
            MagicRequest    *request = [DYBHttpMethod book_order_launchbook:[dicData objectForKey:@"order_id"] sAlert:YES receive:self];
            request.tag = 5000;
        }else
        {
              [DYBShareinstaceDelegate popViewText:@"当前订单不存在或者不能够执行此操作！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
        }
  
        
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKMAKERECEIVE]])
    {
        
        //order_launchbook
        int orderstatus = [[dicData valueForKey:@"order_status"] intValue];
        if (orderstatus == 2)
        {
            MagicRequest    *request = [DYBHttpMethod book_order_receiptbook:[dicData objectForKey:@"order_id"] sAlert:YES receive:self];
            request.tag = 1000;
            
        }else
        {
            [DYBShareinstaceDelegate popViewText:@"当前订单不存在或者不能够执行此操作！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
        }
        
        
    }else if ([signal is:[ShareBookCellBtnCenterView CLICKSHARE]])
    {
        
    }
}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        
    
        UIView *viewR = [self.view viewWithTag:RIGHTMENUVIEWTAG];
        if (!viewR) {
            
            
            NSMutableArray  *arrayTitle = [NSMutableArray array];
            for (int i = 0; i < 7; i++)
            {
                [arrayTitle addObject:[PublicUtl getStatusStringByStatus:i]];
            }
            DYBDataBankTopRightCornerView *rightV = [[DYBDataBankTopRightCornerView alloc]initWithFrame:CGRectMake(320.0f - 140, self.headHeight, 135, 20*arrayTitle.count) arrayResult:arrayTitle target:self];
            [rightV setBackgroundColor:[UIColor clearColor]];
            [rightV setTag:RIGHTMENUVIEWTAG];
            [self.view addSubview:rightV];
            RELEASE(rightV);

            
        }else{
            
            viewR.hidden == YES ? [viewR setHidden:NO] : [viewR setHidden:YES];
            
        }
        
    }
}


-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {

        [self.headview setTitle:@"图书"];
        if (self.headTitle)
        {
            [self.headview setTitle:self.headTitle];
        }
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        
        if (self.type != 0)
        {
         [self setButtonImage:self.rightButton setImage:@"menu"];
        }
       
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
     
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        if (self.type == 0)
        {
            [self.rightButton setHidden:YES];
        }
      
         m_iOrderStatus = -10;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, self.view.frame.size.height)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        
         tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight , 320.0f, self.view.frame.size.height - self.headHeight  ) ];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        
        RELEASEDICTARRAYOBJ(tbDataBank11._muA_differHeightCellView)
        tbDataBank11._muA_differHeightCellView = [[NSMutableArray alloc]init];
        
        tbDataBank11.muD_dicfferIndexForCellView = [[NSMutableDictionary alloc]init];

        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
        
        if (!m_dataArray)
        {
            m_dataArray = [[NSMutableArray alloc] init];
        }
        
        
        
        m_iPageNum = 25;
        m_iCurrentPage = 1;
        [m_dataArray removeAllObjects];
 
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        m_iCurrentPage = 1;
        [m_dataArray removeAllObjects];
        [self requestOrderList];
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
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

-(void)makeSureOrder:(UIButton*)sender
{
    ShareBookApplyViewController    *apply = [[ShareBookApplyViewController alloc] init];
    NSDictionary    *dicInfo = m_dataArray[sender.tag];
    apply.orderID = [dicInfo valueForKey:@"order_id"];
    [self.drNavigationController pushViewController:apply animated:YES];
    [apply release];
    
}
-(void)makeSureOwnerAction:(UIButton*)sender
{
    ShareBookOrderDetailViewController    *details = [[ShareBookOrderDetailViewController alloc] init];
    NSDictionary    *dicInfo = m_dataArray[sender.tag];
    details.orderID = [dicInfo valueForKey:@"order_id"];
    [self.drNavigationController pushViewController:details animated:YES];
    [details release];
    
}
-(void)makeSureReceiveBook:(UIButton*)sender
{
    NSDictionary  *dicData = m_dataArray[sender.tag];
    MagicRequest    *request = [DYBHttpMethod book_order_receiptbook:[dicData objectForKey:@"order_id"] sAlert:YES receive:self];
    request.tag = 1000;
    
}
-(void)returnBook:(UIButton*)sender
{
     NSDictionary  *dicData = m_dataArray[sender.tag];
    MagicRequest    *request = [DYBHttpMethod book_order_launchbook:[dicData objectForKey:@"order_id"] sAlert:YES receive:self];
    request.tag = 5000;
    
}
-(void)makeSurereturnBook:(UIButton*)sender
{
     NSDictionary  *dicData = m_dataArray[sender.tag];
    MagicRequest    *request = [DYBHttpMethod book_order_confirmationbook:[dicData valueForKey:@"order_id"] sAlert:YES receive:self];
    request.tag = 4000;
    
}

-(void)soldOut:(UIButton*)sender
{
    NSDictionary  *dicData = m_dataArray[sender.tag];
    MagicRequest    *request = [DYBHttpMethod book_shelf:[dicData valueForKey:@"pub_id"] sAlert:YES receive:self];
    request.tag = 9000;
    
}
-(void)commentBooK:(UIButton*)sender
{
    
    ShareBookOrderCommentController *controller = [[ShareBookOrderCommentController  alloc] init];
    NSDictionary  *dicData = m_dataArray[sender.tag];
    controller.orderID = [dicData valueForKey:@"order_id"];
    controller.bookOwner = [[dicData valueForKey:@"book"] valueForKey:@"username"];
    controller.bookName = [[dicData valueForKey:@"book"] valueForKey:@"book_name"];
    [self.drNavigationController pushViewController:controller animated:YES];
    [controller release];
    
}


-(UIButton*)getBtnWithFrame:(CGRect)frame status:(NSString*)status fromuserID:(NSString*)fromeUserID
{
  
    NSString    *strTitle = nil;
    SEL sel = nil;
    switch ([status intValue])
    {
        case 0:
            if ([fromeUserID isEqualToString:SHARED.userId])
            {
                sel = @selector(makeSureOrder:);
                strTitle = @"确认订单";
            }
          
            break;
        case 1:
            if (![fromeUserID isEqualToString:SHARED.userId])
            {
                sel = @selector(makeSureOwnerAction:);
                strTitle = @"处理申请";
            }
            break;
        case 2:
            
            if ([fromeUserID isEqualToString:SHARED.userId])
            {
                sel = @selector(makeSureReceiveBook:);
                strTitle = @"确认收到书";
            }
          
            break;
        case 3:
            break;
        case 4:
            if ([fromeUserID isEqualToString:SHARED.userId])
            {
                
                sel = @selector(returnBook:);
                strTitle = @"还书";
            }
            break;
        case 5:
            if (![fromeUserID isEqualToString:SHARED.userId])
            {
                sel = @selector(makeSurereturnBook:);
                strTitle = @"确认还书";
            }
            break;
        case 6:
            if ([fromeUserID isEqualToString:SHARED.userId])
            {
                
                sel = @selector(commentBooK:);
                strTitle = @"评论";
            }
            break;
        case 7:
            break;
            
        default:
            sel = @selector(soldOut:);
            strTitle = @"下架";
            break;
    }
    
    if (sel == nil)
    {
        return nil;
    }
    UIButton *btnBorrow = [[UIButton alloc]initWithFrame:frame];
    [btnBorrow setTag:102];
    [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
    [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
    [btnBorrow addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addlabel_title:strTitle frame:btnBorrow.frame view:btnBorrow textColor:[UIColor whiteColor]];
    
    return [btnBorrow autorelease];
}

-(void)requestOrderList
{
    
    
    m_bIsLoading = YES;
    MagicRequest *request = nil;
    if (m_iOrderStatus < 0)
    {
        if (m_iCurrentPage < 2)
        {
            [PublicUtl addHUDviewinView:self.view];
        }
        switch (self.type)
        {
            case 0:
                request = [DYBHttpMethod shareBook_user_booklist_user_id:SHARED.userId page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] sAlert:YES receive:self];
                break;
            case 1:
                request = [DYBHttpMethod order_list_kind:@"1" page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] orderType:@"1" orderStatus:nil sAlert:YES receive:self];
                break;
            case 2:
                request = [DYBHttpMethod order_list_kind:@"2" page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] orderType:@"1" orderStatus:nil sAlert:YES receive:self];
                break;
            case 7:
            case 3:
                self.type = 7;
                request = [DYBHttpMethod order_list_kind:nil page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] orderType:@"1" orderStatus:@"7" sAlert:YES receive:self];
                break;
                
            default:
                break;
        }
        
        request.tag = self.type+1;
        
        
    }else
    {
        
        if (m_iCurrentPage < 2)
        {
            [PublicUtl addHUDviewinView:self.view];
        }
  
         request = [DYBHttpMethod order_list_kind:nil page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] orderType:@"1" orderStatus:[@(m_iOrderStatus) description] sAlert:YES receive:self];
        request.tag = 40;
    }

}

#pragma mark- 只接受UITableView信号
//static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
        //        if ([_section intValue] == 0) {
        s = [NSNumber numberWithInteger:m_dataArray.count];
        //        }else{
        //            s = [NSNumber numberWithInteger:[_arrStatusData count]];
        //        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:[ShareBookCell ShareBookCellHeight]];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
//        UITableView *tableView = [dict objectForKey:@"tableView"];
        
    
        NSDictionary    *dicdata = m_dataArray[indexPath.row];
        ShareBookCell *cell = [tbDataBank11 dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell = [[ShareBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }else
        {
            for (UIButton *btn in cell.subviews)
            {
                if ([btn isKindOfClass:[UIButton class]])
                {
                    [btn removeFromSuperview];
                }
            }
        }
        cell.tb  = tbDataBank11;
        
        if (self.type != 0)
        {
              cell.cellType = ShareBookCellTypeOpearate;
       
        }else
        {
              cell.cellType = ShareBookCellTypeDefault;
        }
      
        cell.type = _type;
        cell.indexPath = indexPath;
        [cell creatCell:m_dataArray[indexPath.row]];
        
        if (self.type != 0)
        {
            UIButton   *btnOper = [self getBtnWithFrame:CGRectMake(215, 40, 100, 30) status:[dicdata objectForKey:@"order_status"] fromuserID:[dicdata valueForKey:@"from_userid"]];
            if (btnOper)
            {
                [cell addSubview:btnOper];
                btnOper.tag = indexPath.row;
            }
        }else
        {
            UIButton   *btnOper = [self getBtnWithFrame:CGRectMake(215, 40, 100, 30) status:@"100" fromuserID:@"11"];
            if (btnOper)
            {
                [cell addSubview:btnOper];
                btnOper.tag = indexPath.row;
            }
            
        }
        DLogInfo(@"%d", indexPath.section);
        [tbDataBank11.muD_dicfferIndexForCellView setValue:cell forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        cell.indexPath = indexPath;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/
    {
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        if (_type == 0)
        {
            ShareBookDetailViewController *bookDetail = [[ShareBookDetailViewController alloc]init];
            bookDetail.dictInfo = m_dataArray[indexPath.row];
            [self.drNavigationController pushViewController:bookDetail animated:YES];
            RELEASE(bookDetail);
            
        }else
        {
            
            
            NSDictionary    *dicOrder = m_dataArray[indexPath.row];
            if ([[dicOrder valueForKey:@"order_status"] intValue] == 0)
            {
                ShareBookApplyViewController *bookApply = [[ShareBookApplyViewController alloc]init];
                bookApply.orderID = [m_dataArray[indexPath.row] valueForKey:@"order_id"];
                [self.drNavigationController pushViewController:bookApply animated:YES];
                RELEASE(bookApply);
                
            }else
            {
                ShareBookOrderDetailViewController *bookDetail = [[ShareBookOrderDetailViewController alloc]init];
                bookDetail.orderID = [m_dataArray[indexPath.row] valueForKey:@"order_id"];
                [self.drNavigationController pushViewController:bookDetail animated:YES];
                RELEASE(bookDetail);
            }
            
        }
  
        

        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
        if (refreshView)
        {
            [refreshView egoRefreshScrollViewDidScroll:tbDataBank11];
        }
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]]){
        if (![self needNoteRefreshView])
        {
            
            [refreshView egoRefreshScrollViewDataSourceAllDataIsFinished:tbDataBank11];
            return;
        }
        
        if (refreshView)
        {
            [refreshView egoRefreshScrollViewDidEndDragging:tbDataBank11];
        }
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}

-(void)refreshData
{
    [PublicUtl addHUDviewinView:self.view];
    m_iCurrentPage = 0;
    [m_dataArray removeAllObjects];
    [self requestOrderList];
}

/*if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT  && !_loading) {

if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
    [_delegate egoRefreshTableDidTriggerRefresh:EGORefreshFooter];
}

[self setState:EGOOPullRefreshLoading];
[UIView beginAnimations:nil context:NULL];
[UIView setAnimationDuration:0.2];
scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
[UIView commitAnimations];

}*/

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
     [PublicUtl hideHUDViewInView:self.view];
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        
        //用户图书列表
        if (request.tag == 1) {
            
            
            [PublicUtl hideHUDViewInView:self.view];
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    //                    NSDictionary *dict1 = [[dict objectForKey:@"data"]objectForKey:@"book_list"];
                    
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] intValue];
                    m_bIsLoading = NO;
                    if (m_bHasNext)
                    {
                        m_iCurrentPage++;
                    }
                    [m_dataArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"] objectForKey:@"book_list"]]];
                   
                    [tbDataBank11 reloadData];
                    
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
                [self finishReloadingData];
            }
        }else if (request.tag == 2)
        {
            [PublicUtl hideHUDViewInView:self.view];
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    //                    NSDictionary *dict1 = [[dict objectForKey:@"data"]objectForKey:@"book_list"];
                    
                    
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] intValue];
                    m_bIsLoading = NO;
                    if (m_bHasNext)
                    {
                        m_iCurrentPage++;
                    }
                    [m_dataArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"]objectForKey:@"order_list"]]];
                    
                    [tbDataBank11 reloadData];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
                [self finishReloadingData];
            }
            
        }else if (request.tag == 3)
        {
            [PublicUtl hideHUDViewInView:self.view];
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    //                    NSDictionary *dict1 = [[dict objectForKey:@"data"]objectForKey:@"book_list"];
                    
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] intValue];
                    m_bIsLoading = NO;
                    if (m_bHasNext)
                    {
                        m_iCurrentPage++;
                    }
                    [m_dataArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"]objectForKey:@"order_list"]]];
                    
                    [tbDataBank11 reloadData];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            [self finishReloadingData];
        }else if (request.tag == 8)
        {
            [PublicUtl hideHUDViewInView:self.view];
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    //                    NSDictionary *dict1 = [[dict objectForKey:@"data"]objectForKey:@"book_list"];
                    
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] intValue];
                    m_bIsLoading = NO;
                    if (m_bHasNext)
                    {
                        m_iCurrentPage++;
                    }
                    [m_dataArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"]objectForKey:@"order_list"]]];
                    
                    [tbDataBank11 reloadData];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
               [self finishReloadingData];
        }else if (request.tag == 1000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                  [DYBShareinstaceDelegate popViewText:@"确认收到书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 4000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [DYBShareinstaceDelegate popViewText:@"确认归还图书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 2000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                          [DYBShareinstaceDelegate popViewText:@"评论成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                     [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else  if (request.tag == 3000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [DYBShareinstaceDelegate popViewText:@"还书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 6000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [DYBShareinstaceDelegate popViewText:@"提醒还书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 5000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [DYBShareinstaceDelegate popViewText:@"还书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 40)
        {
            [PublicUtl hideHUDViewInView:self.view];
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    
                    //                    NSDictionary *dict1 = [[dict objectForKey:@"data"]objectForKey:@"book_list"];
                    
                    
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] intValue];
                    m_bIsLoading = NO;
                    if (m_bHasNext)
                    {
                        m_iCurrentPage++;
                    }
                    [m_dataArray addObjectsFromArray:[[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"]objectForKey:@"order_list"]]];
                    
                    [tbDataBank11 reloadData];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
            
               [self finishReloadingData];
            
        }else if (request.tag == 9000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"])
                {
                    [PublicUtl showText:@"图书下架成功" Gravity:iToastGravityBottom];
                    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5f];
                }else
                {
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }

        
    }
}



/**
 *  init refreshView
 */
-(void)initRefrshView
{
    [self setFooterView];
}

- (void)finishReloadingData{
	
	//  model should call this when its done loading
	m_bIsLoading = NO;
    
    if (refreshView) {
        [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tbDataBank11];
        
    }
    [self setFooterView];
    // [self removeFooterView];
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}



-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(tbDataBank11.contentSize.height, tbDataBank11.frame.size.height);
    if (refreshView && [refreshView superview])
	{
        // reset position
        refreshView.frame = CGRectMake(0.0f,height,tbDataBank11.frame.size.width,
                                       self.view.bounds.size.height);
    }else
	{
        // create the footerView
        refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:  CGRectMake(0.0f, height,tbDataBank11.frame.size.width, tbDataBank11.bounds.size.height) arrowImageName:nil textColor:[UIColor grayColor]
                       ];
        refreshView.delegate = self;
        [tbDataBank11 addSubview:refreshView];
    }
    if (refreshView)
	{
        [refreshView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (refreshView && [refreshView superview])
	{
        [refreshView removeFromSuperview];
    }
    
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
#pragma mark UIScrollViewDelegate Methods


-(BOOL)needNoteRefreshView
{
    return m_bHasNext;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
/**
 * egoRefreshTableDidTriggerRefresh
 *
 *  @param aRefreshPos pos
 */
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (m_bHasNext && !m_bIsLoading)
        {
            m_bIsLoading = YES;
            [self requestOrderList];
            
            //[request setTag:2];
        }
        
    });
    
}
/**
 *  ego status return
 *
 *  @param view scrollView
 *
 *  @return status
 */
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return m_bIsLoading;
}


- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
