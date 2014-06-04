//
//  ShareSettingViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareSettingViewController.h"
#import "WOSOrderCell.h"
#import "ShareBookMangeAddrViewController.h"
#import "JSONKit.h"
#import "JSON.h"

@interface ShareSettingViewController (){

    NSMutableArray *arraySouce;
}

@end

@implementation ShareSettingViewController

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
        [self.headview setTitle:@"设置"];
        
//        [self setButtonImage:self.leftButton setImage:@"back"];
//        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        [self.leftButton setHidden:YES];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        
        UIImageView  *viewBG = [[UIImageView alloc]initWithFrame:self.view.frame];
        [viewBG setTag:100];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [self.view insertSubview:viewBG atIndex:0];
        RELEASE(viewBG);
        
        arraySouce = [[NSMutableArray alloc]initWithObjects:@"设置访问权限",@"消息推送",@"地址管理",@"设置自己的图书LOGO", nil];
        
        
        UIImage *image = [UIImage imageNamed:@"menu_inactive"];
        
        
        
        
        UIView *viewBGTableView = [[UIView alloc]initWithFrame:CGRectMake(10, self.headHeight + 20, 300.0f, 50 *4 )];
                                   
        [viewBGTableView setBackgroundColor:[UIColor whiteColor]];
        [viewBGTableView.layer setBorderWidth:1];
        [viewBGTableView.layer setCornerRadius:10.0f];
        [viewBGTableView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view addSubview:viewBGTableView];
        RELEASE(viewBGTableView);
        
        
        
        
        
        DYBUITableView * tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(20, self.headHeight + 20, 280.0f, 50 * 4  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        [tbDataBank11 setScrollEnabled:NO];
//        UIButton *btnSetP = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, self.view.frame.size.height - 100, 300.0f, 40.0f)];
//        [btnSetP setBackgroundColor:[UIColor redColor]];
//        [self.view addSubview:btnSetP];
//        [btnSetP release];
        
//<<<<<<< HEAD
//        int offset = 0;
//        if (!IOS7_OR_LATER) {
//            
//            offset = 20;
//        }
//        
//        UIButton *btnSetP = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, self.view.frame.size.height - 100 - offset, 300.0f, 40.0f)];
//        [btnSetP setBackgroundColor:[UIColor redColor]];
//        [self.view addSubview:btnSetP];
//        [btnSetP release];
//=======
        UIButton *btnBackGO= [[UIButton alloc]initWithFrame:CGRectMake(10.0f, 50 * 4 + self.headHeight + 20 + 20, 300.0f, 40.0f)];

        [btnBackGO setBackgroundColor:[UIColor clearColor]];
        [btnBackGO setImage:[UIImage imageNamed:@"bt_click1.png"] forState:UIControlStateNormal];
        [btnBackGO setImage:[UIImage imageNamed:@"bt_click1"] forState:UIControlStateSelected];
        [btnBackGO addTarget:self action:@selector(addOK) forControlEvents:UIControlEventTouchUpInside];
        [self addlabel_title:@"退出" frame:btnBackGO.frame view:btnBackGO];
        [self.view addSubview:btnBackGO];
        [btnBackGO release];
//>>>>>>> FETCH_HEAD
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)addOK{
    MagicRequest *request = [DYBHttpMethod shareBook_security_logout_sAlert:YES receive:self];
    [request setTag:2];


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
        s = [NSNumber numberWithInteger:arraySouce.count];
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
        
        UITableViewCell *cell = [[[UITableViewCell alloc]init] autorelease];
        
//        NSDictionary *dictInfoFood = nil;
//        [cell creatCell:dictInfoFood];
//        DLogInfo(@"%d", indexPath.section);
        NSString *strMsg = [arraySouce objectAtIndex:indexPath.row];
        [cell.textLabel setText:strMsg];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row == 2) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        switch (indexPath.row) {
            case 2:
            {
                ShareBookMangeAddrViewController *aa = [[ShareBookMangeAddrViewController alloc]init];
                [self.drNavigationController pushViewController:aa animated:YES];
                RELEASE(aa);
            
            }
                break;
            case 3:
            {
                
                
            }
                break;
            default:
                break;
        }
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}


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


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
//        [self goShowOrderListAction];
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


- (void)dealloc
{
    [arraySouce release];
    [super dealloc];
}
@end
