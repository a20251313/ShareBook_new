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
        MagicRequest *request = [DYBHttpMethod shareBook_user_friendlist_user_id:SHARED.userId sAlert:YES receive:self];
        [request setTag:2];
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UIButton *btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 160.0f, 40.0f)];
        [btnLeft setTag:101];
        //        [btnLeft setBackgroundColor:[UIColor redColor]];
        [btnLeft setImage:[UIImage imageNamed:@"bg02"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"bg02_2"] forState:UIControlStateSelected];
        [btnLeft addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLeft];
//        RELEASE(btnLeft);
//        [btnLeft setSelected:YES];
        [self addlabel_title:@"全部成员" frame:btnLeft.frame view:btnLeft];
        
        
        UIButton *btnRight = [[UIButton alloc]initWithFrame:CGRectMake(160.0f, self.headHeight, 160.0f, 40.0f)];
        [btnRight setTag:102];
        //        [btnRight setBackgroundColor:[UIColor yellowColor]];
        [btnRight setImage:[UIImage imageNamed:@"bg02"] forState:UIControlStateNormal];
        [btnRight setImage:[UIImage imageNamed:@"bg02_2"] forState:UIControlStateSelected];
        [btnRight addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btnRight];
//        RELEASE(btnRight);
        [self addlabel_title:@"全部书籍" frame:btnRight.frame view:btnRight];
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight ,320  , self.view.frame.size.height - self.headHeight  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        
        //        [self creatDownBar];
        
        
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

#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

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
//        int high = bShowBook == YES ? 90 : 50;
        NSNumber *s = [NSNumber numberWithInteger:50];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
////        if (bShowBook) {
//            ShareBookCell *cell = [[ShareBookCell alloc]init];
//            [cell creatCell];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            [signal setReturnValue:cell];
////        }else{
//
            ShareGiveDouCell *cell = [[ShareGiveDouCell alloc]init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell creatCell:[arrayResult objectAtIndex:indexPath.row]];
            [signal setReturnValue:cell];
//        }
//        
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
//        if (bShowBook) {
//            ShareBookDetailViewController *bookDetail = [[ShareBookDetailViewController alloc]init];
//            [self.drNavigationController pushViewController:bookDetail animated:YES];
//            RELEASE(bookDetail);
//        }else{
            ShareBookOtherCenterViewController *otherCenter = [[ShareBookOtherCenterViewController alloc]init];
        otherCenter.dictInfo = [arrayResult objectAtIndex:indexPath.row];
            [self.drNavigationController pushViewController:otherCenter animated:YES];
            RELEASE(otherCenter);
            
//        }
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
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
                    
                    JsonResponse *response = (JsonResponse *)receiveObj; //登陆成功，记下
                    
                    arrayResult = [[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"] objectForKey:@"user_list"]];
                    [tbDataBank11 reloadData];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    //                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
                    //                    [btn setTag:10];
                    //                    [self doChange:btn];
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



@end
