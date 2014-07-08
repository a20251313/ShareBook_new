//
//  ShareMYHomeViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareMYHomeViewController.h"
#import "WOSOrderCell.h"
#import "DYBDataBankTopRightCornerView.h"
#import "ShareMessagerCell.h"
#import "ShareDouViewController.h"
#import "ShareBookCenterViewController.h"
#import "ShareBookMyQuanCenterViewController.h"
#import "ShareBookFriendListViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "EGORefreshTableFooterView.h"
#import "ShareBookApplyViewController.h"
#import "ShareBookMsgChatViewController.h"
#import "ShareBookOrderDetailViewController.h"
#define  RIGHTVIEWTAG 111

@interface ShareMYHomeViewController ()<EGORefreshTableDelegate>{

    NSMutableArray *arrayResult;
    DYBUITableView  *tbDataBank1;
    
    
    EGORefreshTableFooterView   *refreshView;
    
    int             m_itagId;
    int             m_iCurrentPage;
    int             m_iPageNum;
    BOOL            m_bHasNext;
    BOOL            m_bIsLoading;
}

@end

@implementation ShareMYHomeViewController

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
    [self initRefrshView];
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
        [self.headview setTitle:@"消息"];
        
//        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.leftButton setHidden:YES];
        [self setButtonImage:self.rightButton setImage:@"menu"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
       [self.headview setBackgroundColor:[UIColor colorWithRed:17.0f/255 green:22.0f/255 blue:27.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
//        arrayFoodList = [[NSArray alloc]init];
//        arrayAddorder = [[NSMutableArray alloc]init];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        arrayResult = [[NSMutableArray alloc]init];
        //MagicRequest *request = [DYBHttpMethod message_list_page:@"0" num:@"10000" sAlert:YES receive:self];
        
        m_iPageNum = 20;
        m_iCurrentPage = 1;
        m_bIsLoading = NO;
        m_bHasNext = NO;
        
        MagicRequest *request = [DYBHttpMethod message_contractslist:SHARED.userId page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] sAlert:YES receive:self];
        [request setTag:1];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
    //    UIImage *image = [UIImage imageNamed:@"menu_inactive"];
        
        
       tbDataBank1 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight, 320.0f , self.view.frame.size.height - self.headHeight  ) isNeedUpdate:YES];
        [tbDataBank1 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank1];
        [tbDataBank1 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank1);
  
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

#pragma mark- 只接受UITableView信号
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
        //        if ([_section intValue] == 0) {
        s = [NSNumber numberWithInteger:arrayResult.count];
        //        }else{
        //            s = [NSNumber numberWithInteger:[_arrStatusData count]];
        //        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:50];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ShareMessagerCell *cell = [[ShareMessagerCell alloc]init];
        DLogInfo(@"%d", indexPath.section);
        [cell creatCell:[arrayResult objectAtIndex:indexPath.row]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        DLogInfo(@"TABLEDIDSELECT:%@ \n\n",arrayResult[indexPath.row]);
      
        NSDictionary    *dicData = arrayResult[indexPath.row];
        int kind = [[dicData valueForKey:@"kind"] intValue];
        if (kind == 1)
        {
            ShareBookMsgChatViewController *contrller = [[ShareBookMsgChatViewController alloc] init];
            contrller.dictInfo = dicData;
            [self.drNavigationController pushViewController:contrller animated:YES];
            [contrller release];
        }else if (kind == 2)
        {
            ShareBookOrderDetailViewController *apple = [[ShareBookOrderDetailViewController alloc]init];
            
            NSString    *orderId = [arrayResult[indexPath.row] objectForKey:@"order_id"];
            apple.orderID = orderId;
            [self.drNavigationController pushViewController:apple animated:YES];
            
        }else if (kind == 3)
        {
            ShareDouViewController *dou = [[ShareDouViewController alloc]init];
            [self.drNavigationController pushViewController:dou animated:YES];
            RELEASE(dou);
            
        }
      
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
        if (refreshView)
        {
            [refreshView egoRefreshScrollViewDidScroll:tbDataBank1];
        }
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]]){
        if (![self needNoteRefreshView])
        {
            
            [refreshView egoRefreshScrollViewDataSourceAllDataIsFinished:tbDataBank1];
            return;
        }
        
        if (refreshView)
        {
            [refreshView egoRefreshScrollViewDidEndDragging:tbDataBank1];
        }
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        
        UIView *viewR = [self.view viewWithTag:RIGHTVIEWTAG];
        if (!viewR) {
            
            NSArray *arrayType = [[NSArray alloc]initWithObjects:@"消息",@"图书",@"豆",@"圈",@"好友", nil];
            DYBDataBankTopRightCornerView *rightV = [[DYBDataBankTopRightCornerView alloc]initWithFrame:CGRectMake(320.0f - 95, self.headHeight, 90, 99) arrayResult:arrayType target:self];
            [rightV setBackgroundColor:[UIColor clearColor]];
            [rightV setTag:RIGHTVIEWTAG];
            [self.view addSubview:rightV];
            RELEASE(rightV);
            RELEASE(arrayType);
            
        }else{
        
            viewR.hidden == YES ? [viewR setHidden:NO] : [viewR setHidden:YES];
        
        }
        
    }
}


- (void)handleViewSignal_DYBDataBankTopRightCornerView:(MagicViewSignal *)signal
{

    if ([signal is:[DYBDataBankTopRightCornerView TOUCHSINGLEBTN]]) {
        
        UIView *viewR = [self.view viewWithTag:RIGHTVIEWTAG];
        if (viewR) {
            [viewR setHidden:YES];
        }
        NSNumber *num = (NSNumber *)[signal object];
        
        switch ([num integerValue]) {
            case 1:
                
                break;
            case 2:{
                ShareBookCenterViewController *center = [[ShareBookCenterViewController alloc]init];
                [self.drNavigationController pushViewController:center animated:YES];
                [center release];
            
            }
                
                break;
            case 3:
            {
                ShareDouViewController *dou = [[ShareDouViewController alloc]init];
                [self.drNavigationController pushViewController:dou animated:YES];
                RELEASE(dou);
            }
                break;
            case 4:
            {
                ShareBookMyQuanCenterViewController *quan = [[ShareBookMyQuanCenterViewController alloc]init];
                [self.drNavigationController pushViewController:quan animated:YES];
                RELEASE(quan);
            
            }
                break;
            case 5:
            {
                ShareBookFriendListViewController *quan = [[ShareBookFriendListViewController alloc]init];
                [self.drNavigationController pushViewController:quan animated:YES];
                RELEASE(quan);
                
            }
                break;
            default:
                break;
        }
        
//        ShareDouViewController
        
    }


}
#pragma mark- 只接受HTTP信号
//- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
//{
//    if ([request succeed])
//    {
//       
//    }
//}



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
            
                    [arrayResult addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"arr"]];
                     m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] boolValue];
                    [tbDataBank1 reloadData];
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                }
            }
               [self finishReloadingData];
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                   
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



#pragma mark
-(void)setNoDataViewHide:(BOOL)isHide
{
    UILabel *label = (UILabel*)[self.view viewWithTag:10001];
    
    if (!label && !isHide)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-40)/2, self.view.frame.size.width, 40)];
        [label setTag:10001];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:20]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [self.view addSubview:label];
    }
    label.hidden = isHide;
    
    
    [label setText:@"消息为空"];
    
    
    
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
        [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tbDataBank1];
        
    }
    [self setFooterView];
    // [self removeFooterView];
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}



-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(tbDataBank1.contentSize.height, tbDataBank1.frame.size.height);
    if (refreshView && [refreshView superview])
	{
        // reset position
        refreshView.frame = CGRectMake(0.0f,height,tbDataBank1.frame.size.width,
                                       self.view.bounds.size.height);
    }else
	{
        // create the footerView
        refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:  CGRectMake(0.0f, height,tbDataBank1.frame.size.width, tbDataBank1.bounds.size.height) arrowImageName:nil textColor:[UIColor grayColor]
                       ];
        refreshView.delegate = self;
        [tbDataBank1 addSubview:refreshView];
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
            m_iCurrentPage++;
            
            
            MagicRequest *request = [DYBHttpMethod message_contractslist:SHARED.userId page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] sAlert:YES receive:self];
            [request setTag:1];

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
