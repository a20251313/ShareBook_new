//
//  WOSMapViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-12-25.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "JSONKit.h"
#import "JSON.h"
#import "WOSMapViewController.h"
#import "MapViewController.h"
#import "ShareBookMyQuanCenterViewController.h"
#import "ShareBookQuanDetailViewController.h"
#import "ShareAddQuanViewController.h"

@interface WOSMapViewController ()<CLLocationManagerDelegate>{
    MapViewController*   _mapViewController;
    NSMutableArray *arrayResult;
    
    BOOL           m_bHasNext;
    int            m_iCurrentPage;
    int            m_iPageNum;

    }

@end

@implementation WOSMapViewController

@synthesize iType,dictMap = _dictMap ,bIsMyQuan = _bIsMyQuan;
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
        [self.headview setTitle:@"附近的圈子"];
        
    
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];

        if (self.bShowLeft)
        {
            [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        }
       
        
        if (_bIsMyQuan) {
            
            [self.rightButton setHidden:YES];
            [self.headview setTitle:@"圈子"];
            
        }else{
        
            [self setButtonImage:self.rightButton setImage:@"icon_list"];
        }
        
        
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
       
        
        
    
        m_iPageNum = 1000;
        m_iCurrentPage = 1;
        if (!self.bShowLeft)
        {
            [self.leftButton setHidden:YES];
            
           
        }
        int offset = 0;
        if (!IOS7_OR_LATER) {
            
            offset = 20;
        }
      
        
        if (!_mapViewController)
        {
            _mapViewController = [[MapViewController alloc] initWithFrame:CGRectMake(0.0f, 0 , 320.0f, self.view.bounds.size.height)];
            _mapViewController.delegate = self;
            _mapViewController.target = self;
            [self.view insertSubview:_mapViewController atIndex:0];
            
        }
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(self.view.frame) - 100 - offset, 280.0f, 44)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"bt_click1"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addQuan) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: btn];
        RELEASE(btn);
        [self addlabel_title:@"创建乐享圈" frame:btn.frame view:btn];
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
   
        
        if (!arrayResult.count)
        {
            m_iCurrentPage = 1;
            m_bHasNext = NO;
            [self getCircleList];
        }
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



-(void)getCircleListByInfo:(NSNotification*)note
{
    m_iCurrentPage = 1;
    [self getCircleList];
}
-(void)getCircleList
{
    if ([SHARED.locationLat intValue] == 0 && [SHARED.locationLng intValue] == 0)
    {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCircleListByInfo:) name:@"UpdateUserLocation" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    
    DLogInfo(@"getCircleList lat:%@ lng:%@",SHARED.locationLat,SHARED.locationLng);

    
    NSString    *type = @"2";
    if (self.bIsMyQuan)
    {
        type = @"1";
    }
        MagicRequest *request = [DYBHttpMethod shareBook_circle_list:type page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] lat:SHARED.locationLat lng:SHARED.locationLng sAlert:YES receive:self];
        [request setTag:100];

    
}

-(void)getCircleNearList
{
    
    
    DLogInfo(@"----------------------\n\ngetCircleList:%@ %@\n\n\n",SHARED.locationLat,SHARED.locationLng);
    MagicRequest *request = [DYBHttpMethod book_circle_nearby:SHARED.locationLng lat:SHARED.locationLat page:[@(m_iCurrentPage) description] num:[@(m_iPageNum) description] range:@"100" sAlert:YES receive:self];
    [request setTag:3];
    
    
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

-(void)addQuan{

    ShareAddQuanViewController *add = [[ShareAddQuanViewController alloc]init];
    [self.drNavigationController pushViewController:add animated:YES];

    RELEASE(add);
}

-(void)doSelect:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    for (int i = 10; i < 13; i++) {
        
        
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:i];
        if (i == btn.tag) {
            
            [btn1 setTitleColor:ColorTextYellow forState:UIControlStateNormal];
        }else{
            
            [btn1 setTitleColor:ColorGryWhite forState:UIControlStateNormal];
        }
    }
}



- (void)customMKMapViewDidSelectedWithInfo:(id)info
{
    NSLog(@"%@",info);
    ShareBookQuanDetailViewController *detail = [[ShareBookQuanDetailViewController alloc]init];
    detail.dictInfo = info;
    [self.drNavigationController pushViewController:detail animated:YES];
    RELEASE(detail);
}




- (void)handleViewSignal_MapViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MapViewController TOUCHANNITION]]) {

        ShareBookQuanDetailViewController *detail = [[ShareBookQuanDetailViewController alloc]init];
        [self.drNavigationController pushViewController:detail animated:YES];
        RELEASE(detail);
    }

}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        ShareBookMyQuanCenterViewController *mapList = [[ShareBookMyQuanCenterViewController alloc]init];
        [mapList setTitle:@"附近的圈子"];
        [self.drNavigationController pushViewController:mapList animated:YES];
        RELEASE(mapList);
    }
}


#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
       if(request.tag == 100){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    
                    if (!arrayResult)
                    {
                        arrayResult = [[NSMutableArray alloc] init];
                    }
                    
                    [arrayResult addObjectsFromArray:[[dict objectForKey:@"data"]objectForKey:@"list" ]];
                    
                    [self resortDataInfo];
                    
                    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:1000];
                    
                    for (NSDictionary *dictMap in arrayResult)
                    {
                    
                        NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:[dictMap objectForKey:@"lat"],@"latitude",[dictMap objectForKey:@"lng"],@"longitude",[dictMap objectForKey:@"circle_id"],@"circle_id",nil];
                        [array addObject:dic1];
                    }
                    
                    
                    if (!_mapViewController)
                    {
                        _mapViewController = [[MapViewController alloc] initWithFrame:CGRectMake(0.0f, 0 , 320.0f, self.view.bounds.size.height)];
                        _mapViewController.delegate = self;
                        _mapViewController.target = self;
                        [self.view insertSubview:_mapViewController atIndex:0];
                        
                    }
                    
                    
                    [_mapViewController setFrame:CGRectMake(0.0f, 0 , 320.0f, self.view.bounds.size.height)];
                    [_mapViewController resetAnnitations:array];
                    _mapViewController.arrayResuce = arrayResult;
                    
                    m_bHasNext = [[[dict objectForKey:@"data"] objectForKey:@"havenext"] boolValue];
                    if (m_bHasNext)
                    {
                        m_iCurrentPage++;
                        [self getCircleList];
                    }
                    
                   
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


-(void)resortDataInfo
{
    [arrayResult sortUsingComparator:^NSComparisonResult(id obj1,id obj2)
     {
         NSString    *strOne = [[obj1 valueForKey:@"distance_num"] lowercaseString];
         NSString    *strTwo = [[obj2 valueForKey:@"distance_num"] lowercaseString];
         strOne = [strOne stringByReplacingOccurrencesOfString:@"km" withString:@""];
         strTwo = [strTwo stringByReplacingOccurrencesOfString:@"km" withString:@""];
         strOne = [strOne stringByReplacingOccurrencesOfString:@"," withString:@""];
         strTwo = [strTwo stringByReplacingOccurrencesOfString:@"," withString:@""];
         if ([strOne floatValue] < [strTwo floatValue])
         {
             return NSOrderedDescending;
         }else
         {
             return NSOrderedAscending;
         }
         return NSOrderedSame;
     }];
    


}

- (void)dealloc
{
    
    [super dealloc];
}






@end
