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
#import "ShareFriendListViewController.h"
#import "ShareBookApplyViewController.h"
#import "ShareBookOtherCenterViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"

@interface ShareBookDetailViewController ()

@end

@implementation ShareBookDetailViewController
@synthesize dictInfo = _dictInfo;
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
        [self.headview setTitle:@"图书详情"];
        
        
//        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self setButtonImage:self.rightButton setImage:@"top_bt_bg" strTitle:@"书主"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
//        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        
        MagicRequest *request = [DYBHttpMethod shareBook_book_detail_pub_id:[_dictInfo objectForKey:@"pub_id"] sAlert:YES receive:self];
        [request setTag:2];
        
        
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
//        [self creatDetailView];
        
        
        UIImage *image1 = [UIImage imageNamed:@"down_options_bg"];
        
        UIImageView *imageNum1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 5.0f + self.headHeight + 160, 320.0f, 60)];
        [imageNum1 setImage:image1];
        [self.view addSubview:imageNum1];
        [imageNum1 release];
        
        UILabel *labelNum3  = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 3, 100.0f, 40)];
        [labelNum3 setText:@"书主评论："];
        [labelNum3 sizeToFit];
        [imageNum1 addSubview:labelNum3];
        RELEASE(labelNum3);
        
        UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(110.0f, .0f , 210.0f, 40)];
        [labelText setText:@"图书很好看，图书很好看图书很好看评主评论："];
        [labelText setFont:[UIFont systemFontOfSize:14]];
        
        labelText.lineBreakMode = UILineBreakModeWordWrap;
        labelText.numberOfLines = 0;
        [imageNum1 addSubview:labelText];
        RELEASE(labelText);
        
        
        
        UIImage *image = [UIImage imageNamed:@"down_options_bg"];
        
        UIImageView *imageNum = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 5.0f + self.headHeight + 210, 320.0f, 40)];
        [imageNum setImage:image];
        [self.view addSubview:imageNum];
        [imageNum release];
        
        
        
        
        
        
        
        UILabel *labelNum  = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 0, 320.0f, 40)];
        [labelNum setText:@"本书评论（101）"];
        [imageNum addSubview:labelNum];
        RELEASE(labelNum);
        
        
        
        
        DYBUITableView * tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, 5.0f + self.headHeight + 210 + 40, 320.0f, self.view.frame.size.height -44-100  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self creatDownBar];
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)creatDownBar{

    
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
    UIButton *btnYU = [[UIButton alloc]initWithFrame:CGRectMake(7.0f, (image.size.height/2 -btnImage.size.height/2)/2 , btnImage.size.width/2, btnImage.size.height/2)];
    [btnYU setTag:101];
    [btnYU setBackgroundColor:[UIColor redColor]];
    [btnYU setImage:[UIImage imageNamed:@"bt01_click"] forState:UIControlStateHighlighted];
    [btnYU setImage:[UIImage imageNamed:@"bt01"] forState:UIControlStateNormal];
    [btnYU addTarget:self action:@selector(doBorrow:) forControlEvents:UIControlEventTouchUpInside];
//    [btnYU setEnabled:NO];
    [self addlabel_title:@"预借" frame:btnYU.frame view:btnYU textColor:[UIColor blackColor]];
//    [viewBar addSubview:btnYU];
//    [btnYU release];
    
//    [UIColor whiteColor];
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
    if (btn.tag == 101) {
        
        
        MagicRequest *request = [DYBHttpMethod shareBook_book_reserve_pub_id:[_dictInfo objectForKey:@"pub_id"] content:@"dd" sAlert:YES receive:self];
        [request setTag:3];
        
//        ShareFriendListViewController *friend = [[ShareFriendListViewController alloc]init];
//        [self.drNavigationController pushViewController:friend animated:YES];
//        RELEASE(friend);
        
        
    }else{
        
        ShareBookApplyViewController *apply = [[ShareBookApplyViewController alloc]init];
        apply.dictInfo = _dictInfo;
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
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, 15.0f + self.headHeight, 100, 20)];
    [labelName setText:[dict objectForKey:@"title"]];
    [self.view addSubview:labelName];
    [labelName release];
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelName.frame) + CGRectGetMinY(labelName.frame), 200, 20)];
    [labelAuther setFont:[UIFont systemFontOfSize:13]];
    [labelAuther setText:[NSString stringWithFormat:@"作  者：%@",[dict objectForKey:@"author"]]];
    [self.view addSubview:labelAuther];
    [labelAuther release];
    
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelAuther.frame) + CGRectGetMinY(labelAuther.frame), 150, 20)];
    [labelPublic setText:[NSString stringWithFormat:@"出版社：%@",[dict objectForKey:@"publisher"]]];
    [labelPublic setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelPublic];
    [labelPublic release];
    
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelPublic.frame) + CGRectGetMinY(labelPublic.frame), 150, 20)];
    [labelTime setText:@"借出次数：3次"];
    [labelTime setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelTime];
    [labelTime release];
    
    
    UILabel *labelMon = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame), 200, 20)];
    [labelMon setText:[NSString stringWithFormat:@"押 金：%@",[dict objectForKey:@"deposit"]]];
    [labelMon setFont:[UIFont systemFontOfSize:13]];
    [labelMon sizeToFit];
    [self.view addSubview:labelMon];
    [labelMon release];
    
    UILabel *labelMon1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelMon.frame) + CGRectGetWidth(labelMon.frame)+ 15, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame) - 1, 200, 20)];
    [labelMon1 setText:[NSString stringWithFormat:@"租 金：20乐享豆"]];
    [labelMon1 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelMon1];
    [labelMon1 release];
    
    
    UILabel *labelType = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelMon.frame) + CGRectGetMinY(labelMon.frame), 200, 20)];
    [labelType setText:[NSString stringWithFormat:@"借出方式：%@",[dict objectForKey:@"lent_way"]]];
    [labelType setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:labelType];
    [labelType release];
    
    UILabel *labelModle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageIcon.frame) + CGRectGetWidth(imageIcon.frame)+ 5, CGRectGetHeight(labelType.frame) + CGRectGetMinY(labelType.frame), 100, 20)];
    [labelModle setText:[NSString stringWithFormat:@"状  态：%@",[dict objectForKey:@"loan_status"]]];
    [labelModle setFont:[UIFont systemFontOfSize:13]];
    
    [self.view addSubview:labelModle];
    [labelModle release];
    
    
    

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
        s = [NSNumber numberWithInteger:10];
        //        }else{
        //            s = [NSNumber numberWithInteger:[_arrStatusData count]];
        //        }
        
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
        
        ShareBookDetailCell *cell = [[ShareBookDetailCell alloc]init];
        
//        NSDictionary *dictInfoFood = nil;
//        [cell creatCell:dictInfoFood];
        DLogInfo(@"%d", indexPath.section);
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 60-1, 320.0f, 1)];
        [imageLine setImage:[UIImage imageNamed:@"line3"]];
        [cell addSubview:imageLine];
        [imageLine release];
        
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        
        
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
                    
                    JsonResponse *response = (JsonResponse *)receiveObj; //登陆成功，记下
                    [self creatDetailView:[[dict objectForKey:@"data"] objectForKey:@"book_detail"]];
                    //                    SHARED.sessionID = response.sessID;
                    //
                    //                    self.DB.FROM(USERMODLE)
                    //                    .SET(@"userInfo", request.responseString)
                    //                    .SET(@"userIndex",[dict objectForKey:@"user_id"])
                    //                    .INSERT();
                    
                    //                    SHARED.userId = [dict objectForKey:@"user_id"]; //设置userid 全局变量
                    
                    //                    DYBUITabbarViewController *vc = [[DYBUITabbarViewController sharedInstace] init:self];
                    //
                    //                    [self.drNavigationController pushViewController:vc animated:YES];
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){ //预约
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if ([[dict objectForKey:@"response"] isEqualToString:@"100"]) {
                     NSString *strMSG = [dict objectForKey:@"message"];
                     [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
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
