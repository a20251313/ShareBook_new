//
//  ShareBookDetailViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-11.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookDetailViewController.h"
#import "Magic_UITableView.h"
#import "WOSOrderCell.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyViewController.h"
#import "ShareBookOtherCenterViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "ShareBookCircleCell.h"
#import "ShareBookQuanDetailViewController.h"
@interface ShareBookDetailViewController ()
{
    UILabel         *labelNum;
    UITextView         *textContent;
    NSMutableArray  *m_dataArray;
    DYBUITableView * tbDataBank11;
    NSMutableArray     *arrayCircles;
    int             m_iInfoTag;
}

@end

@implementation ShareBookDetailViewController
@synthesize dictInfo = _dictInfo;

-(void)dealloc
{
    RELEASE(textContent);;
    RELEASE(labelNum);
    RELEASE(tbDataBank11);
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
        [self.headview setTitle:@"图书详情"];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self setButtonImage:self.rightButton setImage:@"top_bt_bg" strTitle:@"书主"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
      
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {

        m_iInfoTag = 0;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        MagicRequest *request = [DYBHttpMethod shareBook_book_detail_pub_id:[_dictInfo objectForKey:@"pub_id"] sAlert:YES receive:self];
        [request setTag:2];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
                
        UIImage *image = [UIImage imageNamed:@"down_options_bg"];
        UIImageView *imageNum = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 5.0f + self.headHeight + 160, 320.0f, 40)];
        [imageNum setImage:image];
        [self.view addSubview:imageNum];
        [imageNum release];
        [self createTabListView:imageNum];
    

        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, 5.0f + self.headHeight + 200, 320.0f, self.view.frame.size.height-200-self.headHeight-50) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tbDataBank11.hidden = YES;
        [self requestBookComment];
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)setSummarContent
{
    UITextView  *mytextContent = (UITextView*)[self.view viewWithTag:999];
    if (!mytextContent)
    {
        mytextContent = [[UITextView alloc] initWithFrame:tbDataBank11.frame];
        [mytextContent setBackgroundColor:[UIColor clearColor]];
        [mytextContent setFont:[UIFont systemFontOfSize:14]];
        [mytextContent setEditable:NO];
        mytextContent.tag = 999;
        [self.view addSubview:mytextContent];
        [mytextContent release];
    }
    
    [mytextContent setFrame:tbDataBank11.frame];
    [mytextContent.superview bringSubviewToFront:mytextContent];
    [mytextContent setText:[self.dictInfo valueForKey:@"summary"]];
    mytextContent.hidden = NO;
    
}
-(void)clickSelectInfo:(UIButton*)sender
{
    m_iInfoTag = sender.tag-10;
    for (int i = 0;i < 3;i++)
    {
        UIButton    *btn = (UIButton*)[sender.superview viewWithTag:10+i];
        [btn setSelected:NO];
    }
    
    [sender setSelected:YES];
    if (m_iInfoTag != 0)
    {
        tbDataBank11.hidden = NO;
         UITextView  *mytextContent = (UITextView*)[self.view viewWithTag:999];
        mytextContent.hidden = YES;
        [tbDataBank11 reloadData];
    }else
    {
        tbDataBank11.hidden = YES;
        [self setSummarContent];
    }
}

-(void)createTabListView:(UIView*)superView
{
    CGFloat  fxpoint = 0;
  //  CGFloat  fxsep = 5;
    CGFloat  fwidth = 80;
    superView.userInteractionEnabled = YES;
    for (int i = 0; i < 3; i++)
    {
        UIButton    *btnTouchType = [[UIButton alloc] initWithFrame:CGRectMake(fxpoint, 0, fwidth, 40)];
        [btnTouchType setBackgroundImage:[UIImage imageNamed:@"options_bg"] forState:UIControlStateNormal];
        [btnTouchType setBackgroundImage:[UIImage imageNamed:@"click_bg"] forState:UIControlStateSelected];
        [superView addSubview:btnTouchType];
        [btnTouchType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTouchType addTarget:self action:@selector(clickSelectInfo:) forControlEvents:UIControlEventTouchUpInside];
        btnTouchType.tag = 10+i;
        switch (i+10)
        {
            case 10:
                [btnTouchType setTitle:@"图书简介" forState:UIControlStateNormal];
                [btnTouchType setSelected:YES];
                break;
            case 11:
                [btnTouchType setTitle:@"评论列表" forState:UIControlStateNormal];
                [btnTouchType setSelected:NO];
                break;
            case 12:
                [btnTouchType setTitle:@"圈子列表" forState:UIControlStateNormal];
                [btnTouchType setSelected:NO];
                break;
            default:
                break;
        }
        fxpoint += fwidth;
    }
}
-(void)creatDownBar{

    
    
    NSString    *strStatus = [self.dictInfo valueForKey:@"loan_status"];
    NSString    *strUserID = [self.dictInfo valueForKey:@"user_id"];
  
    if (![strStatus isEqualToString:@"可借阅"] || [strUserID isEqualToString:SHARED.userId])
    {
        [tbDataBank11 setFrame:CGRectMake(0, 5.0f + self.headHeight + 160 + 40, 320.0f, self.view.frame.size.height-200-self.headHeight)];
        return;
    }
    
    int offset = 0;
    if (!IOS7_OR_LATER) {
        
        offset = 20;
    }
    
    UIImage *image = [UIImage imageNamed:@"down_options_bg"];

    UIImageView *viewBar = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height -  image.size.height/2 - offset, 320.0f, image.size.height/2)];
    [viewBar setImage:[UIImage imageNamed:@"down_options_bg"]];
    [viewBar setUserInteractionEnabled:YES];
    [viewBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewBar];
    RELEASE(viewBar);
    
    
    UIImage *btnImage = [UIImage imageNamed:@"bt01_click"];

    UIButton *btnBorrow = [[UIButton alloc]initWithFrame:CGRectMake(10, (image.size.height/2 -btnImage.size.height/2)/2 , btnImage.size.width, btnImage.size.height/2)];
    [btnBorrow setTag:102];
    [btnBorrow setImage:[UIImage imageNamed:@"bt02_click"] forState:UIControlStateHighlighted];
    [btnBorrow setImage:[UIImage imageNamed:@"bt02"] forState:UIControlStateNormal];
    [btnBorrow setBackgroundColor:[UIColor yellowColor]];
    [self addlabel_title:@"申请借阅" frame:btnBorrow.frame view:btnBorrow textColor:[UIColor whiteColor]];
    
    if ([[_dictInfo objectForKey:@"user_id"] isEqualToString:SHARED.userId]) {
        [btnBorrow setUserInteractionEnabled:NO];
        [btnBorrow setImage:[UIImage imageNamed:@"bt01_click"] forState:UIControlStateNormal];
        [self addlabel_title:@"申请借阅" frame:btnBorrow.frame view:btnBorrow textColor:[UIColor blackColor]];
    }
    
    [btnBorrow addTarget:self action:@selector(doBorrow:) forControlEvents:UIControlEventTouchUpInside];
    [viewBar addSubview:btnBorrow];
    [btnBorrow release];
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



-(void)doBorrow:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    
    MagicRequest *request = [DYBHttpMethod book_order_pub_id:[_dictInfo objectForKey:@"pub_id"] sAlert:YES receive:self];
    [request setTag:3];
    
    /*
    
    MagicRequest *request = [DYBHttpMethod shareBook_book_reserve_pub_id:[_dictInfo objectForKey:@"pub_id"] content:@"dd" sAlert:YES receive:self];
    [request setTag:3];*/
    
    return;
    if (btn.tag == 101) {
        
        
        MagicRequest *request = [DYBHttpMethod shareBook_book_reserve_pub_id:[_dictInfo objectForKey:@"pub_id"] content:@"dd" sAlert:YES receive:self];
        [request setTag:3];
        
//        ShareFriendListViewController *friend = [[ShareFriendListViewController alloc]init];
//        [self.drNavigationController pushViewController:friend animated:YES];
//        RELEASE(friend);
        
        
    }else{
        
        ShareBookApplyViewController *apply = [[ShareBookApplyViewController alloc]init];
       // apply.dictInfo = _dictInfo;
        [self.drNavigationController pushViewController:apply animated:YES];
        RELEASE(apply);
        
        
        
    }
    

}




-(void)creatDetailView :(NSDictionary *)dict{

    UIImage *image = [UIImage imageNamed:@"defualt_book"];
    UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f + self.headHeight, 100, 160.0f)];
    [imageIcon setImageWithURL:[DYBShareinstaceDelegate getImageString:[dict objectForKey:@"image"]] placeholderImage:image];
    [imageIcon setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageIcon];
    [imageIcon release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, 15.0f + self.headHeight, 215, 20)];
    [labelName setText:[dict objectForKey:@"title"]];
    [self.view addSubview:labelName];
    [labelName release];
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelName.frame) + CGRectGetMinY(labelName.frame)+5, 200, 20)];
    [labelAuther setFont:[UIFont systemFontOfSize:13]];
    [labelAuther setText:[NSString stringWithFormat:@"作       者：%@",[dict objectForKey:@"author"]]];
    [self.view addSubview:labelAuther];
    [labelAuther release];
    
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelAuther.frame) + CGRectGetMinY(labelAuther.frame)+5, 200, 20)];
    [labelPublic setText:[NSString stringWithFormat:@"出  版  社：%@",[dict objectForKey:@"publisher"]]];
    [labelPublic setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelPublic];
    [labelPublic release];
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelPublic.frame) + CGRectGetMinY(labelPublic.frame)+5, 150, 20)];
    [labelTime setText:[NSString stringWithFormat:@"出版日期：%@",[dict valueForKey:@"pubdate"]]];
    [labelTime setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelTime];
    [labelTime release];
    
    /*
    UILabel *labelMon = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame), 200, 20)];
    [labelMon setText:[NSString stringWithFormat:@"押 金：%@",[dict objectForKey:@"deposit"]]];
    [labelMon setFont:[UIFont systemFontOfSize:13]];
    [labelMon sizeToFit];
    [self.view addSubview:labelMon];
    [labelMon release];
    
    UILabel *labelMon1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelMon.frame) + CGRectGetWidth(labelMon.frame)+ 15, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame) - 1, 200, 20)];
    [labelMon1 setText:[NSString stringWithFormat:@"租 金：%@",[dict objectForKey:@"rent"]]];
    [labelMon1 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelMon1];
    [labelMon1 release];
    */
    
    UILabel *labelType = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame)+5, 200, 20)];
    [labelType setText:[NSString stringWithFormat:@"借出方式：%@",[dict objectForKey:@"lent_way"]]];
    [labelType setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelType];
    [labelType release];
    
    UILabel *labelModle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelType.frame) + CGRectGetMinY(labelType.frame)+5, 200, 20)];
    [labelModle setText:[NSString stringWithFormat:@"图书状态：%@",[dict objectForKey:@"loan_status"]]];
    [labelModle setFont:[UIFont systemFontOfSize:13]];
    
    [self.view addSubview:labelModle];
    [labelModle release];

    

}


#pragma mark request comment
-(void)requestBookComment
{
    MagicRequest    *request = [DYBHttpMethod shareBook_book_commentlist_pub_id:[_dictInfo valueForKey:@"pub_id"] page:@"1" num:@"20" sAlert:YES receive:self];
    request.tag = 100;
}

#pragma mark- 只接受UITableView信号

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s = @(m_dataArray.count);
        if (m_iInfoTag == 2)
        {
            s = @(arrayCircles.count);
        }
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:60];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        if (m_iInfoTag == 2)
        {
            ShareBookCircleCell *cell = [[ShareBookCircleCell alloc]init];
            [cell creatCell:arrayCircles[indexPath.row]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 60-1, 320.0f, 1)];
            [imageLine setImage:[UIImage imageNamed:@"line3"]];
            [cell addSubview:imageLine];
            [imageLine release];
            [signal setReturnValue:cell];
            
        }else
        {
            ShareBookDetailCell *cell = [[ShareBookDetailCell alloc]init];
            [cell creatCell:m_dataArray[indexPath.row]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 60-1, 320.0f, 1)];
            [imageLine setImage:[UIImage imageNamed:@"line3"]];
            [cell addSubview:imageLine];
            [imageLine release];
            
            [signal setReturnValue:cell];
        }
     
        
        
 
        
        
    
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        if (m_iInfoTag == 2)
        {
            ShareBookQuanDetailViewController *detail = [[ShareBookQuanDetailViewController alloc]init];
            detail.dictInfo = [arrayCircles objectAtIndex:indexPath.row];
            [self.drNavigationController pushViewController:detail animated:YES];
            RELEASE(detail);
        }
     
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
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
        
        //        [self goShowOrderListAction];
        
        ShareBookOtherCenterViewController *resg = [[ShareBookOtherCenterViewController alloc]init];
        resg.dictInfo = _dictInfo;
        [self.drNavigationController pushViewController:resg animated:YES];
        RELEASE(resg);
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

                 
                    if (!arrayCircles)
                    {
                        arrayCircles = [[NSMutableArray alloc] init];
                    }
                    
                    self.dictInfo = [[dict objectForKey:@"data"] objectForKey:@"book_detail"];
                    [arrayCircles addObjectsFromArray:[[[dict objectForKey:@"data"] objectForKey:@"book_detail"] objectForKey:@"circles"]];
                    [self creatDetailView:[[dict objectForKey:@"data"] objectForKey:@"book_detail"]];
                    [self creatDownBar];
                    [self setSummarContent];
                    tbDataBank11.hidden = YES;
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){ //预约
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
              
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                    NSString    *orderID = [[dict valueForKey:@"data"] objectForKey:@"order_id"];
                    ShareBookApplyViewController   *apply = [[ShareBookApplyViewController alloc] init];
                    apply.orderID = orderID;
                    [self.drNavigationController pushViewController:apply animated:YES];
                    RELEASE(apply);
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        } else if(request.tag == 100){ //获取评论列表
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
  
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"])
                {
                    if (!m_dataArray)
                    {
                        m_dataArray = [[NSMutableArray alloc] init];
                    }
                    
                    NSArray *arrayData = [[dict valueForKey:@"data"] valueForKey:@"comment_list"];
                    if (arrayData.count)
                    {
                        [m_dataArray addObjectsFromArray:arrayData];
                    }
                    [labelNum setText:[NSString stringWithFormat:@"本书评论(%d)",arrayData.count]];
                    [tbDataBank11 reloadData:YES];
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




@end
