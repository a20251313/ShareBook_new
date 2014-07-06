//
//  ShareBookBankViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookBankViewController.h"
#import "WOSOrderCell.h"
#import "ShareBookCell.h"
#import "ShareBookDetailViewController.h"
#import "ShareBookSearchResultViewController.h"
#import "EGORefreshTableFooterView.h"

#import "JSONKit.h"
#import "JSON.h"


@implementation searchDataModel


-(void)dealloc
{
    self.keyword = nil;
    self.kind = nil;
    self.loanstatus = nil;
    self.tagid = nil;
    self.cirleID = nil;
    self.loanway = nil;
    [super dealloc];
}

@end
@interface ShareBookSearchResultViewController ()<EGORefreshTableDelegate>{
    

    DYBUITableView * tbDataBank11;
    NSMutableArray *arrayReturnSouce;
    EGORefreshTableFooterView   *refreshView;
    
    int             m_itagId;
    int             m_iCurrentPage;
    int             m_iPageNum;
    BOOL            m_bHasNext;
    BOOL            m_bIsLoading;
}

@end

@implementation ShareBookSearchResultViewController
@synthesize dataModel;
-(void)dealloc
{
    [refreshView release];
    refreshView = nil;
    [arrayReturnSouce release];
    arrayReturnSouce = nil;
    [tbDataBank11 release];
    tbDataBank11 = nil;
    [super dealloc];
}
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
        [self.headview setTitle:@"搜索结果"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:17.0f/255 green:22.0f/255 blue:27.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
      
        [self.view setBackgroundColor:[UIColor whiteColor]];
        

        
        DLogInfo(@"dddd %@",SHARED.userId);
     
        
        m_itagId = 0;
        m_iCurrentPage = 1;
        m_bIsLoading = NO;
        m_bHasNext = NO;
        m_iPageNum = 20;
        
        MagicRequest *request = [DYBHttpMethod book_tag_list:self.dataModel.keyword kind:self.dataModel.kind tagID:self.dataModel.tagid circle_id:self.dataModel.cirleID loan_status:self.dataModel.loanstatus loan_way:self.dataModel.loanway page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] sAlert:YES receive:self];
        [request setTag:2];
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight) isNeedUpdate:NO];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
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
        s = [NSNumber numberWithInteger:arrayReturnSouce.count];
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
        
        ShareBookCell *cell = [[ShareBookCell alloc]init];
        cell.tb  = tbDataBank11;
        cell.indexPath = indexPath;
        [cell creatCell:[arrayReturnSouce objectAtIndex:indexPath.row]];
        DLogInfo(@"%d", indexPath.section);
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ShareBookDetailViewController *bookDetail = [[ShareBookDetailViewController alloc]init];
        [bookDetail setDictInfo:[arrayReturnSouce objectAtIndex:indexPath.row]];
        [self.drNavigationController pushViewController:bookDetail animated:YES];
        RELEASE(bookDetail);
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        if (![self needNoteRefreshView])
        {
            
            [refreshView egoRefreshScrollViewDataSourceAllDataIsFinished:tbDataBank11];
            return;
        }
        
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

//TABLESCROLLVIEWDIDENDDRAGGING

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
    }
}
#pragma mark- 只接受HTTP信号

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
                    
                    
                    if (!arrayReturnSouce)
                    {
                        arrayReturnSouce = [[NSMutableArray alloc] init];
                    }
                    [arrayReturnSouce addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"book_list"]];
                    m_bHasNext = [[[dict valueForKey:@"data"] objectForKey:@"havenext"] boolValue];
                    [tbDataBank11 reloadData];
                    
                    if (![arrayReturnSouce count])
                    {
                        [self setNoDataViewHide:NO];
                    }
                    [self finishReloadingData];

                    
                }else{
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
    
    
    [label setText:@"搜索结果为空"];
    
    
    
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
            m_iCurrentPage++;
            MagicRequest *request = [DYBHttpMethod book_tag_list:self.dataModel.keyword kind:self.dataModel.kind tagID:self.dataModel.tagid circle_id:self.dataModel.cirleID loan_status:self.dataModel.loanstatus loan_way:self.dataModel.loanway page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] sAlert:YES receive:self];
            [request setTag:2];
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
