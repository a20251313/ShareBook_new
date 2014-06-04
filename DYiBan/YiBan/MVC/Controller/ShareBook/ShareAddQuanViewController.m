//
//  ShareAddQuanViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-24.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareAddQuanViewController.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "JSONKit.h"
#import "JSON.h"


@interface ShareAddQuanViewController (){

    BMKMapView * _mapView ;
    CLLocationManager *locManager;

    DYBInputView  *_phoneInputName;
    UILabel *labelJINWEI;
    CLLocationCoordinate2D coordinate2D;

}

@end

@implementation ShareAddQuanViewController

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
        [self.headview setTitle:@"添加圈子"];
        
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
        
        [self doSure_getSource];
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 10, 100.0f, 40.0f)];
        [labelName setText:@"圈子名称："];
        [self.view addSubview:labelName];
        RELEASE(labelName);
        [labelName setBackgroundColor:[UIColor clearColor]];

        _phoneInputName = [[DYBInputView alloc]initWithFrame:CGRectMake(100,self.headHeight + 10, 200, 35) placeText:@"天山小区" textType:0];
        [_phoneInputName.layer AddborderByIsMasksToBounds:YES cornerRadius:3 borderWidth:1 borderColor:[[UIColor colorWithRed:188.0f/255 green:188.0f/255 blue:188.0f/255 alpha:1.0f] CGColor]];
        //        [_phoneInputName.nameField setText:@"1"];
        [_phoneInputName.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputName setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_phoneInputName];
        RELEASE(_phoneInputName);
        
        labelJINWEI = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(_phoneInputName.frame) + CGRectGetMinY(_phoneInputName.frame), 300.0f, 40.0f)];
        [labelJINWEI setText:@"经纬度   ： -20.03，-113.75"];
        [self.view addSubview:labelJINWEI];
        RELEASE(labelJINWEI);
        
        [labelJINWEI setBackgroundColor:[UIColor clearColor]];
     
        

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd "];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        
        
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelJINWEI.frame) + CGRectGetMinY(labelJINWEI.frame), 250.0f, 40.0f)];
        [labelTime setText:[ NSString stringWithFormat:@"创建时间：%@",currentDateStr]];
       [self.view addSubview:labelTime];
        RELEASE(labelTime);
        [labelTime setBackgroundColor:[UIColor clearColor]];

        
        UIImage *image = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(labelTime.frame) + CGRectGetMinY(labelTime.frame) + 50, 280.0f, 40.0f)];
        [btnOK setTag:102];
        [btnOK setImage:image forState:UIControlStateNormal];
//        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnOK addTarget:self action:@selector(doChoose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK];
        RELEASE(btnOK);
        
        [self addlabel_title:@"创建乐享圈" frame:btnOK.frame view:btnOK];
        
               DYBUITableView * tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0,200 , 320.0f , self.view.frame.size.height -100 - 60 - 100  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
//        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
//        RELEASE(tbDataBank11);
        
        
        
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
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}


-(void)doChoose{
 
//    sAlert:(BOOL)isAlert receive:(id)receive;
    MagicRequest *request = [DYBHttpMethod shareBook_circle_add_circle_name:_phoneInputName.nameField.text
                                address:@"d1d"
                                    lat:[NSString stringWithFormat:@"%f",coordinate2D.latitude ]
                                         
                                    lng:[NSString stringWithFormat:@"%f",coordinate2D.longitude ]
                                    kind:@"1" sAlert:YES receive:self];
    [request setTag:2];

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
                    
                    JsonResponse *response = (JsonResponse *)receiveObj; //登陆成功，记下
                    [DYBShareinstaceDelegate popViewText:@"创建成功" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
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



-(void)doSure_getSource{

    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 5.0;
    [locManager startUpdatingLocation];

    
}
//
///**
// *用户位置更新后，会调用此函数
// *@param mapView 地图View
// *@param userLocation 新的用户位置
// */
//
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        
        //        CLLocationDistance radiusMeters = 500; //设置搜索范围
        //        [_search poiMultiSearchNearBy:@[@"学校", @"美食", @"小区", @"交通"] center:_mapView.centerCoordinate radius:radiusMeters pageIndex:0];
        
        //        [_searchTest reverseGeocode:mapView.userLocation.location.coordinate];
	}
    
}
///**
// *在地图View停止定位后，会调用此函数
// *@param mapView 地图View
// */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}
//
///**
// *定位失败后，会调用此函数
// *@param mapView 地图View
// *@param error 错误号，参考CLError.h中定义的错误号
// */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
//
//
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
    NSLog(@"%@", result.strAddr);
    
  }
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    coordinate2D.latitude = newLocation.coordinate.latitude;
    coordinate2D.longitude = newLocation.coordinate.longitude;
    
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         NSLog(@"%@",placemarks);
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSArray *names = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
         
         if (_phoneInputName.nameField.text.length == 0) {
             
         
             if (names.count>0) {
                  [_phoneInputName.nameField setText:[names objectAtIndex:0 ]];
             }else{
             
              [_phoneInputName.nameField setText:[placemark.addressDictionary objectForKey:@"Name"]];
             }
             
             NSString *newLocation1 = [NSString stringWithFormat:@"经纬度   ：%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
             
             [labelJINWEI setText:newLocation1];

         }
         
         
         
     }];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


@end
