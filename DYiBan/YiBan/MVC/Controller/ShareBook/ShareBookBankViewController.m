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
#import "ShareSearchBookViewController.h"

#import "JSONKit.h"
#import "JSON.h"
@interface ShareBookBankViewController (){
    
    UIScrollView *scrollView;
    NSArray *arraySouce;
    DYBUITableView * tbDataBank11;
    NSMutableArray *arrayReturnSouce;
}

@end

@implementation ShareBookBankViewController

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
        [self.headview setTitle:@"图书"];
        
//        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.leftButton setHidden:YES];
        [self setButtonImage:self.rightButton setImage:@"icon_search"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:17.0f/255 green:22.0f/255 blue:27.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
      
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
   [self.leftButton setHidden:YES];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight , 320.0f, self.view.frame.size.height - self.headHeight)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        arraySouce = [[NSArray alloc]initWithObjects:@"全部",@"少儿",@"科技",@"其他",@"全部",@"少儿",@"科技",@"其他", nil];
        
        [self creatSelectType:arraySouce];
        
        UIImage *image = [UIImage imageNamed:@"options_bg"];
        DLogInfo(@"dddd %@",SHARED.userId);
        MagicRequest *request = [DYBHttpMethod shareBook_book_list_tag_id:SHARED.userId sAlert:YES receive:self];
        [request setTag:2];
        
        
        
       tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, self.headHeight + image.size.height/2, 320.0f, self.view.frame.size.height - self.headHeight -image.size.height/2 ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)creatSelectType:(NSArray *)arraySource{

    UIImage *imageSouce = [UIImage imageNamed:@"options_bg"];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, imageSouce.size.width/2 * 4, imageSouce.size.height/2)];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    UIImage *imageMoer = [UIImage imageNamed:@"add_bt"];
    
    UIButton *btnMore = [[UIButton alloc]initWithFrame:CGRectMake(imageSouce.size.width/2 * 4, self.headHeight, imageMoer.size.width/2 , imageMoer.size.height/2)];
    [btnMore setImage:imageMoer forState:UIControlStateNormal];
    [btnMore setBackgroundColor:[UIColor clearColor
                                 ]];
    [btnMore addTarget:self action:@selector(doMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMore];
    [btnMore release];
    
    int offset = imageSouce.size.width/2;
    for (int i = 0; i < arraySource.count; i++) {
        
        UIButton *btnTouchType = [[UIButton alloc]initWithFrame:CGRectMake(i * offset, 0, offset, imageSouce.size.height/2)];
       
//        i%2 == 0 ? [btnTouchType setBackgroundColor:[UIColor redColor]]:[btnTouchType setBackgroundColor:[UIColor yellowColor]];
        [btnTouchType setImage:[UIImage imageNamed:@"options_bg"] forState:UIControlStateNormal];
        [btnTouchType setImage:[UIImage imageNamed:@"click_bg"] forState:UIControlStateSelected];
        [btnTouchType setTag:10 + i];
        [btnTouchType addTarget:self action:@selector(doChoose:) forControlEvents:UIControlEventTouchUpInside];
        [btnTouchType setTitle:[arraySource objectAtIndex:i] forState:UIControlStateNormal];
        [self addlabel_title:[arraySouce objectAtIndex:i] frame:btnTouchType.frame view:btnTouchType];
        [scrollView addSubview:btnTouchType];
        [btnTouchType release];
        
        if (i == 0) {
            [btnTouchType setSelected:YES];
        }
    }
    [scrollView setContentSize:CGSizeMake(offset * arraySource.count, 44)];
}

-(void)doChoose:(id)sender{

    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i <arraySouce.count; i++) {
        
        UIButton *btnT = (UIButton *)[scrollView viewWithTag:10+i];
        if (btn.tag ==  btnT.tag) {
            
            [btnT setSelected:YES];
        }else{
            
            [btnT setSelected:NO];
        }
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


-(void)doMore{
    
    [UIView animateWithDuration:0.4 animations:^{
      [scrollView setContentOffset:CGPointMake(320/5 * 2, 0)];
    }];
  

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
        //        cell.type = _type;
        cell.indexPath = indexPath;
        [cell creatCell:[arrayReturnSouce objectAtIndex:indexPath.row]];
//        NSDictionary *dictInfoFood = nil;
//        [cell creatCell:dictInfoFood];
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
        
        ShareSearchBookViewController *searchBook = [[ShareSearchBookViewController alloc]init];
        
        [self.drNavigationController pushViewController:searchBook animated:YES];
        [searchBook release];
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
                    
                    arrayReturnSouce = [[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"data"] objectForKey:@"book_list"]];
                    
                    [tbDataBank11 reloadData];
//
//                    self.DB.FROM(USERMODLE)
//                    .SET(@"userInfo", request.responseString)
//                    .SET(@"userIndex",[dict objectForKey:@"user_id"])
//                    .INSERT();
//                    
//                    SHARED.userId = [dict objectForKey:@"user_id"]; //设置userid 全局变量
//                    
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
                if (!result) {
                    
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
