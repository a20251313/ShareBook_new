//
//  ShareFriendListViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-14.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareUserListViewController.h"
#import "ShareGiveDouCell.h"
#import "ShareDouSendViewController.h"
#import "JSON.h"
#import "EGORefreshTableFooterView.h"
#import "ShareUserInfoCell.h"

@interface ShareUserListViewController ()<UISearchBarDelegate>

{
    EGORefreshTableFooterView   *refreshView;
    int             m_iCurrentPage;
    int             m_iPageNum;
    BOOL            m_bHasNext;
    BOOL            m_bIsLoading;
    
    DYBUITableView * tbDataBank11;
    NSMutableArray  *m_arrayLists;
}
@end

@implementation ShareUserListViewController

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
        [self.headview setTitle:@"搜索"];
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
        
        
        
        
        
        UISearchBar *searchView = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,self.headHeight, 320, 44) ];
        searchView.tag = 3000;
        for (UIView *subview in [searchView subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
            }else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setBackground:[UIImage imageNamed:@"bg_search"]];
                
            }else if ([subview isKindOfClass:[UIButton class]]){
                
                
            }
        }
        
        [searchView setPlaceholder:@"搜索用户名"];
        [searchView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [searchView setUserInteractionEnabled:YES];
        [self.view addSubview:searchView];
        searchView.delegate = self;
        RELEASE(searchView)
        
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight+50,320  , self.view.frame.size.height - self.headHeight-50) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        tbDataBank11.canEdit = YES;
        [tbDataBank11 setBackgroundColor:[UIColor clearColor]];
        [tbDataBank11 setBackgroundView:[[UIView new] autorelease]];
        // [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        [tbDataBank11 setSeparatorColor:[UIColor clearColor]];
        RELEASE(tbDataBank11);
        
        
        /*
        
        MagicRequest    *request = [DYBHttpMethod shareBook_UserList:SHARED.userId sAlert:YES receive:self];
        request.tag = 2;*/
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



#pragma mark- 只接受UITableView信号
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
  
        NSNumber *s;
        s = [NSNumber numberWithInteger:m_arrayLists.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:[ShareUserInfoCell ShareUserInfoCellHeight]];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        ShareUserInfoCell *cell = [tbDataBank11 dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell)
        {
            cell = [[ShareUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            
            UIButton *btnBorrow = [[UIButton alloc]initWithFrame:CGRectMake(200, ([ShareUserInfoCell ShareUserInfoCellHeight]-35)/2, 100, 35)];
            [btnBorrow setTag:102];
            [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
            [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
            [btnBorrow addTarget:self action:@selector(clickAddFriend:) forControlEvents:UIControlEventTouchUpInside];
            [PublicUtl addlabel_title:@"加为好友" frame:btnBorrow.bounds view:btnBorrow textColor:[UIColor whiteColor]];
            [cell addSubview:btnBorrow];
            btnBorrow.tag = indexPath.row;
            [btnBorrow release];
            
        }else
        {
            for (UIButton  *btnAdd in cell.subviews)
            {
                if ([btnAdd isKindOfClass:[UIButton class]])
                {
                    btnAdd.tag = indexPath.row;
                }
            }
        }

        
        [cell creatCell:m_arrayLists[indexPath.row]];
        DLogInfo(@"%d", indexPath.section);
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        NSDictionary    *dicInfo = m_arrayLists[indexPath.row];
        [self addFriend:dicInfo];
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}



#pragma search

-(void)doSearch:(NSString*)searchText
{
    
    if ([searchText length] < 1)
    {
        [PublicUtl showText:@"请输入搜索条件" Gravity:iToastGravityBottom];
        return;
    }
    
    [self.view endEditing:YES];
    
    [PublicUtl addHUDviewinView:self.view];
    MagicRequest    *request = [DYBHttpMethod book_user_search_user_id:searchText sAlert:YES receive:self];
    request.tag = 300;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self doSearch:searchBar.text];
}


-(void)addFriend:(NSDictionary*)dicInfo
{
    [PublicUtl addHUDviewinView:self.view];
    MagicRequest    *request = [DYBHttpMethod book_friend_add_user_id:[dicInfo objectForKey:@"user_id"] sAlert:YES receive:self];
    request.tag = 200;
}

-(void)clickAddFriend:(UIButton*)sender
{
    NSDictionary    *dicInfo = m_arrayLists[sender.tag];
    [self addFriend:dicInfo];

}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        

        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            [PublicUtl hideHUDViewInView:self.view];
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {

                    if (m_arrayLists == nil)
                    {
                        m_arrayLists = [[NSMutableArray alloc] init];
                    }
                    
                    [m_arrayLists addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"user_list"]];
                    [tbDataBank11 reloadData];
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 200){
            [PublicUtl hideHUDViewInView:self.view];
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    [PublicUtl showText:@"添加好友成功" Gravity:iToastGravityBottom];
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 300)
        {
            
                [PublicUtl hideHUDViewInView:self.view];
                
                NSDictionary *dict = [request.responseString JSONValue];
                
                if (dict) {
                    
                    if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                        
                        if (m_arrayLists == nil)
                        {
                            m_arrayLists = [[NSMutableArray alloc] init];
                        }
                        
                        [m_arrayLists removeAllObjects];
                        [m_arrayLists addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"user_list"]];
                        [tbDataBank11 reloadData];
                    }else{
                        NSString *strMSG = [dict objectForKey:@"message"];
                        
                        [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                        
                        
                    }
                }
            
        }
            else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}



@end
