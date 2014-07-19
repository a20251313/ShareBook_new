//
//  ShareBookMyQuanCenterViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-25.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookMyQuanCenterViewController.h"
#import "ShareBookDouCell.h"
#import "ShareAddQuanViewController.h"
#import "ShareBookQuanDetailViewController.h"
#import "WOSMapViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "EGORefreshTableFooterView.h"
#import "ShareBookCircleCell.h"

@interface ShareBookMyQuanCenterViewController ()<EGORefreshTableDelegate,UISearchBarDelegate>{


    DYBUITableView * tbDataBank11;
    EGORefreshTableFooterView   *refreshView;
    
    int             m_itagId;
    int             m_iCurrentPage;
    int             m_iPageNum;
    BOOL            m_bHasNext;
    BOOL            m_bIsLoading;
    
    
    NSMutableArray  *m_arraySearch;
    BOOL            m_bIsSearch;
}

@end

@implementation ShareBookMyQuanCenterViewController

@synthesize  isMuyQuanzi = _isMuyQuanzi,arrayResult=_arrayResult,bselct,makesure;

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
        [self.headview setTitle:@"圈子"];
        
        //        [self setButtonImage:self.leftButton setImage:@"back"];
       
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        //        [self.leftButton setHidden:YES];
        
        if (_isMuyQuanzi) {
            [self.headview setTitle:@"我的圈子"];
            [self setButtonImage:self.rightButton setImage:@"icon_map"];
           // [self.rightButton setHidden:YES];
        }else{
            
            [self.rightButton setHidden:YES];
           // [self setButtonImage:self.rightButton setImage:@"icon_map"];
        }
        
        
  
       
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        

        
        [self.view setBackgroundColor:[UIColor blackColor]];

        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        

        UISearchBar *searchView = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,self.headHeight, 320, 44) ];
        searchView.delegate = self;
        searchView.showsCancelButton = YES;
        /*backgroundColor:[UIColor clearColor] placeholder:@"文件名" isHideOutBackImg:NO isHideLeftView:NO];*/
        for (UIView *subview in [searchView subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
            }else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setBackground:[UIImage imageNamed:@"bg_search"]];
                
            }else if ([subview isKindOfClass:[UIButton class]]){
                
                
            }
        }
        
        [searchView setPlaceholder:@"圈子的名称"];
        [searchView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [searchView setUserInteractionEnabled:YES];
        [self.view addSubview:searchView];
        RELEASE(searchView)
        
        
        UIView *viewBGTableView = [[UIView alloc]initWithFrame:CGRectMake(10,self.headHeight + 44 + 20 , 300.0f , self.view.frame.size.height -self.headHeight - 44 - 50 - 20 - 30  )];
        
        [viewBGTableView setBackgroundColor:[UIColor whiteColor]];
        [viewBGTableView.layer setBorderWidth:1];
        [viewBGTableView.layer setCornerRadius:10.0f];
        [viewBGTableView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view addSubview:viewBGTableView];
        RELEASE(viewBGTableView);
        

        
        
        m_itagId = 0;
        m_iCurrentPage = 1;
        m_bIsLoading = NO;
        m_bHasNext = NO;
        m_iPageNum = 1000;
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(20,self.headHeight + 44 + 20, 280.0f , self.view.frame.size.height -self.headHeight - 44 - 50 - 20 - 30 ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];

        
        RELEASE(tbDataBank11);
        
        [self setFooterView];
        
        int offset = 0;
        if (!IOS7_OR_LATER) {
            
            offset = 20;
        }
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(self.view.frame) - 50 - offset, 280.0f, 40.0f)];
        [btnOK setTag:102];
        [btnOK setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnOK addTarget:self action:@selector(doChoose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK];
        RELEASE(btnOK);
        
        [self addlabel_title:@"创建乐享圈" frame:btnOK.frame view:btnOK];
        
        [self getCircleList];
//        [self creatDownBar];
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)getCircleList
{

    NSString    *type = @"2";
    if (self.isMuyQuanzi)
    {
        type = @"1";
    }
    MagicRequest *request = [DYBHttpMethod shareBook_circle_list:type page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] lat:SHARED.locationLat lng:SHARED.locationLng sAlert:YES receive:self];
        [request setTag:3];
    
}
-(void)getNearCircleList
{
    
    
    MagicRequest *request = [DYBHttpMethod book_circle_nearby:SHARED.locationLng lat:SHARED.locationLat page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] range:@"100" sAlert:YES receive:self];
    [request setTag:100];
    
    
}

-(void)setArrayResult:(NSMutableArray *)NewarrayResult
{
    if (_arrayResult == nil)
    {
        _arrayResult = [[NSMutableArray alloc] init];
    }
    
    [_arrayResult addObjectsFromArray:NewarrayResult];
    [self resortDataInfo];
    
    
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
      if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                
                    
                    if (!_arrayResult)
                    {
                        _arrayResult = [[NSMutableArray alloc] init];
                    }
                    [_arrayResult addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"list"]];
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] boolValue];
                    [self resortDataInfo];
                    [self finishReloadingData];
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
      } else if(request.tag == 100){
          
          NSDictionary *dict = [request.responseString JSONValue];
          
          if (dict) {
              BOOL result = [[dict objectForKey:@"result"] boolValue];
              if (!result) {
                  
                  
                  if (!_arrayResult)
                  {
                      _arrayResult = [[NSMutableArray alloc] init];
                  }
                  [_arrayResult addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"cricle_list"]];
                  m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] boolValue];
                  [self resortDataInfo];
                  [self finishReloadingData];
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

//cricle_list
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

#pragma mark- 只接受UITableView信号
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s;
        s = [NSNumber numberWithInteger:_arrayResult.count];
        if (m_bIsSearch)
        {
            s = [NSNumber numberWithInt:m_arraySearch.count];
        }
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:75];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        
       
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        NSDictionary *dictt =  nil;
        if (m_bIsSearch)
        {
            dictt = [m_arraySearch objectAtIndex:indexPath.row];
        }else
        {
            dictt =    [_arrayResult objectAtIndex:indexPath.row];
        }
     
        
        ShareBookCircleCell *cell = [[ShareBookCircleCell alloc] init];
        cell.isHasDistance = YES;
        [cell creatCell:dictt];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        if (bselct) {
            
            NSDictionary *dict1 = [_arrayResult objectAtIndex:indexPath.row];
            
            [makesure.labelAutoQuan1 setText:[dict1 objectForKey:@"circle_name"]];
           // makesure.dictResult = dict1;
            [self.drNavigationController popViewControllerAnimated:YES];
            return;
        }
        
        ShareBookQuanDetailViewController *detail = [[ShareBookQuanDetailViewController alloc]init];
        if (m_bIsSearch)
        {
            detail.dictInfo = [m_arraySearch objectAtIndex:indexPath.row];
        }else
        {
            detail.dictInfo =    [_arrayResult objectAtIndex:indexPath.row];
        }
        [self.drNavigationController pushViewController:detail animated:YES];
        RELEASE(detail);
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        if (m_bIsSearch)
        {
            return;
        }
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
        if (m_bIsSearch)
        {
            return;
        }
        
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


-(void)doChoose{

    ShareAddQuanViewController *add = [[ShareAddQuanViewController alloc]init];
    [self.drNavigationController pushViewController:add animated:YES];
    RELEASE(add);
}
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        WOSMapViewController *map = [[WOSMapViewController alloc]init];
        map.bShowLeft = YES;
        map.bIsMyQuan = YES;
        [self.drNavigationController pushViewController:map animated:YES];
        RELEASE(map);
        
    }
}




-(void)resortDataInfo
{
    [_arrayResult sortUsingComparator:^NSComparisonResult(id obj1,id obj2)
    {
        NSString    *strOne = [[obj1 valueForKey:@"distance_num"] lowercaseString];
        NSString    *strTwo = [[obj2 valueForKey:@"distance_num"] lowercaseString];
        strOne = [strOne stringByReplacingOccurrencesOfString:@"km" withString:@""];
        strTwo = [strTwo stringByReplacingOccurrencesOfString:@"km" withString:@""];
        strOne = [strOne stringByReplacingOccurrencesOfString:@"," withString:@""];
        strTwo = [strTwo stringByReplacingOccurrencesOfString:@"," withString:@""];
        if ([strOne floatValue] > [strTwo floatValue])
        {
            return NSOrderedDescending;
        }else
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    
    [tbDataBank11 reloadData];
    [self setFooterView];
}
#pragma mark refresh view
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
    return;
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

//- (void)scrollViewDidScroll:(UIScrollView *)newscrollView{
//
//
//    if (![self needNoteRefreshView])
//    {
//
//        [refreshView egoRefreshScrollViewDataSourceAllDataIsFinished:newscrollView];
//        return;
//    }
//
//	if (refreshView)
//	{
//        [refreshView egoRefreshScrollViewDidScroll:newscrollView];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)newscrollView willDecelerate:(BOOL)decelerate{
//
//
//    if (![self needNoteRefreshView])
//    {
//        [refreshView egoRefreshScrollViewDataSourceAllDataIsFinished:newscrollView];
//        return;
//    }
//	if (refreshView)
//	{
//        [refreshView egoRefreshScrollViewDidEndDragging:newscrollView];
//    }
//}



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
            [self getCircleList];
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

#pragma mark UISearchBardelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  //  MagicRequest    *request = [DYBHttpMethod sharebook_c];
    NSString    *searchText = searchBar.text;
    
    if ([searchText length])
    {
        if (!m_arraySearch)
        {
            m_arraySearch = [[NSMutableArray alloc] init];
        }
        
        [m_arraySearch removeAllObjects];
        
        searchText = [NSString stringWithFormat:@"*%@*",searchText];
        for (NSDictionary *dicInfo in _arrayResult)
        {
            NSString    *strName = [dicInfo valueForKey:@"circle_name"];
            NSPredicate *searchPre = [NSPredicate predicateWithFormat:@"self LIKE %@",searchText];
            if ([searchPre evaluateWithObject:strName])
            {
                [m_arraySearch addObject:dicInfo];
            }
        }

        m_bIsSearch = YES;
        if (m_arraySearch.count)
        {
              [self setNoDataViewHide:YES];
        }else
        {
              [self setNoDataViewHide:NO];
            DLogInfo(@"searchBarSearchButtonClicked no data");
        }

        [tbDataBank11 reloadData];
        [self setFooterView];
        
    }
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
     m_bIsSearch = NO;
    [tbDataBank11 reloadData];
    [self setFooterView];
    [self setNoDataViewHide:YES];
    [searchBar resignFirstResponder];
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
    [label setText:@"相关数据为空"];
}

-(void)dealloc
{
    RELEASE(m_arraySearch);
    self.arrayResult = nil;
    RELEASE(refreshView);
    [super dealloc];
}
@end
