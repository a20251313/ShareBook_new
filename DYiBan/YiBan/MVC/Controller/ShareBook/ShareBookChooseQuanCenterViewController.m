//
//  ShareBookMyQuanCenterViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-25.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookChooseQuanCenterViewController.h"
#import "ShareBookDouCell.h"
#import "ShareAddQuanViewController.h"
#import "ShareBookQuanDetailViewController.h"
#import "WOSMapViewController.h"
#import "JSONKit.h"
#import "JSON.h"
#import "ShareBookCircleCell.h"

@interface ShareBookChooseQuanCenterViewController (){

    NSMutableArray *arrayResult;
    DYBUITableView * tbDataBank11;
    
    NSMutableSet   *m_selectSet;

}

@end

@implementation ShareBookChooseQuanCenterViewController

@synthesize  bEnter = _bEnter,arrayResult = _arrayResult,makesure;

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
        
            [self.rightButton setHidden:YES];
        if (!m_selectSet)
        {
            m_selectSet = [[NSMutableSet alloc] init];
            
            
         
        }
       
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
      
        if (!_bEnter) {
            
            MagicRequest *request = [DYBHttpMethod shareBook_circle_list:@"1" page:@"1" num:@"2000" lat:SHARED.locationLat lng:SHARED.locationLng sAlert:YES receive:self];
            [request setTag:3];
        }
        
        
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        

        
        UIButton *btnAll = [[UIButton alloc]initWithFrame:CGRectMake(20.0f,self.headHeight+10, 120.0f, 40.0f)];
        [btnAll setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnAll addTarget:self action:@selector(doAllChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAll];
        [self addlabel_title:@"全选" frame:btnAll.frame view:btnAll];
        RELEASE(btnAll);
        
     
        
        
        
        UIButton *btnAllNot = [[UIButton alloc]initWithFrame:CGRectMake(180.0f,self.headHeight+10, 120.0f, 40.0f)];
        [btnAllNot setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnAllNot addTarget:self action:@selector(doAllNotChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAllNot];
        [self addlabel_title:@"全不选" frame:btnAllNot.frame view:btnAllNot];
          RELEASE(btnAllNot);
        
        
        
        
        
        
        
        
    
        UIView *viewBGTableView = [[UIView alloc]initWithFrame:CGRectMake(10,self.headHeight + 70 , 300.0f , self.view.frame.size.height -self.headHeight - 50 - 70 - 30  )];
        
        [viewBGTableView setBackgroundColor:[UIColor whiteColor]];
        [viewBGTableView.layer setBorderWidth:1];
        [viewBGTableView.layer setCornerRadius:10.0f];
        [viewBGTableView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view addSubview:viewBGTableView];
        RELEASE(viewBGTableView);
        

    
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(20,self.headHeight + 70, 280.0f , self.view.frame.size.height -self.headHeight - 50 - 70 - 30 ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        tbDataBank11.allowsMultipleSelection = YES;
        
        RELEASE(tbDataBank11);
        
        int offset = 0;
        if (!IOS7_OR_LATER) {
            
            offset = 20;
        }
       
 
        UIButton *btnFinish = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(self.view.frame) - 50 - offset, 280.0f, 40.0f)];
        [btnFinish setTag:102];
        [btnFinish setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnFinish addTarget:self action:@selector(doFinishChoose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnFinish];
        RELEASE(btnFinish);
        
        [self addlabel_title:@"完成" frame:btnFinish.frame view:btnFinish];
        
        
        
//        [self creatDownBar];
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)dealloc
{
    RELEASE(_arrayResult);
    [super dealloc];
}
-(void)doAllChoose:(id)sender
{
    for (int i = 0;i < _arrayResult.count;i++)
    {
        [m_selectSet addObject:@(i)];
    }
    [tbDataBank11 reloadData];
}

-(void)doAllNotChoose:(id)sender
{
    [m_selectSet removeAllObjects];
    [tbDataBank11 reloadData];
}


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
                
                    _arrayResult  = [[NSArray alloc]initWithArray:[[dict objectForKey:@"data"]objectForKey:@"list"]];;

                    
                    
                    for (int i = 0;i < _arrayResult.count;i++)
                    {
                        [m_selectSet addObject:@(i)];
                    }
                    
                    [tbDataBank11 reloadData];
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
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
        //        if ([_section intValue] == 0) {
        s = [NSNumber numberWithInteger:_arrayResult.count];
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
        
        

        DLogInfo(@"%d", indexPath.section);
        
        NSDictionary *dictt = [_arrayResult objectAtIndex:indexPath.row];
    
        ShareBookCircleCell *cell = [[ShareBookCircleCell alloc] init];
        [cell creatCell:dictt];
        [signal setReturnValue:cell];
        
        
        UIButton    *btnCheck = [[UIButton alloc]initWithFrame:CGRectMake(230.0f, 10.0f, 30.0f, 30.0f)];
        [btnCheck setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
        [btnCheck setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateSelected];
        [btnCheck setTag:indexPath.row+10];
        [btnCheck addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnCheck];
        if ([self isHasIndex:indexPath.row set:m_selectSet])
        {
            [btnCheck setSelected:YES];
        }else
        {
            [btnCheck setSelected:NO];
        }
        
        RELEASE(btnCheck);
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        UITableViewCell *cell = [tbDataBank11 cellForRowAtIndexPath:indexPath];
        UIButton    *btnCheck = (UIButton*)[cell viewWithTag:indexPath.row+10];
        
         if ([self isHasIndex:indexPath.row set:m_selectSet])
        {
            [btnCheck setSelected:NO];
            [m_selectSet removeObject:@(indexPath.row)];
        }else
        {
            [btnCheck setSelected:YES];
            [m_selectSet addObject:@(indexPath.row)];
        }
        
        
        DLogInfo(@"TABLEDIDSELECT m_selectSet:\n%@\n",m_selectSet);
        /*
        if (bselct) {
            
            NSDictionary *dict1 = [_arrayResult objectAtIndex:indexPath.row];
            
            [makesure.labelAutoQuan1 setText:[dict1 objectForKey:@"circle_name"]];
            
            makesure.dictResult = dict1;
            [self.drNavigationController popViewControllerAnimated:YES];
            return;
        }
        
        ShareBookQuanDetailViewController *detail = [[ShareBookQuanDetailViewController alloc]init];
        detail.dictInfo = [_arrayResult objectAtIndex:indexPath.row];
        [self.drNavigationController pushViewController:detail animated:YES];
        RELEASE(detail);*/
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}


-(BOOL)isHasIndex:(NSInteger)index set:(NSMutableSet*)set
{
    for (NSNumber *number in set)
    {
        if (index == [number intValue])
        {
            return YES;
        }
    }
    return NO;
    
}

-(void)doSelect:(UIButton*)sender
{
    //UITableViewCell *cell = (UITableViewCell*)sender.superview;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 10 inSection:0];
    if ([self isHasIndex:indexPath.row set:m_selectSet])
    {
        [sender setSelected:NO];
        [m_selectSet removeObject:@(indexPath.row)];
    }else
    {
        [sender setSelected:YES];
        [m_selectSet addObject:@(indexPath.row)];
    }
    
}

-(void)doFinishChoose
{
    NSString    *strQuanzi = nil;
    NSMutableArray  *arrayID = [NSMutableArray array];
    for (NSNumber *number in m_selectSet)
    {
        NSDictionary   *dicInfo = [_arrayResult objectAtIndex:[number intValue]];
        if (!strQuanzi)
        {
            strQuanzi = [dicInfo valueForKey:@"circle_name"];
        }else
        {
            strQuanzi = [strQuanzi stringByAppendingFormat:@",%@",[dicInfo valueForKey:@"circle_name"]];
        }
        
        if ([dicInfo valueForKey:@"circle_id"])
        {
            [arrayID addObject:[dicInfo valueForKey:@"circle_id"]];
        }
       
        
    }
    
    [makesure.labelAutoQuan1 setText:strQuanzi];
    makesure.arrayResult = arrayID;
    //makesure.dictResult = dict1;
    [self.drNavigationController popViewControllerAnimated:YES];
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



@end
