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

@interface ShareBookListViewController (){


    DYBUITableView * tbDataBank11 ;
    NSMutableArray  *m_dataArray;
    
    BOOL            m_bHasNext;
    int             m_iCurrentPage;
    int             m_ipageNum;
    BOOL            m_bIsLoading;

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
        /*
        ShareBookCommentController  *controller = [[ShareBookCommentController alloc] init];
        controller.pubID = [[dicData valueForKey:@"book"] valueForKey:@"pub_id"];
        [self.drNavigationController pushViewController:controller animated:YES];*/
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

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"图书"];
        if (self.headTitle)
        {
            [self.headview setTitle:self.headTitle];
        }
        
        
        //        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        //        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
//        arraySouce = [[NSMutableArray alloc]initWithObjects:@"上架图书",@"借入图书",@"借出图书",@"旅行中的图书",@"预借中的图书", nil];
        
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
        
        
        
        m_ipageNum = 20;
        m_iCurrentPage = 1;
        [m_dataArray removeAllObjects];
        [self requestOrderList];
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)requestOrderList
{
    m_bIsLoading = YES;
    MagicRequest *request = nil;
    switch (self.type)
    {
        case 0:
            request = [DYBHttpMethod shareBook_user_booklist_user_id:SHARED.userId page:[@(m_iCurrentPage) description] num:[@(m_ipageNum) description] sAlert:YES receive:self];
            break;
        case 1:
            request = [DYBHttpMethod order_list_kind:@"1" page:[@(m_iCurrentPage) description] num:[@(m_ipageNum) description] orderType:@"1" orderStatus:@"0" sAlert:YES receive:self];
            break;
        case 2:
            request = [DYBHttpMethod order_list_kind:@"2" page:[@(m_iCurrentPage) description] num:[@(m_ipageNum) description] orderType:@"1" orderStatus:@"0" sAlert:YES receive:self];
            break;
        case 7:
        case 3:
            self.type = 7;
            request = [DYBHttpMethod order_list_kind:@"2" page:[@(m_iCurrentPage) description] num:[@(m_ipageNum) description] orderType:@"1" orderStatus:@"7" sAlert:YES receive:self];
            break;
            
        default:
            break;
    }
    
    request.tag = self.type+1;
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
        
        NSNumber *s = [NSNumber numberWithInteger:90];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
//        UITableView *tableView = [dict objectForKey:@"tableView"];
        
    
        ShareBookCell *cell = [[ShareBookCell alloc]init];
        cell.tb  = tbDataBank11;
        cell.cellType = ShareBookCellTypeOpearate;
        cell.type = _type;
        cell.indexPath = indexPath;
        [cell creatCell:m_dataArray[indexPath.row]];
        //        NSDictionary *dictInfoFood = nil;
        //        [cell creatCell:dictInfoFood];
        DLogInfo(@"%d", indexPath.section);
        [tbDataBank11.muD_dicfferIndexForCellView setValue:cell forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
//        [tbDataBank11._muA_differHeightCellView addObject:cell];
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
            ShareBookApplyViewController *bookApply = [[ShareBookApplyViewController alloc]init];
            bookApply.orderID = [m_dataArray[indexPath.row] valueForKey:@"order_id"];
            [self.drNavigationController pushViewController:bookApply animated:YES];
            RELEASE(bookApply);
            
        }
  
        

        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        if (tbDataBank11.contentOffset.y+(tbDataBank11.frame.size.height) > tbDataBank11.contentSize.height)
        {
            if (!m_bIsLoading && m_bHasNext)
            {
                [self requestOrderList];
            }
            
        }
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
        if (tbDataBank11.contentOffset.y+(tbDataBank11.frame.size.height) > tbDataBank11.contentSize.height)
        {
            if (!m_bIsLoading && m_bHasNext)
            {
                [self requestOrderList];
            }
            
        }
        
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
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
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        
        //用户图书列表
        if (request.tag == 1) {
            
            
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
            }
        }else if (request.tag == 2)
        {
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
            
        }else if (request.tag == 3)
        {
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
        }else if (request.tag == 8)
        {
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
        }else if (request.tag == 1000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                  [DYBShareinstaceDelegate popViewText:@"确认收到书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
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
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if (request.tag == 3000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [DYBShareinstaceDelegate popViewText:@"评论借书人成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }
        else if (request.tag == 3000)
        {
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [DYBShareinstaceDelegate popViewText:@"还书成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
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
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }

        
    }
}



@end
