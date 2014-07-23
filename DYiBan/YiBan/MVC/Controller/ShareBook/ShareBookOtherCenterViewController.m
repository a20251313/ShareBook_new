//
//  ShareBookOtherCenterViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-25.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookOtherCenterViewController.h"
#import "ShareGiveDouCell.h"
#import "ShareBookCell.h"
#import "ShareBookDetailViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "ShareBookMsgChatViewController.h"



@interface ShareBookOtherCenterViewController (){

    DYBUITableView *tbDataBank11;
    BOOL bShowBook;
    
    NSMutableArray *arrayListBook;
    NSMutableArray *arrayHisBooks;
    
    BOOL            m_bHasNext;
    int             m_iCurrentPage;
    int             m_ipageNum;
    BOOL            m_bIsLoading;
}

@end

@implementation ShareBookOtherCenterViewController
@synthesize dictInfo = _dictInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc
{
    RELEASE(arrayHisBooks);
    RELEASE(arrayListBook);
    [super dealloc];
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
        [self.headview setTitle:@"个人中心"];
        
        //        [self setButtonImage:self.leftButton setImage:@"back"];
        //        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        //        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        bShowBook = NO;
        
        MagicRequest *request = [DYBHttpMethod shareBook_user_detail_user_id:[_dictInfo objectForKey:@"user_id"] sAlert:YES receive:self];
        [request setTag:3];
        
        
        
        
        m_ipageNum = 20;
        m_iCurrentPage = 1;
        m_bHasNext = NO;
        if (!arrayHisBooks)
        {
            arrayHisBooks = [[NSMutableArray alloc] init];
        }
        [self requestHistoryBooks];
        MagicRequest *req = [DYBHttpMethod shareBook_user_booklist_user_id:[_dictInfo objectForKey:@"user_id"] page:@"1" num:@"100" sAlert:YES receive:self];
        [req setTag:2];

        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        
        
        
        UIButton *btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, self.headHeight+ 100, 160.0f, 40.0f)];
        [btnLeft setTag:101];
        //        [btnLeft setBackgroundColor:[UIColor redColor]];
        [btnLeft setImage:[UIImage imageNamed:@"bg02"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"bg02_2"] forState:UIControlStateSelected];
        [btnLeft addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLeft];
        RELEASE(btnLeft);
        [btnLeft setSelected:YES];
        [self addlabel_title:@"还书历史" frame:btnLeft.frame view:btnLeft];
        
        
        UIButton *btnRight = [[UIButton alloc]initWithFrame:CGRectMake(160.0f, self.headHeight + 100, 160.0f, 40.0f)];
        [btnRight setTag:102];
        //        [btnRight setBackgroundColor:[UIColor yellowColor]];
        [btnRight setImage:[UIImage imageNamed:@"bg02"] forState:UIControlStateNormal];
        [btnRight setImage:[UIImage imageNamed:@"bg02_2"] forState:UIControlStateSelected];
        [btnRight addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRight];
        RELEASE(btnRight);
        [self addlabel_title:@"上架图书" frame:btnRight.frame view:btnRight];
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0,40 + self.headHeight + 100 ,320  , self.view.frame.size.height - 40 - self.headHeight-60-90) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        tbDataBank11.separatorColor = [UIColor clearColor];
       // [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        
        
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(20.0f,CGRectGetHeight(tbDataBank11.frame) + CGRectGetMinY(tbDataBank11.frame) + 5, 280.0f, 40.0f)];
        [btnOK setTag:102];
        [btnOK setImage:image1 forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(doSendMsg:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK];
        RELEASE(btnOK);
        
        [self addlabel_title:@"发私信" frame:btnOK.frame view:btnOK];
        
        
        
        //        [self creatDownBar];
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)doSendMsg:(id)sender
{
    
    ShareBookMsgChatViewController *msgConteoller = [[ShareBookMsgChatViewController alloc] init];
    msgConteoller.dictInfo = self.dictInfo;
    [self.drNavigationController pushViewController:msgConteoller animated:YES];
    RELEASE(msgConteoller);
    
}
-(void)requestHistoryBooks
{
    m_bIsLoading = YES;
    MagicRequest  *request = [DYBHttpMethod order_list_kind:@"2" page:[@(m_iCurrentPage) description] num:[@(m_ipageNum) description] orderType:@"1" orderStatus:@"7" sAlert:YES receive:self];
    request.tag = 1000;
}
-(void)creatView:(NSDictionary *)dict{

    UIImage *image = [UIImage imageNamed:@"system-avatar"];
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f + self.headHeight, image.size.width/2, image.size.height/2)];
    if ([[dict valueForKey:@"pic_s"] length] > 1)
    {
         [imageIcon setImageWithURL:[DYBShareinstaceDelegate getImageString:[dict objectForKey:@"pic_s"] ]placeholderImage:image];
    }else
    {
        [imageIcon setImage:image];
    }
 
    [imageIcon setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageIcon];
    [imageIcon release];
    

    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, 10.0f + self.headHeight, 260, 20)];
    [labelAuther setFont:[UIFont systemFontOfSize:15]];
    [labelAuther setText:[NSString stringWithFormat:@"用户名：%@",[dict objectForKey:@"username"]]];
    [self.view addSubview:labelAuther];
    [labelAuther release];
    [labelAuther setBackgroundColor:[UIColor clearColor]];
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelAuther.frame) + CGRectGetMinY(labelAuther.frame), 50, 20)];
    [labelPublic setText:[NSString stringWithFormat:@"信    用："]];
    [labelPublic setFont:[UIFont systemFontOfSize:15]];
    [labelPublic sizeToFit];
    [self.view addSubview:labelPublic];
    [labelPublic release];
    [labelPublic setBackgroundColor:[UIColor clearColor]];
    
    UIImage *iamageG = [UIImage imageNamed:@"bg_good"];
    UIImageView *imageViewGood = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelPublic.frame) + CGRectGetWidth(labelPublic.frame)+ 5, CGRectGetHeight(labelAuther.frame) + CGRectGetMinY(labelAuther.frame), iamageG.size.width/2, iamageG.size.height/2)];
    [imageViewGood setImage:[UIImage imageNamed:@"bg_good"]];
    [self.view addSubview:imageViewGood];
    RELEASE(imageViewGood);
    
    UILabel *labelGood = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 5.0f, 20.0f, 20.0f)];
    [labelGood setText:[dict objectForKey:@"good_credit"]];
    [imageViewGood addSubview:labelGood];
    RELEASE(labelGood);
    [labelGood setBackgroundColor:[UIColor clearColor]];
    
    UIImage *iamgeB = [UIImage imageNamed:@"bg_bad"];
    UIImageView *imageViewBad = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewGood.frame) + CGRectGetWidth(imageViewGood.frame)+ 5, CGRectGetHeight(labelAuther.frame) + CGRectGetMinY(labelAuther.frame), iamgeB.size.width/2, iamgeB.size.height/2)];
    [imageViewBad setImage:[UIImage imageNamed:@"bg_bad"]];
    [self.view addSubview:imageViewBad];
    RELEASE(imageViewBad);
    
    UILabel *labelDad = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 5.0f, 20.0f, 20.0f)];
    [labelDad setText:[dict objectForKey:@"bad_credit"]];
    [imageViewBad addSubview:labelDad];
    RELEASE(labelDad);
    [labelDad setBackgroundColor:[UIColor clearColor]];
    
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
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]]){
        NSNumber *s;
        if (bShowBook)
        {
            s = [NSNumber numberWithInteger:arrayListBook.count];
        }else
        {
            s = [NSNumber numberWithInteger:arrayHisBooks.count];
        }
       
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        int high = [ShareBookCell ShareBookCellHeight];
        NSNumber *s = [NSNumber numberWithInteger:high];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if (bShowBook) {
            ShareBookCell *cell = [[ShareBookCell alloc]init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.tb = tbDataBank11;
            cell.indexPath = indexPath;
            
            [cell creatCell:[arrayListBook objectAtIndex:indexPath.row]];
            [signal setReturnValue:cell];
        }else{
            
              
            
            ShareBookCell *cell = [[ShareBookCell alloc]init];
            cell.tb  = tbDataBank11;
            cell.cellType = ShareBookCellTypeOpearate;
            cell.indexPath = indexPath;
            [cell creatCell:arrayHisBooks[indexPath.row]];
            cell.indexPath = indexPath;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [signal setReturnValue:cell];
        }
        
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if (bShowBook) {
            ShareBookDetailViewController *bookDetail = [[ShareBookDetailViewController alloc]init];
            bookDetail.dictInfo = [arrayListBook objectAtIndex:indexPath.row];
            [self.drNavigationController pushViewController:bookDetail animated:YES];
            RELEASE(bookDetail);
        }else{
            
            ShareBookDetailViewController *bookDetail = [[ShareBookDetailViewController alloc]init];
            bookDetail.dictInfo = [[arrayHisBooks objectAtIndex:indexPath.row] valueForKey:@"book"];
            [self.drNavigationController pushViewController:bookDetail animated:YES];
            RELEASE(bookDetail);
            
        }
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
        
        if (bShowBook)
        {
            return;
        }
        
        if (tbDataBank11.contentOffset.y+(tbDataBank11.frame.size.height) > tbDataBank11.contentSize.height)
        {
            if (!m_bIsLoading && m_bHasNext)
            {
                m_iCurrentPage++;
                [self requestHistoryBooks];
            }
            
        }
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]]){
        
        if (bShowBook)
        {
            return;
        }
        
        if (tbDataBank11.contentOffset.y+(tbDataBank11.frame.size.height) > tbDataBank11.contentSize.height)
        {
            if (!m_bIsLoading && m_bHasNext)
            {
                m_iCurrentPage++;
                [self requestHistoryBooks];
            }
            
        }
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}


-(void)doChoose:(id)sender{
    
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 101) {
        [btn setSelected:YES];
        bShowBook = NO;
        
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
        if (btn2) {
            [btn2 setSelected:NO];
            
            
        }
    }else{
        bShowBook = YES;
        [btn setSelected:YES];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
        if (btn2) {
            [btn2 setSelected:NO];
        }
        
        
    }
    [tbDataBank11 reloadData];
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
                    
                    arrayListBook = [[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"] objectForKey:@"book_list"]];
                    
                    [tbDataBank11 reloadData];
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){ //
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    [self creatView:[[dict objectForKey:@"data"] objectForKey:@"user"]];
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        }else if(request.tag == 1000) {
            
            m_bIsLoading = NO;
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    
                    [arrayHisBooks addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"order_list"]];
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] boolValue];
                    [tbDataBank11 reloadData];
                }else{
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
