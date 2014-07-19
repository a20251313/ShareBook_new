//
//  ShareBookFriendListViewController.m
//  ShareBook
//
//  Created by apple on 14-3-16.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookFriendListViewController.h"
#import "ShareGiveDouCell.h"
#import "ShareBookOtherCenterViewController.h"

#import "JSONKit.h"
#import "JSON.h"
#import "ShareUserListViewController.h"
#import "ShareUserInfoCell.h"

@interface ShareBookFriendListViewController (){

    DYBUITableView *tbDataBank11;
    NSMutableArray *arrayResult;
}

@end

@implementation ShareBookFriendListViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"好友中心"];
        
        //        [self setButtonImage:self.leftButton setImage:@"back"];
        //        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        //        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        
        [self setButtonImage:self.rightButton setImage:@"icon+"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
//        bShowBook = NO;
        DLogInfo(@"%@",SHARED.userId);
    
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        



        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight ,320  , self.view.frame.size.height - self.headHeight  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        tbDataBank11.canEdit = YES;
       // [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        [tbDataBank11 setSeparatorColor:[UIColor clearColor]];
        RELEASE(tbDataBank11);
        
        
   
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        [self getNewFriendList];
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


-(void)doChoose:(id)sender{
    
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        [btn setSelected:YES];
//        bShowBook = NO;
        
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
        if (btn2) {
            [btn2 setSelected:NO];
            
            
        }
    }else{
//        bShowBook = YES;
        [btn setSelected:YES];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
        if (btn2) {
            [btn2 setSelected:NO];
        }
        
        
    }
    [tbDataBank11 reloadData];
}



- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
     
        ShareUserListViewController *userList = [[ShareUserListViewController alloc] init];
        [self.drNavigationController pushViewController:userList animated:YES];
        RELEASE(userList);
    }
}


#pragma mark- 只接受UITableView信号
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
  
        NSNumber *s;
        
        s = [NSNumber numberWithInteger:arrayResult.count];

        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
//        int high = bShowBook == YES ? 90 : 50;
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
            
            
            /*UIButton *btnBorrow = [[UIButton alloc]initWithFrame:CGRectMake(200, ([ShareUserInfoCell ShareUserInfoCellHeight]-35)/2, 100, 35)];
            [btnBorrow setTag:102];
            [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
            [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
            [btnBorrow addTarget:self action:@selector(clickDeleteFriend:) forControlEvents:UIControlEventTouchUpInside];
            [PublicUtl addlabel_title:@"删除好友" frame:btnBorrow.bounds view:btnBorrow textColor:[UIColor whiteColor]];
            [cell addSubview:btnBorrow];
            btnBorrow.tag = indexPath.row;
            [btnBorrow release];*/
            
        }else
        {
            /*for (UIButton  *btnAdd in cell.subviews)
            {
                if ([btnAdd isKindOfClass:[UIButton class]])
                {
                    btnAdd.tag = indexPath.row;
                }
            }*/
        }
        
            [cell creatCell:[arrayResult objectAtIndex:indexPath.row]];
            [signal setReturnValue:cell];
       
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
      
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        [tbDataBank11 deselectRowAtIndexPath:indexPath animated:YES];
            ShareBookOtherCenterViewController *otherCenter = [[ShareBookOtherCenterViewController alloc]init];
        otherCenter.dictInfo = [arrayResult objectAtIndex:indexPath.row];
            [self.drNavigationController pushViewController:otherCenter animated:YES];
            RELEASE(otherCenter);
            
//        }
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }else if ([signal is:[MagicUITableView TABLEEDITEVENT]])
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableViewCellEditingStyle editStyle = [[dict objectForKey:@"editingStyle"] intValue];
        if (editStyle == UITableViewCellEditingStyleDelete)
        {
            [self deleteFriend:arrayResult[indexPath.row]];
        }
    
    }
    
    
    
}


-(void)getNewFriendList
{
    MagicRequest *request = [DYBHttpMethod shareBook_user_friendlist_user_id:SHARED.userId sAlert:YES receive:self];
    [request setTag:2];
}
-(void)deleteFriend:(NSDictionary*)dicInfo
{
    [PublicUtl addHUDviewinView:self.view];
    MagicRequest    *request = [DYBHttpMethod book_friend_del_user_id:[dicInfo objectForKey:@"user_id"] sAlert:YES receive:self];
    request.tag = 200;
}

-(void)clickDeleteFriend:(UIButton*)sender
{
    NSDictionary    *dicInfo = arrayResult[sender.tag];
    [self deleteFriend:dicInfo];
    
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 2) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    if (!arrayResult)
                    {
                        arrayResult = [[NSMutableArray alloc] init];
                    }
                    [arrayResult removeAllObjects];
                    [arrayResult addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"user_list"]];
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
                    
                    [PublicUtl showText:@"删除成功" Gravity:iToastGravityBottom];
                    [self getNewFriendList];
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }  else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}




@end
