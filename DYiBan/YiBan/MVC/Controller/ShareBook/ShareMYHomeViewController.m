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
#import "ShareBookApplyViewController.h"
#define  RIGHTVIEWTAG 111

@interface ShareMYHomeViewController (){

    NSMutableArray *arrayResult;
    DYBUITableView  *tbDataBank1;
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
        MagicRequest *request = [DYBHttpMethod message_list_page:@"0" num:@"10000" sAlert:YES receive:self];
        [request setTag:1];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UIImage *image = [UIImage imageNamed:@"menu_inactive"];
        
        
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
        
        NSNumber *s = [NSNumber numberWithInteger:50];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ShareMessagerCell *cell = [[ShareMessagerCell alloc]init];
        
//        NSDictionary *dictInfoFood = Nil;
//        [cell creatCell:dictInfoFood];
        DLogInfo(@"%d", indexPath.section);
        [cell creatCell:[arrayResult objectAtIndex:indexPath.row]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ShareBookApplyViewController *apple = [[ShareBookApplyViewController alloc]init];
        
        apple.mi = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"order_id"];
        [self.drNavigationController pushViewController:apple animated:YES];
        
        
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
            
//                [self presentModalViewController:dou animated:NO];
                
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
                    
                    JsonResponse *response = (JsonResponse *)receiveObj; //登陆成功，记下
                  
                    arrayResult = [[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"] objectForKey:@"msg_list"]];
                    
                    [tbDataBank1 reloadData];
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
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
@end
